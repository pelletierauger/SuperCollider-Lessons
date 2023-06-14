// SuperCollider Course
// Fall 2022 - Winter and Spring 2023
// Lesson No. 14 --- Modal Synthesis

// Karplus–Strong
// The most basic string model.
// https://en.wikipedia.org/wiki/Karplus%E2%80%93Strong_string_synthesis
(
{
    Pluck.ar(
        in: PinkNoise.ar(0.1),
        trig: Impulse.kr(MouseY.kr(2, 20)),
        maxdelaytime: 1,
        delaytime: ~toFreq.("B3").reciprocal,
        decaytime: 10,
        coef: max(-0.999, MouseX.kr(-0.999, 0.999))
    ) * 2 ! 2;
}.play();
)
440 vibrations per second = A


{MouseY.kr().poll}.play

// String model by Émilie Gillet.
(
{
    MiPlaits.ar(
        pitch: 440.cpsmidi,
        engine: 11,
        harm: 0.1,
        timbre: MouseX.kr(),
        morph: 0.5,
        trigger: Impulse.kr(MouseY.kr(2, 20))
    )[0] * 0.2 ! 2;
}.play;
)

// Modal engine by Émilie Gillet.
(
{
    MiPlaits.ar(
        pitch: 220.cpsmidi,
        engine: 12,
        harm: MouseY.kr(),
        timbre: MouseX.kr(),
        morph: 0.9,
        trigger: Impulse.kr(1)
    )[0] * 0.2 ! 2;
}.play;
)

// A muffled bell-like sound.
(
{
    MiPlaits.ar(
        pitch: 25,
        engine: 12,
        harm: 1,
        timbre: 0.3,
        morph: 0.9,
        trigger: Impulse.kr(0.5)
    )[0] * 0. ! 2;
}.play;
)

// A bright bell-like sound.
(
{
    var t = Impulse.kr(0.5);
    MiPlaits.ar(
        pitch: ~toMidi.("G3"),
        engine: 12,
        harm: 0.8,
        timbre: 0.4,
        morph: 0.9,
        trigger: t
    )[0] * 0.2 ! 2;
}.play;
)

// Modifying the parameters in real time, at control rate.
// And creating a groove by using a trigger mask to make the Son clave rhythm.
(
x.free;
x = {
    var t = Impulse.kr(8);
    var d = t * Demand.kr(t, 0, Dseq(
        [1, 0, 0, 1, 0, 0, 1, 0] ++
        [0, 0, 1, 0, 1, 0, 0, 0], inf));
    var morph = Demand.kr(d, 0, Dwhite(0.2, 0.4, inf));
    var harm = Demand.kr(d, 0, Dseq((0.8!3) ++ (0.81!2), inf));
    MiPlaits.ar(
        pitch: ~toMidi.("G6") + \note.kr(0, 5),
        engine: 12,
        harm: harm,
        timbre: 0.4,
        morph: morph,
        trigger: d
    )[0] * 0.2 ! 2;
}.play;
)
x.set(\note, 0)

// A completely different musical idea based on very similar code,
// to showcase the versatility of Émilie Gillet's synthesizers.
(
{
    var t = Impulse.kr(8);
    var d = t * Demand.kr(t, 0, Dseq(
        [1, 0, 0, 1, 0, 0, 1, 0] ++
        [0, 0, 1, 0, 1, 0, 0, 0], inf));
    var morph = Demand.kr(d, 0, Dwhite(0.2, 0.4, inf));
    var note = Demand.kr(d, 0, Dseq([0, -5, -2, -7].stutter(10), inf));
    MiPlaits.ar(
        pitch: ~toMidi.("G2") + note,
        engine: 12,
        harm: MouseX.kr(),
        timbre: 0.4,
        morph: morph,
        trigger: d,
        decay: 0.5,
        lpg_colour: 0
    )[0] * 0.2 ! 2;
}.play;
)

// ----------------------------------------------------------------------------
// Modal Synthesis with MiElements
// ----------------------------------------------------------------------------

(
~blow = Bus.audio(s, 1);
~strike = Bus.audio(s, 1);
~gate = Bus.control(s, 1);
)

(
x.free;
x = {
    |
    pit = 45,                strength = 0.5,           contour = 0.2,
    bow_level = 0,           blow_level = 0,           strike_level = 0,
    flow = 0.5,              mallet = 0.5,             bow_timb = 0.5,
    blow_timb = 0.5,         strike_timb = 0.5,        geom = 0.25,
    bright = 0.5,            damp = 0.7,               pos = 0.2,
    space = 0.3,             model = 0,                easteregg = 0
    |
    var blow_in = In.ar(~blow, 1);
    var strike_in = In.ar(~strike, 1);
    var gate = In.kr(~gate, 1);
    MiElements.ar(
        blow_in: blow_in,       strike_in: strike_in,       gate: gate,
        pit: pit,               strength: strength,         contour: contour,
        bow_level: bow_level,   blow_level: blow_level,     strike_level: strike_level,
        flow: flow,             mallet: mallet,             bow_timb: bow_timb,
        blow_timb: blow_timb,   strike_timb: strike_timb,   geom: geom,
        bright: bright,         damp: damp,                 pos: pos,
        space: space,           model: model,               easteregg: easteregg
    ) * 1;
}.play;
)

x.set(\pit, 40); // Pitch input.
x.set(\strength, 0.09); // Amplifiy or attenuate the excitation signal (0 -- 1).
x.set(\contour, 0.25); // Bow/Blow envelope contour, interpolating between AD, ADSR and AR envelopes.

x.set(\bow_level, 0); // Controls the amplitude of scratching/bowing noise from the BOW generator sent to the resonator.
x.set(\blow_level, 0); // Controls the amount of granular blowing noise from the BLOW generator sent to the resonator.
x.set(\strike_level, 0); // Controls the amount of percussive noise from the STRIKE generator sent to the resonator.

x.set(\flow, 0.4); // Air flow of the BLOW generator. Scans through various colours of noise.
x.set(\mallet, 0); // Mallet type. Controls the type of percussive noise produced by the STRIKE generator.

x.set(\bow_timb, 1); // Controls the smoothness/granularity ot the BOW material.
x.set(\blow_timb, 0.25); // Controls the pitch/granulation rate of the BLOW noise generator.
x.set(\strike_timb, 0.2); // Controls the brightness/speed of the percussive excitation.
x.set(\geom, 0.5); // Controls the geometry and stiffness of the resonating structure. It goes from plates, to strings, to bars/tubes, to bells/bowls

x.set(\bright, 0.355); // Controls the brightness of the resonator.
x.set(\damp, 0.46); // Controls the high frequency damping of the resonator.
x.set(\pos, 0.46); // Position: controls at which point the string/surface is excited.

x.set(\space, 0.2); // Controls the stereo width and amount of reverb.
x.set(\model, 2); // Selects the resonator model: 0:Modal, 1:String, 2:Strings
x.set(\easteregg, 0); // Flag to activate 'easteregg' mode (0/1), which turns MiElements into a dark 2x2-op FM synth.

// ------------------------------------------------------------------------

// Hear the basic resonator.
i.free; i = {Out.ar(~blow, PinkNoise.ar() * 0.1)}.play;
g.free; g = {Out.kr(~gate, LFPulse.kr(2))}.play;

// ------------------------------------------------------------------------

// Keep it ringing, using 'blow' input and contour set to 0.5.
x.set(\contour, 0.2);
x.set(\contour, 0.5);
g.free; g = {Out.kr(~gate, 1)}.play;

// ------------------------------------------------------------------------


x.set(\pit, 40); // Pitch input.
x.set(\bow_level, 1);
x.set(\bow_level, 0);
x.set(\blow_level, 1);
x.set(\blow_level, 0);
x.set(\bow_timb, 1);
i.free;
g.free;
i.free; i = {Out.ar(~blow, PinkNoise.ar() * 0.1)}.play;
i.free; i = {Out.ar(~strike, PinkNoise.ar() * 0.1)}.play;

g.free;
g.free; g = {Out.kr(~gate, LFPulse.kr(2))}.play;
x.set(\strike_level, 1);

(
g.free;
g = {
    var t = Impulse.kr(8);
    var d = Demand.kr(t, 0, Dseq([1, 0, 0, 1, 0, 0, 1, 0], inf));
    1 - (t * d);
}.play;
)


x.set(\strength, 0.39);
x.set(\damp, 0.59);

i.free;
i.free; i = {Out.ar(~strike, PinkNoise.ar() * 0.1)}.play;
x.set(\mallet, 0.1);
x.set(\pit, 20);
x.set(\strike_level, 0.6);
x.set(\bow_level, 0); x.set(\blow_level, 0); x.set(\strike_level, 0);
x.set(\geom, 0.75);
x.set(\bright, 0.1285);

i.free; i = {Out.ar(~blow, LFSaw.ar(440)*0.1)}.play;

g.free; g = {Out.kr(~gate, LFPulse.kr(0.25))}.play;

g.free; g = {Out.kr(~gate, Impulse.kr(2))}.play;

g.free; g = {Out.kr(~gate, 1)}.play;

g.free; g = {Out.kr(~gate, 0)}.play;

g.free; g = {Out.kr(~gate, Impulse.kr(2))}.play;





/*
In the strings model (2), the resonator plays chords
that can be selected using the geom parameter.
In this model, geom can only have 11 different values:
0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, and 1.0.
Values in between these can be used, but they will be quantized
to the closest lower value.
These 11 values of geom represent 11 different chords, each made of 5 strings.
Below you can see what those chords are.
Each value of geom is paired with an array of 5 pitches and a description.
In the pitches arrays, the values represent the distances in semitones
between a note and the fundamental frequency as defined by the pit parameter.

geom   Resulting five strings chord    Description

0.0    [0.0, -12.0, 0.0, 0.01, 12.0]   Octaves only. One detuned fundamental.
0.1    [0.0, -12.0, 3.0, 7.0, 10.0]    Minor seventh chord.
0.2    [0.0, -12.0, 3.0, 7.0, 12.0]    Minor chord. An octave on top.
0.3    [0.0, -12.0, 3.0, 7.0, 14.0]    Minor chord. A ninth on top.
0.4    [0.0, -12.0, 3.0, 7.0, 17.0]    Minor chord. A fourth on top.
0.5    [0.0, -12.0, 7.0, 12.0, 19.0]   Octaves and fifths.
0.6    [0.0, -12.0, 4.0, 7.0, 17.0]    Major chord. A fourth on top.
0.7    [0.0, -12.0, 4.0, 7.0, 14.0]    Major chord. A ninth on top.
0.8    [0.0, -12.0, 4.0, 7.0, 12.0]    Major chord. An octave on top.
0.9    [0.0, -12.0, 4.0, 7.0, 11.0]    Major seventh chord.
1.0    [0.0, -12.0, 5.0, 7.0, 12.0]    Octaves, a fourth, and a fifth.

Below is a chord progression played with geom and a Demand rate pattern.

*/
(
{
    var trig = Impulse.ar(4, 0.01);
    var chords = Demand.ar(trig, 0, Dseq([0.9, 0.7, 0.2, 0.3].stutter(8), inf));
    var bright = Demand.ar(trig, 0, Dseq((1..8) * 0.1, inf));
    MiElements.ar(0, trig,
        pit: 45,
        geom: chords,
        bright: bright,
        damp: 0.8,
        pos: 1.0 - bright,
        model: 2
    );
}.play;
)
(0.1,0.2..0.8)
(1..8) * 0.1