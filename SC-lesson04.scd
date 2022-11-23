// Multichannel expansion -> this leads to Additive synthesis
// Splay, sum.
// Iterating over arrays: do, sum, collect.
// Array methods like .reverse, .mirror, .mirror2.

s.meter;
s.plotTree;
// Busses (reverb)
// Clocks

// Basics of filtering - Substractive synthesis
// LPF, HPF, BPF,
// Delay based filters (Comb, Delay)

~reverbBus = Bus.audio(s, 2);

(
~verb.free;
~verb = {
    var x = MouseX.kr(-1, 1);
    var input = In.ar(~reverbBus, 2);
    var reverb = JPverb.ar(input, 5);
    var sig = XFade2.ar(input, reverb, x);
    sig;
}.play;
)

(
SynthDef.new(\tri, {
    arg freq = 54, atk = 0.1, dec = 0.1, sustime = 0.8, suslevel = 0.5, rel = 2,
    amp = 1, pan = 0, lfoFreq = 3;
    var env = Env.new([0, 1, suslevel, suslevel, 0], [atk, dec, sustime, rel]);
    var envSig = EnvGen.ar(env, doneAction: 2);
    var lfo = SinOsc.kr(lfoFreq).unipolar;
    var sig = LFTri.ar(freq.midicps) * envSig * amp * lfo;
    sig = Pan2.ar(sig, pan);
    Out.ar(~reverbBus, sig);
}).add;
)

(
~melody.stop;
~melody = Pbind(
    \instrument, \tri,
    \dur, Prand([0.25, 0.5, 0.75, 1, 1.5], inf),
    \freq, ~toMidi.("Gb3") + Prand(Scale.lydian.degrees, inf) + Prand([-12, 0, 12], inf),
    \atk, 0.001,
    \dec, 0.05,
    \sustime, 0,
    \suslevel, 0.5,
    \rel, 0.05,
    \amp, 0.5,
    \pan, Pwhite(-1.0, 1.0, inf),
    \lfoFreq, Prand([1, 2, 3, 4, 6, 8, 9, 12, 16] / 3, inf)
).play();
)