/*
Greg Kappes
Working with Pbinds and SynthDefs

Evaluate the big blocks of code and then you can play with the Pdef's at the bottom of the page
*/

//making a simple Pdef composed of filtered white noise and a bank of sines
(
SynthDef(\something, { |fund=220, ratio = 1, dur=1, amp=1, pan=0| //frequency of synth determined by fund*ratio, dur=duration
	//we can use Mix to sum multiple sine waves into a mono signal
	//by using an array of frequencies and an array of amplitudes, you can perform some simple additive synthesis
	var sound = Mix.ar(SinOsc.ar(fund*ratio*[1.0,1.3,3,2.5,5.01,6.95], 0, [0.5,0.1,0.2,0.1, 0.05, 0.05]));
	//here i'm adding a bit of filtered white noise
	sound = sound + BPF.ar(WhiteNoise.ar(0.1), fund*ratio, 10);
	//multiplying the sound by an envelope as well as by the amp argument
	sound = sound * EnvGen.kr(Env.perc(0.01, dur), doneAction: 2)*amp;
	//sending it to the out bus while also panning the mono signal using the pan argument
	Out.ar(0, Pan2.ar(sound,pan));
}).add;
)
(
//here i'm setting up two pbind's to make some semi-random patterns
var a,b;
//higher melody
a = Pbind(\instrument, \something,
	\fund, Pseq([220,330,440,550], inf), //simple sequence
	\ratio, Prand([7/6,9/8,3/2,4/3,1,2, 11/10], inf), //simple random sequence
	\dur, Pwrand([
		Pseq([1,2,0.5,1,0.75],1),
		Pseq([0.25, 0.5, 0.75, 1],1),
		Pseq([0.1,0.25,0.125,0.075],1)
	], [3,3,1].normalizeSum, inf), //a weighted random sequence, check out the help file. good for some algorithmic goodness
	\amp, Pwhite(0.5,0.8,inf), //Pwhite gives a random value within the range lo-hi (here 0.5-0.8)
	\pan, Pwrand([-1,-0.5,0,0.5,1], [1,3,5,3,1].normalizeSum, inf)
);
//more steady "bassline"
b = Pbind(\instrument, \something,
	\fund, Pseq([110], inf),
	\ratio, Prand([7/6,9/8,3/2,4/3,1,2, 11/10], inf),
	\dur, Pwrand([1,0.5,0.33], [4,3,2].normalizeSum, inf),
	\amp, Pwhite(0.5,0.7,inf),
	\pan, Pwrand([-1,-0.5,0,0.5,1], [5,2,1,2,5].normalizeSum, inf)
);
//combining a and b into a Pdef here using Ppar which will run both patterns simultaneously (IE in parallel)
Pdef(\a, Ppar([a,b]));
)

Pdef(\a).play;
Pdef(\a).stop;
