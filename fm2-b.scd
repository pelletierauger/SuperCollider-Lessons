// SuperCollider Course
// Fall 2022 - Winter 2023
// Lesson No. 12 --- FM Synthesis Part 2.

// “The cosmos is full beyond measure of elegant truths;
// of exquisite interrelationships;
// of the awesome machinery of nature.”
//
// ― Carl Sagan


// Scaling the timbre according to the velocity.

(
SynthDef(\fm, {
    | freq = 220, amp = 0.9 |
    var vel = amp.linlin(0.001, 1, 0.001, 20000);
    var env = EnvGen.kr(Env([0,1,0],[0.5, 2],[0, -8]), doneAction: 2);
    var env2 = EnvGen.kr(Env([0,1,0],[0.5, 0.2],[0, -8]));
    var op1 = SinOsc.ar(freq * 5) * vel * env2;
    var op0 = SinOsc.ar(freq + op1) * env * 0.2 * amp ! 2;
    Out.ar(0, op0);
}).add;
)

(
~pattern.stop;
~pattern = Pbind(
    \instrument, \fm,
    \dur, 1,
    \freq, 55,
    \amp, Pseq([Pseries(1/16, 1/16, 15)], inf)
).play;
)

// Scaling the timbre according to the velocity.
// A more musical example, with a bonus tresillo.
// The only that changed is that the time values of Env
// defined in env2 are multiplied by 0.5, to make op1's contribution shorter.
(
SynthDef(\fm, {
    | freq = 220, amp = 0.9 |
    var vel = amp.linlin(0.001, 1, 0.001, 20000);
    var env = EnvGen.kr(Env([0,1,0],[0.5, 2],[0, -8]), doneAction: 2);
    var env2 = EnvGen.kr(Env([0,1,0],[0.5, 0.2] * 0.5,[0, -8]));
    var op1 = SinOsc.ar(freq * 5) * vel * env2;
    var op0 = SinOsc.ar(freq + op1) * env * 0.2 * amp ! 2;
    Out.ar(0, op0);
}).add;
)
(
~pattern.stop;
~pattern = Pbind(
    \instrument, \fm,
    \dur, Pseq([3, 3, 2] * 0.25, inf),
    \freq, 220 * Pseq([-12, 3, 5, -5, 2, 3].midiratio, inf),
    \amp, Pseq([Pseries(1/16, 1/16, 24)], inf)
).play;
)

// Scaling the timbre and dynamics according to the pitch.

(
SynthDef(\fm, {
    | freq = 220, amp = 0.9 |
    var vel = freq.linexp(0.001, 1, 0.001, 2000);
    var rel = freq.linexp(0.001, 400, 100, 0.1);
    var atk = freq.linexp(0.001, 500, 0.1, 0.001);
    var env = EnvGen.kr(Env([0, 1, 0], [0.1, rel], [0, -8]), doneAction: 2);
    var env2 = EnvGen.kr(Env([0, 1, 0], [atk, 0.2 * rel], [0, -8]));
    var op1 = SinOsc.ar(freq * 5) * vel * env2;
    var op0 = SinOsc.ar(freq + op1) * env * 0.4 * amp ! 2;
    Out.ar(0, op0);
}).add;
)
(
var k = ~toMidi.("E2");
~pattern.stop;
~pattern = Pbind(
    \instrument, \fm,
    \dur, Pseq([1, 0.5, 0.5, 1], inf),
    \freq, Pseq((k + [0, 19, 20, 19, 7, 12, 14, 15]).midicps, inf),
    \amp, 0.1
).play;
)

// Oscillator whose frequency is modulated by its own ouput (feedback).

(
x.free;
x = {
    SinOscFB.ar(440, feedback: 0) * 0.1 ! 2;
}.play;
)

(
SynthDef(\fm, {
    | freq = 220, amp = 0.9 |
    var vel = freq.linexp(0.001, 1, 0.001, 2000);
    var rel = freq.linexp(0.001, 400, 100, 0.1);
    var fb = freq.linexp(40.0, 300.0, 0.001, 50.0);
    var atk = freq.linexp(0.001, 500, 0.1, 0.001);
    var env = EnvGen.kr(Env([0, 1, 0], [0.1, rel], [0, -8]), doneAction: 2);
    var env2 = EnvGen.kr(Env([0, 1, 0], [atk, 0.2 * rel], [0, -8]));
    var op1 = SinOsc.ar(freq * 5) * vel * 0.2 * env2;
    var op0 = SinOscFB.ar(freq + op1, feedback: fb) * env * 0.4 * amp ! 2;
    // rel.poll;
    Out.ar(0, op0);
}).add;
)

(
var k = ~toMidi.("E2");
~pattern.stop;
~pattern = Pbind(
    \instrument, \fm,
    \dur, Pseq([1, 0.5, 0.5, 1], inf),
    \freq, Pseq((k + [0, 19, 20, 19, 7, 12, 14, 15]).midicps, inf),
    \amp, 0.1
).play;
)



// ------------------------------------------------------------------------
// The same SynthDef
// Scaling the timbre and dynamics according to the pitch.
// ------------------------------------------------------------------------

(
SynthDef(\fm, {
    | freq = 220, amp = 0.9 |
    var vel = freq.linexp(0.001, 1, 0.001, 2000);
    var rel = freq.linexp(0.001, 400, 100, 0.1);
    var atk = freq.linexp(0.001, 500, 0.1, 0.001);
    var env = EnvGen.kr(Env([0, 1, 0], [0.1, rel], [0, -8]), doneAction: 2);
    var env2 = EnvGen.kr(Env([0, 1, 0], [atk, 0.2 * rel], [0, -8]));
    var op1 = SinOsc.ar(freq * 5) * vel * env2;
    var op0 = SinOsc.ar(freq + op1) * env * 0.4 * amp ! 2;
    Out.ar(0, op0);
}).add;
)

// A new one.
(
SynthDef(\fm2, {
    | freq = 220, amp = 0.9 |
    var vel = freq.linexp(0.001, 1, 0.001, 100);
    var rel = freq.linexp(0.001, 400, 100, 0.1);
    var fb = freq.linexp(40.0, 300.0, 0.001, 150.0);
    var atk = freq.linexp(0.001, 500, 0.1, 0.001);
    var env = EnvGen.kr(Env([0, 1, 0], [0.1, 4], [0, -8]), doneAction: 2);
    var env2 = EnvGen.kr(Env([0, 1, 0], [atk, 1.2 * rel], [0, -8]));
    var op1 = SinOsc.ar(freq * 5) * vel * env2;
    var op0 = SinOscFB.ar(freq * [1, 1.01], feedback: fb * op1) * env * 0.4 * amp;
    // rel.poll;
    Out.ar(0, op0);
}).add;
)


(
var k = ~toMidi.("E2");
~pattern.stop;
~pattern = Pbind(
    \instrument, \fm,
    \dur, Pseq([1, 0.5, 0.5, 1], inf),
    \freq, Pseq((k + [0, 19, 20, 19, 7, 12, 14, 15]).midicps, inf),
    \amp, 0.1
).play;
)

(
var k = ~toFreq.("E4");
~pattern2.stop;
~pattern2 = Pbind(
    \instrument, \fm2,
    \dur, Prand([2, 1, 0.5, 0.25, 0.125], inf),
    \freq, k * Prand(Scale.aeolian.degrees.midiratio, inf),
    \amp, 0.1
).play;
)
