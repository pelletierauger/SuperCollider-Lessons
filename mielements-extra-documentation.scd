// ----------------------------------------------------------------------------- //
// MiElements "Ominous" Easter Egg Mode: A hidden 2x2-op FM synth.
// Full instructions here: https://modwiggler.com/forum/viewtopic.php?t=134148
// ----------------------------------------------------------------------------- //


// In "Ominous" Easter Egg Mode, the controls of MiElements do not have the same
// names as they normally do. Below is a Synth where the Easter Egg controls are
// presented, with names and descriptions intertwined with the code.
(
{
    var t = Impulse.kr(7);
    var env = EnvGen.kr(Env([0, 1, 0], [0.025, 2], [2, -8]), t);
    var note = Demand.kr(t, 0, Dseq([0, -2, 2, -5].stutter(8), inf));
    var mod = Demand.kr(t, 0, Dwhite());
    var mod2 = Demand.kr(t, 0, Dseq(Dseries(0, 1/16, 16), inf));
    MiElements.ar(
        blow_in: 0,                strike_in: 0,               gate: t,
        pit: 50 + note,            strength: mod2,

        // Shape of the built-in envelope that is triggered -------------------- //
        // by the GATE input.
        contour: 0.15,

        // Detuning of oscillator 2 with respect to oscillator 1. -------------- //
        // The range is -2 octaves to 2 octaves, with strategically placed notches.
        bow_level: 0.25,

        // Oscillator 1 level           Oscillator 2 level --------------------- //
        blow_level: 0.5,                strike_level: 0.5,

        // Carrier/modulator frequency ratio ----------------------------------- //
        // Oscillator 1                 Oscillator 2
        flow: 0.5,                      mallet: 0.5,

        // Oscillator 1 & 2 feedback amount ------------------------------------ //
        bow_timb: 0.35,

        // FM Amount ----------------------------------------------------------- //
        // Oscillator 1                 Oscillator 2
        blow_timb: env,                 strike_timb: mod,

        // Response of the stereo filter. This interpolates between low-pass, -- //
        // notch, high-pass, and finally band-pass. The filter has a mild resonance.
        // No dedicated resonance control because it's kind of silly on FM timbres.
        geom: 0.14,

        // Cutoff frequency of the stereo filter ------------------------------- //
        bright: 0.67 + (mod * 0.2) * (mod2 * 0.5 + 0.5),

        // Amount of filter modulation from the internal envelope -------------- //
        // and the STRENGTH CV input.
        damp: 0.25,

        // Mixing configuration. When set to its minimum value, OUT L contains
        // the raw mix of both oscillators, and OUT R a mono signal without
        // spatialization (but with the filter and VCA). When turning the knob
        // further, you reach a zone where the stereo rotation becomes more
        // intense. Past 12 o'clock (0.5), the reverb kicks in.
        space: 0.65,

        easteregg: 1
    );
}.play;
)


// You can also use the blow_in and strike_in external inputs for audio-rate
// phase modulation of both oscillators.
(
{
    var t = Impulse.kr(4);
    var env = EnvGen.kr(Env([0, 1, 0], [1, 0.1], [2, -8]), t);
    var note = Demand.kr(t, 0, Dseq([0, 3, -2, -5].stutter(8), inf));
    var mod = Demand.kr(t, 0, Dwhite());
    var mod2 = Demand.kr(t, 0, Dseq(Dseries(0, 1/16, 16), inf));
    // Using PinkNoise as input.
    var noise = PinkNoise.ar() * 4 * (mod2.lag(0.5)) * env;
    MiElements.ar(
        // OP1 Phase Mod           OP2 Phase Mod
        blow_in: noise,            strike_in: noise,               gate: t,
        //                                                         Envelope Shape
        pit: 40 + note,            strength: mod2,                 contour: 0.25,
        // OP2 to OP1 Detune       OP1 Level                       OP2 Level
        bow_level: 0.5,            blow_level: 0.5,                strike_level: 0.5,
        // OP1 Freq Ratio          OP2 Freq Ratio
        flow: 0.25,                mallet: 0.75,
        // OP1 & 2 Feedback        OP1 FM Amount                   OP2 FM Amount
        bow_timb: 0.235,           blow_timb: env,                 strike_timb: mod,
        // Filter Response         Filter Cutoff Freq
        geom: 0.14,                bright: 0.67 + (mod * 0.2) * (mod2 * 0.5 + 0.5),
        // Amount of Filter Mod    Mixing and Reverb
        damp: 0.01,                space: 0.265,                   easteregg: 1
    );
}.play;
)

// ----------------------------------------------------------------------------- //
// MiElements String Model Chords
// ----------------------------------------------------------------------------- //

/*
In the strings model (2), the resonator plays chords
that can be selected using the geom parameter.
In this model, geom can only have 11 different values:
0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, and 1.0.
Values in between these can be used, but they will be quantized
to the closest lower value.

These 11 values of geom represent 11 different chords, each made of 5 strings.
Below you can see what those chords are. Each value of geom is paired with
an array of 5 pitches and a description. In the pitches arrays, the values
represent the distances in semitones between a note and the fundamental
frequency as defined by the pit parameter.

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