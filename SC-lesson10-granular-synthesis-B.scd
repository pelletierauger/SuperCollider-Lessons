// SuperCollider Course
// Fall 2022 - Winter 2023
// Lesson No. 10 --- Granular Synthesis B

~path = "/Users/guillaumepelletier/Desktop/Dropbox/Art/p5/SuperCollider-Lessons/classical-guitar-chord.wav"
~chordStereo = Buffer.read(s, ~path);
~chordStereo.play;

~chordMonoA = Buffer.readChannel(s, ~path, channels: 0)
~chordMonoA.play;

~chordMonoB = Buffer.readChannel(s, ~path, channels: 1)
~chordMonoB.play;

~grainEnv = Env([0, 1, 0], [0.5, 0.5], [8, -8]);
~grainEnvBuf = Buffer.sendCollection(s, ~grainEnv.discretize, 1);

// ---------------------------------------------------------------------
// Granular synthesis within a single Synth, using GrainBuf.
// ---------------------------------------------------------------------

(
x.set(\trigGate, 0, \gate, 0, \fadeTime, 2);
x = {
    | trigGate = 1 |
    var trig = Impulse.kr(80) * trigGate;
    var pan = Demand.kr(trig, 0, Dwhite(-1.00, 1.00, inf));
    var pos = Demand.kr(trig, 0, Dwhite(00, 0.05, inf)) + 0.25;
    var rate = Demand.kr(trig, 0, Dseq([1, 1, 0.5], inf));
    var sig = GrainBuf.ar(
        numChannels: 2,
        trigger: trig,
        dur: 0.75,
        sndbuf: ~chordMonoA,
        // sndbuf: [~chordMonoA, ~chordMonoB],
        rate: rate,
        pos: pos,
        interp: 2,
        pan: pan,
        envbufnum: ~grainEnvBuf,
        maxGrains: 512
    );
    sig;
}.play;
)

// ---------------------------------------------------------------------
// Weirder things with Granular synthesis.
// ---------------------------------------------------------------------

// Recreating the original sound with a linear stream of grains.
(
var d = ~chordMonoA.duration;
var segAmount = 320;
var segLength = d / segAmount ;
var ticks = segLength.reciprocal;
x.set(\trigGate, 0, \gate, 0, \fadeTime, 2);
x = {
    | trigGate = 1 |
    var trig = Impulse.kr(ticks) * trigGate;
    var pan = Demand.kr(trig, 0, Dwhite(-1.00, 1.00, inf));
    var pos = Demand.kr(trig, 0, Dseq(Dseries(0, segLength/d, segAmount), inf));
    var rate = Demand.kr(trig, 0, Dseq([1], inf));
    var sig = GrainBuf.ar(
        numChannels: 2,
        trigger: trig,
        dur: segLength*8,
        sndbuf: ~chordMonoA,
        rate: rate,
        pos: pos,
        interp: 2,
        pan: pan * 0.5,
        envbufnum: -1,
        maxGrains: 1200
    );
    sig * 1;
}.play;
)

// An example of something weird done with granular synthesis.
(
var d = ~chordMonoA.duration;
var segments = 320;
var segLength = d / segments ;
var ticks = segLength.reciprocal;
x.set(\trigGate, 0, \gate, 0, \fadeTime, 2);
x = {
    | trigGate = 1 |
    var trig = Impulse.kr(ticks*8) * trigGate;
    var pan = Demand.kr(trig, 0, Dwhite(-1.00, 1.00, inf));
    var pos = Demand.kr(trig, 0, Dseq(Dseries(0, segLength/d/100, segments*16*2), inf));
    var rate = Demand.kr(trig, 0, Dseq([1], inf));
    var sig = GrainBuf.ar(
        numChannels: 2,
        trigger: trig,
        dur: segLength*0.125*0.25 + (SinOsc.kr(0.1).unipolar * 0.25),
        sndbuf: ~chordMonoA,
        rate: rate,
        pos: pos + (SinOsc.kr(4).unipolar * 0.0005 * SinOsc.kr(0.1).unipolar),
        interp: 2,
        pan: pan * 0.5,
        envbufnum: -1,
        maxGrains: 1200
    );
    sig = HPF.ar(sig, 1000) * 4;
    sig * 1;
}.play;
)
