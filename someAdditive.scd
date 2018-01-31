(
SynthDef(\something, { |fund=220, ratio = 1, dur=1, amp=1|
	var sound = Mix.ar(SinOsc.ar(fund*ratio*[1.0,1.3,3,2.5], 0, [0.5,0.3,0.1,0.1]));
	sound = sound + BPF.ar(WhiteNoise.ar(0.1), fund*ratio, 10);
	sound = sound * EnvGen.kr(Env.perc(0.01, dur), doneAction: 2)*amp;
	Out.ar(0, sound.dup);
}).add;
)

Synth(\something);

s.options.device = "ASIO: ASIO4ALL";
(
var a,b;
a = Pbind(\instrument, \something,
	\fund, Pseq([220,330,440,550], inf),
	\ratio, Prand([7/6,9/8,3/2,4/3,1,2, 11/10], inf),
	\dur, Prand([
		Pseq([1,2,0.5,1,0.75],1),
		Pseq([0.25, 0.5, 0.75, 1],1)], inf),
	\amp, Pwhite(0.5,0.8,inf)
);
b = Pbind(\instrument, \something,
	\fund, Pseq([110], inf),
	\ratio, Prand([7/6,9/8,3/2,4/3,1,2, 11/10], inf),
	\dur, Prand([1,0.5,0.33], inf),
	\amp, Pwhite(0.3,0.6,inf)
);

Pdef(\a, Ppar([a,b]));
)
c.play;
Pdef(\a).play;
Pdef(\a).stop;
