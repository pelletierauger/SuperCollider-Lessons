// SuperCollider Course
// Fall 2022 - Winter and Spring 2023
// Lesson No. 14 --- Modal Synthesis with MiElements
// ----------------------------------------------------------------------------

// 3 Busses to control the input values for our modal synth.
(
~blowBus = Bus.audio(s, 1);
~strikeBus = Bus.audio(s, 1);
~gateBus = Bus.control(s, 1);
)

// The modal synth that we will control the whole time.
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
    var blow_in = In.ar(~blowBus, 1);
    var strike_in = In.ar(~strikeBus, 1);
    var gate = In.kr(~gateBus, 1);
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

// ----------------------------------------------------------------------------
// Parameter reference for the synth all. All parameters with documentation.
// ----------------------------------------------------------------------------

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

// -----------------------------------------------------------------------
// Hear the basic resonator.
// ----------------------------------------------------------------------------

(
~input.free; ~input = {Out.ar(~blowBus, PinkNoise.ar() * 0.1)}.play;
~gate.free; ~gate = {Out.kr(~gateBus, LFPulse.kr(2))}.play;
)

~input.free;
~input = {Out.ar(~blowBus, PinkNoise.ar() * 0.1)}.play;
~gate.free;
~gate = {Out.kr(~gateBus, LFPulse.kr(2))}.play;

// ------------------------------------------------------------------------
// Keep it ringing, using 'blow' input and contour set to 0.5.
// ----------------------------------------------------------------------------

(
x.set(\contour, 0.5);
~gate.free; ~gate = {Out.kr(~gateBus, 1)}.play;
)

// Close and reopen the gate at will.
~gate.free; g = {Out.kr(~gateBus, 0)}.play;
~gate.free; g = {Out.kr(~gateBus, 1)}.play;

// Send a sequence of impulses that are not a steady pulse, but a tresillo.
(
~gate.free;
~gate = {
    var t = Impulse.kr(8);
    var d = Demand.kr(t, 0, Dseq([1, 0, 0, 1, 0, 0, 1, 0], inf));
    Out.kr(~gateBus, 1 - (t * d));
}.play;
)

// ------------------------------------------------------------------------
// The percussive generator.
// ------------------------------------------------------------------------

// Gradually raise the strike level to hear the percussive generator.
x.set(\strike_level, 0.4);

// Stop sending anything to the input.
~input.free;

// Change the timbre quality of the percussive through various parameters.
x.set(\strength, 0.289);
x.set(\damp, 0.2);
x.set(\pit, 40);
x.set(\bright, 0.34);

// Mallet type. Controls the type of percussive noise produced by the STRIKE generator.
x.set(\mallet, 0.25);

// Set multiple parameters simultaneously.
x.set(\pit, 40, \mallet, 0.25, \bright, 0.34, \strength, 0.4, \damp, 0.5);

// Send something in the strike input of MiElements, an external audio input
// which directly goes to the resonator.
~input.free;
~input.free; ~input = {Out.ar(~strikeBus, PinkNoise.ar() * 0.1)}.play;

// Close the gate.
~gate.free; g = {Out.kr(~gateBus, 1)}.play;

(
~input.free;
~input = {
    var t = Impulse.kr(4);
    var env = EnvGen.kr(Env([0,1,0], [0.01, 0.5], ['lin', -8]), gate: t);
    var sig = PinkNoise.ar() * env;
    Out.ar(~strikeBus, sig)}.play;
)

// Low resonant thud.
x.set(\pit, ~toMidi.("A0"), \geom, 0.375, \bright, 0.5, \damp, 0.8);

// Sharp metallic sound.
x.set(\pit, ~toMidi.("A6"), \geom, 0.75, \bright, 0.75, \damp, 0.3);

// Sending a pitched sound to the strike input.
(
~input.free;
~input = {
    var t = Impulse.kr(4);
    var env = EnvGen.kr(Env([0,1,0], [0.01, 0.5], ['lin', -8]), gate: t);
    var sig = MiBraids.ar(pitch: ~toMidi.("A3"), timbre: 0.5, color: 0.5, model: 1) * env;
    Out.ar(~strikeBus, sig)}.play;
)

// ------------------------------------------------------------------------
// The bowing and blowing generators.
// ------------------------------------------------------------------------

(
x.set(\contour, 0.5);
~gate.free; ~gate = {Out.kr(~gateBus, 1)}.play;
)

~input.free;

x.set(\bow_level, 1, \blow_level, 0, \strike_level, 0);

// Controling the pitch automatically using a Task.

t = TempoClock.new(1).permanent_(true);
(
~modalTask.stop;
~modalTask = Task {
    var tonic = ~toMidi.("A1");
    var melody = Pseq([0, -2], inf).asStream;
    {
        x.set(\pit, tonic + melody);
        4.wait;
    }.loop;
}.start(t, quant: [1]);
)

// Low bowing (formerly the low resonant thud).
x.set(\geom, 0.375, \bright, 0.5, \damp, 0.8);

// Clean pitched sustained sound (formerly the sharp metallic sound).
x.set(\geom, 0.75, \bright, 0.75, \damp, 0.3);

// Switch between the bow generator and the blow generator.
x.set(\bow_level, 1, \blow_level, 0, \strike_level, 0);
x.set(\bow_level, 0, \blow_level, 1, \strike_level, 0);

// Control the smoothness/granularity ot the BOW material.
x.set(\bow_timb, 0.85);

// Create a shaky texture by modifying the bow timbre over time.
(
~textureTask.stop;
~textureTask = Task {
    var tonic = ~toMidi.("A2");
    var melody = Pgauss(0.5, 0.25, inf).asStream;
    {
        x.set(\bow_timb, melody);
        (1/16).wait;
    }.loop;
}.start(t, quant: [1]);
)

// ------------------------------------------------------------------------
// Chords with MiElements.
// ------------------------------------------------------------------------

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

// Two different ways to generate the same pattern used in the bright variable.
(0.1,0.2..0.8)
(1..8) * 0.1