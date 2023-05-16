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

// Changing the timbre according to the amplitude
// Changing the timbre according to the pitch
// Changing the dynamics according to the amplitude
// Changing the dynamics according to the pitch

(
SynthDef(\fm, {
    | freq = 220, amp = 0.9 |
    var vel = amp.linlin(0.001, 1, 0.001, 10000);
    var env = EnvGen.kr(Env([0,1,0],[0.1, 2],[0, -8]), doneAction: 2);
    var env2 = EnvGen.kr(Env([0,1,0],[0.1, 1],[0, -8]));
    var op1 = SinOsc.ar(freq * 5) * vel * env2;
    var op0 = SinOsc.ar(freq + op1) * env * 0.2 * amp ! 2;
    Out.ar(0, op0);
}).add;
)

(
SynthDef(\fm, {
    | freq = 220, amp = 0.9 |
    var vel = amp.linlin(0.001, 1, 0.001, 20000);
    var rel = freq.linlin(0, 1000, 3, 0.1);
    var env = EnvGen.kr(Env([0,1,0],[0.5, rel],[0, -8]), doneAction: 2);
    var env2 = EnvGen.kr(Env([0,1,0],[0.5, 0.2],[0, -8]));
    var op1 = SinOsc.ar(freq * 5) * vel * env2;
    var op0 = SinOsc.ar(freq + op1) * env * 0.2 * amp ! 2;
    Out.ar(0, op0);
}).add;
)



(
SynthDef(\fm, {
    | freq = 220, amp = 0.9 |
    var vel = amp.linlin(0.001, 1, 0.001, 20000);
    var rel = freq.linexp(0.001, 400, 30, 0.01);
    var env = EnvGen.kr(Env([0,1,0],[0.5, rel],[0, -8]), doneAction: 2);
    var env2 = EnvGen.kr(Env([0,1,0],[0.5, 0.2],[0, -8]));
    var op1 = SinOsc.ar(freq * 5) * vel * env2;
    var op0 = SinOsc.ar(freq + op1) * env * 0.1 * amp ! 2;
    freq.poll;
    Out.ar(0, op0);
}).add;
)
(
var k = ~toMidi.("E2");
~pattern.stop;
~pattern = Pbind(
    \instrument, \fm,
    \dur, 1,
    \freq, Pseq((k + [0, 19, 20, 19]).midicps, inf),
    \amp, 0.1
).play;
)



(
~pattern.stop;
~pattern = Pbind(
    \instrument, \fm,
    \dur, 1,
    \freq, Pseq((Scale.mixolydian.degrees.wrapExtend(36) + [24, 36, 48].stutter(7)).midicps, inf),
    \amp, Pseq([Pseries(0, 1/16, 16)], inf)
).play;
)



(
~pattern.stop;
~pattern = Pbind(
    \instrument, \fm,
    \dur, 0.25,
    \freq, 55,
    \amp, Pseq([Pseries(1/16, 1/16, 16)], inf)
).play;
)



linexp
linlin

{SinOsc.ar(220) * 0.1 ! 2}.play;