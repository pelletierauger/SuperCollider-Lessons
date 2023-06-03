

(
{
    var input = PinkNoise.ar(0.3);
    // var gate = LFPulse.kr(2);
    // var gate = 1 - Impulse.kr(2);
    var gate = Impulse.kr(2);
        var pitch = 45;
    MiElements.ar(
        blow_in: 0,      strike_in: gate,         gate: 0,
        pit: pitch,          strength: 0.5,        contour: 0.2,
        bow_level: 0,        blow_level: 0,        strike_level: 0,
        flow: 0.5,           mallet: 0.5,          bow_timb: 0.5,
        blow_timb: 0.5,      strike_timb: 0.5,     geom: 0.25,
        bright: 0.5,         damp: 0.7,            pos: 0.2,
        space: 0.3,          model: 0,             easteregg: 0
    ) * 1;
}.play;
)

