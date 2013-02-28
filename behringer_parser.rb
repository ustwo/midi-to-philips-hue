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

require './control'

class BehringerParser

	# This parsing is tight to how the BCD3000 sends data.
	# Parsing the data from other controllers can't be much
	# different, but little differences might break this.
	# If you are unsure about which data your controller is
	# sending, try running:
	# ruby test.rb
	# which should output all data coming from your device.
	# Then you'll probably need to adjust this accordingly!

	# Please note that we are discarding A LOT
	# of MIDI data here. The reason being that the Hue
	# has not been designed to be quick to react. 
	# There's nothing wrong with that, it only 
	# means that you have to be careful not to send
	# too many requests.

	# If you wanted to react to all the data coming
	# from the device, you would need a loop like
	# this:

	# input each.do |midi|
	# 	data.midi[:data] do |value|
	# 		# do something here
	# 	end
	# end

	def self.parse(input)

		control = nil

		data = input[0][:data]

		# we expect arrays that are either:
		# [type, id, value]
		# or
		# [type, id]
		# when there's no value, we assume value is 0
		# we discard everything else

		combined = data.join("_")

		# really looks like this: /(176|144)_(\d)+_?/
		reg = Regexp.new('(' + Control::TYPE_CONTROL_CHANGE.to_s + '|' + Control::TYPE_NOTE_COMMAND.to_s + ')_(\d)+_?')

		if reg.match(combined)

			type = data[0]
			id = data[1]
			value = data[2]

			if value == nil
				value = 0
			end

			control = Control.new(type, id, value)
		end

		control
	end
end