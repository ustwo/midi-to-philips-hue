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

class Control

	# a "control" is an action on the controller:
	# a button press or movement on a slider or knob

	TYPE_CONTROL_CHANGE = 144 # <-- button
	TYPE_NOTE_COMMAND = 176 # <-- sliders, knobs

	# sliders and knobs return values between 0 and 127
	MAX_NOTE_COMMAND_VALUE = 127

	DECK_A_SCRATCH = 17
	DECK_A_PLAY = 18
	DECK_A_CUE = 19
	DECK_A_LOW_KNOB = 3
	DECK_A_MID_KNOB = 4
	DECK_A_HIGH_KNOB = 5
	DECK_A_KILL_LOW = 12
	DECK_A_KILL_MID = 13
	DECK_A_KILL_HIGH = 14

	attr_accessor :type, :id, :value, :percentage

	def initialize(type, id, value)
		self.type = type
		self.value = value.to_i
		self.id = id

		if type == TYPE_NOTE_COMMAND
			self.percentage = self.value / MAX_NOTE_COMMAND_VALUE.to_f
		end
	end
end