// SuperCollider Course
// Fall 2022 - Winter 2023
// Lesson No. 9 --- Granular Synthesis A

~path = "/Users/guillaumepelletier/Desktop/Dropbox/Art/p5/SuperCollider-Lessons/classical-guitar-chord.wav"
~chordStereo = Buffer.read(s, ~path);
~chordStereo.play;


// ---------------------------------------------------------------------
// Granular synthesis with a Pbind.
// ---------------------------------------------------------------------

// Our basic SynthDef.
(
SynthDef(\samplerStereo, {
    arg buf, rate = 1, spos = 0, pan = 0, amp = 1, atk = 0.1, rel = 0.1, out = 0;
    var env = EnvGen.kr(Env.new([0, 1, 0], [atk, rel]), doneAction: 2);
    var sig = PlayBuf.ar(2, buf, rate * BufRateScale.ir(buf), startPos: BufFrames.ir(buf)*spos);
    // sig = sig[0];
    sig = Balance2.ar(sig[0], sig[1], pan) * env * amp;
    // sig = Pan2.ar(sig[0], pan) * env * amp;
    Out.ar(out, sig);
}).add;
)

// The shape of a single grain.
(
Synth.new(\samplerStereo, [
    \buf, ~chordStereo,
    \spos, 0.2,
    \atk, 0.125,
    \rel, 0.125,
    \rate, -5.midiratio,
]);
)

x = Pseries(0,0.1,10).asStream;
x.next
// An infinite stream of grains.
(
~granular.stop;
~granular = Pbind(
    \instrument, \samplerStereo,
    \buf, ~chordStereo,
    \dur, 1 / 128 / 2,
    \spos, 0.1,
    \spos, 0.05 + Pwhite(-0.01, 0.01, inf),
    \spos, 0.05 + Pwhite(-0.05, 0.05, inf) + Pseq(((0..7)/10).stutter(128), inf),
    \spos, 0.6 + Pwhite(-0.01, 0.01, inf) + Pseq([Pseries(0,0.1/500,1500)],inf),
    \atk, 0.125 * 0.5,
    \rel, 0.125 * 0.5,
    // \rate, [0.5, 1],
    \amp, 1,
    \rate, 1,
    // \rate, Pseq([0.5, 1], inf),
    // \rate, 1 * ([0, 3, 7, 14]+12).midiratio,
    \pan, Pwhite(-1.00, 1.00, inf)
).play();
)

// An alternative version of the SynthDef
// for scanning through the sample with MouseX.
(
SynthDef(\samplerStereo, {
    arg buf, rate = 1, spos = 0, pan = 0, amp = 1, atk = 0.1, rel = 0.1, out = 0;
    var env = EnvGen.kr(Env.new([0, 1, 0], [atk, rel]*0.1), doneAction: 2);
    var scanX = MouseX.kr(0, 1) + Rand(-0.01, 0.01);
    var sig = PlayBuf.ar(2, buf, rate * BufRateScale.ir(buf), startPos: BufFrames.ir(buf)*scanX);
    sig = Balance2.ar(sig[0], sig[0], pan) * env * amp;
    // scanX.poll;
    Out.ar(out, sig);
}).add;
)
