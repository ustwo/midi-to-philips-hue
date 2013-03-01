MIDI controller to Philips Hue lights

This is a proof of concept that hooks up a MIDI controller
(Behringer BCD3000) to a set of Philips Hue lights.

All controls from deck A:

* PLAY > turns on the lights and sets default colour
* LOW, MID and HIGH > changes hue colour of each bulb
* LOW, MID and HIGH CUTS > toggle on/off each light
* CUE > party mode!
* SCRATCH > turns of all the lights

This is a rough description of how it works:

* If there is only one MIDI controller, select it, otherwise ask the user
* Connect to the Hue hub and set the initial state and colour (requires hub IP address and API key)
* Enters a loop picking up what happens on the controller
* If we have an action "mapped", we act on it, otherwise ignore

Requires unimidi (as a gem) and RubyHue (attached with minor modifications).

Read more about it on the ustwo blog:

http://www.ustwo.co.uk/blog/midi-controller-to-philips-hue/
