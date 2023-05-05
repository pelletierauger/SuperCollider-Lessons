// SuperCollider Course
// Fall 2022 - Winter 2023
// Lesson No. 11 --- FM Synthesis

FreqScope.new(800, 600, 0, server: s);

// FM Basics

{SinOsc.ar(440) * 0.1 ! 2}.play;

{SinOsc.ar(440 + SinOsc.ar(1)) * 0.1 ! 2}.play;

{SinOsc.ar(440 + (SinOsc.ar(1) * 10)) * 0.1 ! 2}.play;

// Carrier and modulator

(
x.free;
x = {
    var mod = (SinOsc.ar(1) * 10);
    var car = SinOsc.ar(440 + mod);
    car * 0.1 ! 2;
}.play;
)

// The amplitude of a modulator in FM synthesis
// is referred to as modulation amount
// or also modulation index.

(
x.free;
x = {
    var freq = 440;
    var modFreq = MouseY.kr(0, 10);
    // var modFreq = MouseY.kr(0, 10).floor;
    var modInd = MouseX.kr(0, 10000);
    var mod = SinOsc.ar(freq * modFreq) * modInd;
    var car = SinOsc.ar(freq + mod);
    car * 0.1 ! 2;
}.play;
)

// Subtle stereo effect

(
x.free;
x = {
    var freq = 440 * [1, 1.005];
    var modFreq = MouseY.kr(0, 10);
    // var modFreq = MouseY.kr(0, 10).floor;
    var modInd = MouseX.kr(0, 10000);
    var mod = SinOsc.ar(freq * modFreq) * modInd;
    var car = SinOsc.ar(freq + mod);
    car * 0.1;
}.play;
)

// A simple SynthDef for further FM experiments.

(
SynthDef.new(\fm, {
    arg carFreq = 440, modFreq = 440, modInd = 200,
    atk = 0.01, rel = 1, amp = 0.2, pan = 0;
    var car, mod, env;
    env = EnvGen.kr(Env.perc(atk, rel), doneAction: 2);
    mod = SinOsc.ar(modFreq) * modInd;
    car = SinOsc.ar(carFreq + mod) * env * amp;
    car = Pan2.ar(car, pan);
    Out.ar(0, car);
}).add;
)

// A percussive and noisy Pbind.

(
p.stop;
p = Pbind(
    \instrument, \fm,
    \dur, 1/8,
    \carFreq, Pexprand(20, 10000),
    \modFreq, Pexprand(20, 10000),
    \modInd, Pwhite(0, 10000),
    \amp, Pexprand(0.1, 0.5),
    \atk, Pexprand(0.001, 0.05),
    \rel, Pexprand(0.05, 10.2),
    \pan, Pwhite(-1.0, 1.0)
).play;
)

// A new version of the SynthDef where
// the modulation index is multiplied by the envelope.

(
SynthDef.new(\fm, {
    arg carFreq = 440, modFreq = 440, modInd = 200,
    atk = 0.01, rel = 1, amp = 0.2, pan = 0;
    var car, mod, env;
    env = EnvGen.kr(Env.perc(atk, rel), doneAction: 2);
    mod = SinOsc.ar(modFreq) * modInd * env;
    car = SinOsc.ar(carFreq + mod) * env * amp;
    car = Pan2.ar(car, pan);
    Out.ar(0, car);
}).add;
)

// A harmonic version of the Pbind.

(
var root = ~toFreq.("E4");
var scale = Scale.mixolydian.degrees;
p.stop;
p = Pbind(
    \instrument, \fm,
    \dur, Prand([0.25, 0.5, 0.75, 1, 2, 3]*0.5, inf),
    \octave, Prand([-2, -1, 0, 1, 2], inf),
    \carFreq, root * (Pkey(\octave, inf)*12).midiratio * Prand(scale.midiratio, inf),
    \modFreq, Pkey(\carFreq, inf) *
    Prand([0.5, 1, 3, 2, 4], inf),
    \modInd, Pwhite(0, 10000),
    \amp, Pexprand(0.1, 0.5),
    \atk, Pexprand(0.001, 0.05),
    \rel, Pexprand(2, 10.2),
    \pan, Pwhite(-1.0, 1.0)
).play;
)

// A version of the SynthDef with an LFO
// to create vibration by multiplying with the
// modulation index;

(
SynthDef.new(\fm, {
    arg carFreq = 440, modFreq = 440, modInd = 200,
    atk = 0.01, rel = 1, amp = 0.2, pan = 0;
    var car, mod, env, lfo;
    env = EnvGen.kr(Env.perc(atk, rel), doneAction: 2);
    lfo = SinOsc.ar(Rand(0.01, 6));
    mod = SinOsc.ar(modFreq) * modInd * env * lfo;
    car = SinOsc.ar(carFreq + mod) * env * amp;
    car = Pan2.ar(car, pan);
    Out.ar(0, car);
}).add;
)

// A mysterious promenade in another universe
// by way of an attempt at crunchy 1980s harmony.

(
var root = ~toFreq.("E4");
var scale = Scale.mixolydian.degrees;
p.stop;
p = Pbind(
    \instrument, \fm,
    \dur, Pseq(0.1!8 ++ [2], inf),
    \carFreq, root * Pseq([0, 2, 3, 5, 7, 9].midiratio, inf),
    \modFreq, Pstutter(5, Pkey(\carFreq, inf) *
        Prand([0.5, 1, 3, 2, 4], inf)),
    \modInd, Pstutter(5, Pwhite(0, 1000)),
    \amp, Pstutter(5, Pexprand(0.1, 0.5)),
    \atk, Pstutter(5, Pexprand(0.01, 0.05)),
    \rel, Pstutter(5, Pexprand(2, 10.2)),
    \pan, Pwhite(-1.0, 1.0)
).play;
)