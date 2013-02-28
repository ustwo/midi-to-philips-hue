=begin
The MIT License (MIT)

Copyright (c) 2013 ustwo.co.uk

Permission is hereby granted, free of charge, to any person obtaining 
a copy of this software and associated documentation files (the "Software"), 
to deal in the Software without restriction, including without limitation 
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or 
sell copies of the Software, and to permit persons to whom the Software is 
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in 
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
=end

require 'unimidi'
require './behringer_parser'

Dir["./lib/rubyhue/*.rb"].each {|file| require file }

MAX_HUE = 65535
MAX_SATURATION = 254

# these are some nice red, green
# and blue colours, expressed as a 
# percentage of MAX_HUE
H_RED = 0
H_GREEN = 0.4
H_BLUE = 0.7

# controller selection
case UniMIDI::Input.all.length
	when 0
		abort("Cannot find a MIDI controller, aborting")
	when 1
		@input = UniMIDI::Input.first.open
		puts "MIDI controller found: #{@input.pretty_name}"
	else
		@input = UniMIDI::Input.gets
end

# adding bulbs
@bulbs = []
@bulbs << Hue::Bulb.new(1)
@bulbs << Hue::Bulb.new(2)
@bulbs << Hue::Bulb.new(3)

# initial state
@on = [false, false, false]

@party_thread = nil

def init_lights

	# set initial state and colour
	for i in 0..@bulbs.length - 1
		update_state(i, @on[i])
		update_color(i, H_RED, 0)
	end
end

def update_color(bulb, percentage, transition)
	bulb = @bulbs[bulb]
	bulb.update hue: (MAX_HUE * percentage).to_i, transition: transition, sat: MAX_SATURATION
end

def update_state(bulb, state)
	@on[bulb] = state
	bulb = @bulbs[bulb]
	bulb.update on: state
end

def toggle_light(bulb)
	update_state(bulb, !@on[bulb])
end

def toggle_party_mode()

	if @party_thread != nil

		puts "Exiting party mode :/"
		
		Thread.kill(@party_thread)
		@party_thread = nil
	else
		
		puts "Entering party mode!"
		@party_thread = Thread.new(){
			
			rainbow = []
			rainbow << [H_RED, H_GREEN, H_BLUE]
			rainbow << [H_BLUE, H_RED, H_GREEN]
			rainbow << [H_GREEN, H_BLUE, H_RED]

			# just loop through the party colours
			i = 0
			loop do

				for j in 0..@bulbs.length - 1
					update_color(j, rainbow[i][j], 0)
				end

				i += 1
				if i >= rainbow.length
					i = 0
				end

				sleep 0.1
			end
		}
	end

end

init_lights()

# main app loop
loop do

	control = BehringerParser.parse(@input.gets)

	# for controls that act as buttons, we only act
	# when the control is released (value == 0)

	if control != nil
		case control.id

			# toggle party mode
			when Control::DECK_A_CUE
				if control.value == 0
					toggle_party_mode()
				end

			# turns on all the lights
			when Control::DECK_A_PLAY
				if control.value == 0
					for i in 0..@bulbs.length - 1
						update_state(i, true)
						update_color(i, H_RED, 0)
					end
				end

			# turns off all the lights
			when Control::DECK_A_SCRATCH
				if control.value == 0
					for i in 0..@bulbs.length - 1
						update_state(i, false)
					end
				end				

			# pass % of the knob to calculate the colour
			when Control::DECK_A_LOW_KNOB
				update_color(0, control.percentage, 0)

			when Control::DECK_A_MID_KNOB
				update_color(1, control.percentage, 0)

			when Control::DECK_A_HIGH_KNOB
				update_color(2, control.percentage, 0)

			# toggle on/off individual lights
			when Control::DECK_A_KILL_LOW
				if control.value == 0
					toggle_light(0)
				end

			when Control::DECK_A_KILL_MID
				if control.value == 0
					toggle_light(1)
				end

			when Control::DECK_A_KILL_HIGH
				if control.value == 0
					toggle_light(2)
				end
		end
	end
end