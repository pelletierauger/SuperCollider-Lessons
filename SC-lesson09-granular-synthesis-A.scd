// SuperCollider Course
// Fall 2022 - Winter 2023
// Lesson No. 9 --- Granular Synthesis A

~path = "/Users/guillaumepelletier/Desktop/Dropbox/Art/p5/SuperCollider-Lessons/classical-guitar-chord.wav"
~chordStereo = Buffer.read(s, ~path);

// ---------------------------------------------------------------------
// Granular synthesis with a Pbind.
// ---------------------------------------------------------------------

// Our basic Pbind.
(
SynthDef(\samplerStereo, {
    arg buf, rate = 1, spos = 0, pan = 0, amp = 1, atk = 0.1, rel = 0.1, out = 0;
    var env = EnvGen.kr(Env.new([0, 1, 0], [atk, rel]), doneAction: 2);
    var sig = PlayBuf.ar(2, buf, rate * BufRateScale.ir(buf), startPos: BufFrames.ir(buf)*spos);
    sig = Pan2.ar(sig, pan) * env * amp;
    Out.ar(out, sig);
}).add;
)

// The shape of a single grain.
(
Synth.new(\samplerStereo, [
    \buf, ~chordStereo,
    \spos, 0,
    \atk, 0.25,
    \rel, 0.25,
    \rate, 1,
]);
)

// An infinite stream of grains.
(
~granular.stop;
~granular = Pbind(
    \instrument, \samplerStereo,
    \buf, ~chordStereo,
    \dur, 1 / 64,
    // \spos, 0.6 + Pwhite(-0.01, 0.01, inf) + Pseq([Pseries(0,0.1/500,1500)],inf),
    \spos, 0.3,
    \atk, 0.5,
    \rel, 0.5,
    // \rate, [0.5, 1],
    \rate, 1,
    \pan, 0
).play();
)

// An alternative version of the SynthDef
// for scanning through the sample with MouseX.
(
SynthDef(\samplerStereo, {
    arg buf, rate = 1, spos = 0, pan = 0, amp = 1, atk = 0.1, rel = 0.1, out = 0;
    var env = EnvGen.kr(Env.new([0, 1, 0], [atk, rel]*0.1), doneAction: 2);
    var scanX = MouseX.kr(0, 1);
    var sig = PlayBuf.ar(2, buf, rate * BufRateScale.ir(buf), startPos: BufFrames.ir(buf)*scanX);
    sig = Pan2.ar(sig, pan) * env * amp;
    // scanX.poll;
    Out.ar(out, sig);
}).add;
)
