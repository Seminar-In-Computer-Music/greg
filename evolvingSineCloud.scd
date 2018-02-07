{LFNoise0.ar(4);}.scope;

s.options.device = "kdjsnfksjdfn";
(
{SinOsc.ar(
	LFNoise1.ar(
		LFNoise0.kr(2, 2, 1.1), 200, 500),
	0, 0.6);
}.play;
)

{SinOsc.ar(LFNoise1.ar(LFNoise0.kr(2,5,7).poll(4, "rate"),500,10000).poll(4, "blah"),0, 0.6);}.play;

(
SynthDef(\evolvingSine, {|amp=0.6, pan=0, mult=200, add=500|
	Out.ar(0, Pan2.ar(SinOsc.ar(
	LFNoise1.ar(
		LFNoise0.kr(2, 5, 7), mult, add),
		0, amp), pan)
	);
}).add;
)

Synth.new(\evolvingSine, [\amp, 0.1]);
(
var amount;
amount = 50;
a = Array.fill(amount, {arg i;
	Synth.new(\evolvingSine, [\amp, (1/amount).sqrt/2, \pan, (i/amount)*2-1]);
});
)

a[1].stop;
a[2].stop;
(
for(10, 20, {arg i;
	var lowFreq = 800*(i+1);
	var highFreq = 10000;
	var mult = (highFreq - lowFreq)/2;
	var add = mult + lowFreq;
	a[i].set(\mult, mult, \add, add);});
)
