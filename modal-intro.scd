
// Karplus–Strong
// The most basic string model.
// https://en.wikipedia.org/wiki/Karplus%E2%80%93Strong_string_synthesis
(
{
    Pluck.ar(
        in: PinkNoise.ar(0.1),
        trig: Impulse.kr(MouseY.kr(2, 20)),
        maxdelaytime: 440.reciprocal,
        delaytime: 440.reciprocal,
        decaytime: 10,
        coef: MouseX.kr(-0.999, 0.999)
    ) * 2 ! 2;
}.play();
)

// String model by Émilie Gillet.
(
{
    MiPlaits.ar(
        pitch: 220.cpsmidi,
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
        morph: 0.2,
        trigger: Impulse.kr(15)
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
    )[0] * 0.2 ! 2;
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
{
    var t = Impulse.kr(8);
    var d = t * Demand.kr(t, 0, Dseq(
        [1, 0, 0, 1, 0, 0, 1, 0] ++
        [0, 0, 1, 0, 1, 0, 0, 0], inf));
    var morph = Demand.kr(d, 0, Dwhite(0.2, 0.4, inf));
    MiPlaits.ar(
        pitch: ~toMidi.("G6"),
        engine: 12,
        harm: 0.8,
        timbre: 0.4,
        morph: morph,
        trigger: d
    )[0] * 0.2 ! 2;
}.play;
)

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
        engine: 0,
        harm: 0.8,
        timbre: 0.4,
        morph: morph,
        trigger: d,
        decay: 0.5,
        lpg_colour: 0.2
    )[0] * 0.2 ! 2;
}.play;
)