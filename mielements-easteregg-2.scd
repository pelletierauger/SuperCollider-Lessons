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
        pit: 40 + note,            strength: mod2,                 contour: 0.1,
        // OP2 to OP1 Detune       OP1 Level                       OP2 Level
        bow_level: 0.5,            blow_level: 0.5,                strike_level: 0.5,
        // OP1 Freq Ratio          OP2 Freq Ratio
        flow: 0.5,                mallet: 1,
        // OP1 & 2 Feedback        OP1 FM Amount                   OP2 FM Amount
        bow_timb: 0,           blow_timb: 0,                 strike_timb: 0,
        // Filter Response         Filter Cutoff Freq
        geom: 0.14,                bright: 0.67 + (mod * 0.2) * (mod2 * 0.5 + 0.5),
        // Amount of Filter Mod    Mixing and Reverb
        damp: 0.01,                space: 0.265,                   easteregg: 1
    );
}.play;
)