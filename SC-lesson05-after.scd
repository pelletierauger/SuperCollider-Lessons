░░░░▒▒▒▒▒▒▓▓▓▓█████        SuperCollider Course        █████▓▓▓▓▒▒▒▒▒▒░░░░
░░░░▒▒▒▒▒▒▓▓▓▓█████      Fall 2022 - Winter 2023       █████▓▓▓▓▒▒▒▒▒▒░░░░
░░░░▒▒▒▒▒▒▓▓▓▓█████     SuperCollider As a Howling     █████▓▓▓▓▒▒▒▒▒▒░░░░
░░░░▒▒▒▒▒▒▓▓▓▓█████      Celestial Wind That Sings     █████▓▓▓▓▒▒▒▒▒▒░░░░
░░░░▒▒▒▒▒▒▓▓▓▓█████     Throughout the Cosmos and      █████▓▓▓▓▒▒▒▒▒▒░░░░
░░░░▒▒▒▒▒▒▓▓▓▓█████      Binds Together all Souls.     █████▓▓▓▓▒▒▒▒▒▒░░░░

Lesson No. 5 --- Substractive Synthesis

// -----------------------------------------------------------------------------
// 5A: LPF, HPF, BPF
// -----------------------------------------------------------------------------

// White noise has the same amount of energy at all frequencies.
(
{WhiteNoise.ar() * 0.1 ! 2;}.freqscope;
)

// LPF, Low Pass Filter
// HPF, High Pass Filter
// BPF, High Pass Filter
// ********EXTREMELY IMPORTANT****** :
// The freq value within LPF and HPF must NEVER approach zero.
// From the documentation:
// WARNING: due to the nature of its implementation
// frequency values close to 0 may cause glitches
// and/or extremely loud audio artifacts!
// ********EXTREMELY IMPORTANT******
(
{
    var sig = WhiteNoise.ar() * 0.1;
    var lowPass = LPF.ar(sig, freq: 440);
    lowPass ! 2;
}.freqscope;
)

// Tying the filter frequency to the horizontal mouse location.
(
{
    var x = MouseX.kr(0, 1);
    var sig = WhiteNoise.ar() * 0.1;
    var lowPass = BPF.ar(sig, 15000 * x + 50);
    lowPass ! 2;
}.freqscope;
)
// -----------------------------------------------------------------------------
// 5B: Resonant filters
// -----------------------------------------------------------------------------

// RLPF, Resonant low pass filter.
// RHPF, Resonant high pass filter.
(
{
    var x = MouseX.kr(0, 1);
    var y = 1 - MouseY.kr(0, 1);
    var sig = LFSaw.ar(440) * 0.1;
    var lowPass = RHPF.ar(sig, 10440 * x + 50, y);
    lowPass ! 2;
}.freqscope;
)


// VadimFilter, a nice sounding filter.
(
{
    var x = MouseX.kr(0, 1);
    var y = MouseY.kr(0, 1);
    var sig = LFSaw.ar(440) * 0.1;
    var lowPass = VadimFilter.ar(sig, 10440 * x + 50, y);
    lowPass ! 2 * 8;
}.freqscope;
)

// Tying the filter frequency to an LFO.
(
{
    var x = MouseX.kr(0, 1);
    var y = MouseY.kr(0.1, 24);
    var lfo = SinOsc.kr(y).unipolar;
    var freqs = 440 * [1, 1.01].wrapExtend(10) * [0, 2, 4, 7, 11].midiratio.stutter(2);
    var sigA = LFSaw.ar(freqs).sum * 0.1;
    var sigB = LFSaw.ar(freqs * 1.01).sum * 0.1;
    var lowPass = LPF.ar([sigA, sigB], 11000 * x * lfo + 500);
    lowPass;
}.freqscope;
)

// -----------------------------------------------------------------------------
// 5C: Using filters to simulate certain properties of acoustic sounds.
// -----------------------------------------------------------------------------

// Filtering the high frequency energy as you scale down the amplitude,
// to simulate the behaviour of acoustic sounds.
(
var notes = Scale.major.degrees.wrapExtend(21) + [0, 12, 24].stutter(7);
var note = notes.choose;
var cutoff = note.linexp(0, 35, 50, 20000);
var release = note.linexp(0, 35, 10, 1);
{
    var x = MouseX.kr(0, 1);
    var e = EnvGen.kr(Env.perc(releaseTime: release), doneAction: 2);
    var lfo = SinOsc.kr(6).unipolar * 550;
    var sig = LFSaw.ar(~toFreq.("E2") * note.midiratio) * 0.1;
    var lowPass = LPF.ar(sig, cutoff * e + 5 + lfo);
    lowPass ! 2 * e;
}.play;
cutoff.postln;
)

440 * 2.pow(7/12);
440 * 7.midiratio;

// When the high frequencies are not filtered away as the amplitude falls,
// a different effect is achieved. It sounds less warm and natural, but it
// can absolutely fit within a piece of music, depending on the desired mood.
(
{
    var x = MouseX.kr(0, 1);
    var e = EnvGen.kr(Env.perc(releaseTime: 1.5), doneAction: 2);
    var sig = LFSaw.ar(440) * 0.1;
    sig ! 2 * e;
}.play;
)

// -----------------------------------------------------------------------------
// 5D: Different filters
// -----------------------------------------------------------------------------


// MoogFF, A digital implementation of the Moog VCF (Voltage Controlled Filter).
(
var m = [5, 7].choose;
var b = rrand(-1.01, 1.01);
{
    var x = MouseX.kr(0, 1);
    var e = EnvGen.kr(Env.perc(releaseTime: 10.5), doneAction: 2);
    var sig = LFSaw.ar(220 * [0, 2, 4, m, 9].midiratio).sum * 0.1;
    var lowPass = MoogFF.ar(sig, 15000 * e + 50, gain: x * 4);
    Pan2.ar(lowPass * e, b);
}.play;
)

// Tying the filter resonance gain to an LFO whose frequency is tied to MouseY.
(
var m = Scale.mixolydian.degrees.choose;
var b = rrand(-1.01, 1.01);
{
    var x = MouseX.kr(0, 1);
    var y = MouseY.kr(0, 24);
    var e = EnvGen.kr(Env.perc(releaseTime: 10.5), doneAction: 2);
    var lfo = SinOsc.kr(y).unipolar;
    var sig = LFSaw.ar(440 * m.midiratio) * 0.1;
    var lowPass = MoogFF.ar(sig, 15000 * e + 50, gain: x * 4 * lfo);
    Pan2.ar(lowPass * e, b);
}.play;
)


// -----------------------------------------------------------------------------
// 5E: Some extra language practice: Functions and Tasks.
// -----------------------------------------------------------------------------

(
~wash = {
    var m = [5, 7].choose;
    var b = rrand(-1.01, 1.01);
    {
        var x = MouseX.kr(0, 1);
        var e = EnvGen.kr(Env.perc(releaseTime: 10.5), doneAction: 2);
        var sig = LFSaw.ar(220 * [0, 2, 4, m, 9].midiratio).sum * 0.1;
        var lowPass = MoogFF.ar(sig, 15000 * e + 50, gain: x * 4);
        Pan2.ar(lowPass * e, b);
    }.play;
};
~soloNote = {
    var m = Scale.mixolydian.degrees.choose;
    var b = rrand(-1.01, 1.01);
    {
        var x = MouseX.kr(0, 1);
        var y = MouseY.kr(0, 24);
        var e = EnvGen.kr(Env.perc(releaseTime: 10.5), doneAction: 2);
        var lfo = SinOsc.kr(y).unipolar;
        var sig = LFSaw.ar(440 * m.midiratio) * 0.1;
        var lowPass = MoogFF.ar(sig, 15000 * e + 50, gain: x * 4 * lfo);
        Pan2.ar(lowPass * e, b);
    }.play;
};
)

~wash.();
~soloNote.();

(
~washyTask.stop;
~washyTask = Task {
    {~wash.(); 4.wait;}.loop;}.start;
)

(
~noteTask.stop;
~noteTask = Task {
    {~soloNote.(); 2.wait;}.loop;}.start;
)


// -----------------------------------------------------------------------------
// 5F: Using logic within Tasks.
// -----------------------------------------------------------------------------


(
~index = 0;
~notes = [0, 2, 4, 5, 7];
~soloNote = {
    var m = ~notes[~index];
    var b = rrand(-1.01, 1.01);
    {
        var x = MouseX.kr(0, 1);
        var y = MouseY.kr(0, 24);
        var e = EnvGen.kr(Env.perc(releaseTime: 5.5), doneAction: 2);
        var lfo = SinOsc.kr(y).unipolar;
        var sig = LFSaw.ar(440 * m.midiratio) * 0.1;
        var lowPass = MoogFF.ar(sig, 15000 * e + 50, gain: x * 4 * lfo);
        Pan2.ar(lowPass * e, b);
    }.play;
    ~notes[~index].postln;
    ~index = (~index + 1) % ~notes.size;
};
)

(
~noteTask.stop;
~noteTask = Task {
    {~soloNote.(); 0.5.wait;}.loop;}.start;
)

~notes = [0, 2, 4, 5, 9];
~notes = ~notes.reverse;

~notesStream = Pseq([0, 2, 4, 5, 9], inf).asStream;
~notesStream.next;
~notesStream.value;
~notesStream.reset;

Pseries(1, 1.5, inf).asStream.nextN(16);
Pgeom(1, 1.5, inf).asStream.nextN(16);
(Pgeom(1, 1.5, inf) + Pwhite(0.0, 1.0)).asStream.nextN(16);