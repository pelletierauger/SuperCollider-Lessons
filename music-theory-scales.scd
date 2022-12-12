
// -----------------------------------------------------------------------------
// Consonance and dissonance
// -----------------------------------------------------------------------------

{LFTri.ar(440) * 0.1 ! 2}.play;
{LFTri.ar(440 * 1.5) * 0.1 ! 2}.play;
{LFTri.ar(440 * 1.25) * 0.1 ! 2}.play;

440 * 2.pow(4/12);
440 * 4.midiratio;
440 * 1.25;

{LFTri.ar(440) * 0.1 ! 2}.play;
{LFTri.ar(440 * 7.midiratio) * 0.1 ! 2}.play;
{LFTri.ar(440 * 4.midiratio) * 0.1 ! 2}.play;

// -----------------------------------------------------------------------------
// What is a scale? How do we build one?
// -----------------------------------------------------------------------------

Scale.major.degrees;
[ 0, 2, 4, 5, 7, 9, 11 ];

One octave            Two octaves
░█░█░░█░█░█░          ░█░█░░█░█░█░░█░█░░█░█░█░
c d ef g a b          c d ef g a bc d ef g a b

~steps = [2, 2, 1, 2, 2, 2, 1];
a.rotate(-5);
a;

(
~makeScale = {
    |r|
    var scale = [0];
    ~steps.rotate(r[0]).do({|step, i| scale = scale.add(scale[i] + step)});
    ~scale = scale;
};
)

~scale;
~scale[0..6];
Scale.phrygian.degrees;

~makeScale.([0]);      // Ionian (Major),
~makeScale.([-1, 6]);  // Dorian,
~makeScale.([-2, 5]);  // Phrygian,
~makeScale.([-3, 4]);  // Lydian,
~makeScale.([-4, 3]);  // Mixolydian,
~makeScale.([-5, 2]);  // Aeolian (Natural Minor)
~makeScale.([-6, 1]);  // Locrian

~scale.asString
var ss = ""; ~scale.do({|item|ss=ss++item.asString.padRight(4, ".")});ss;
(
var key = ~toMidi.("C4");
var noteIndex = Pseq((0..7), inf).asStream;
~arpeggiatingTheScale.stop;
~arpeggiatingTheScale = Pbind(
    \type, \pianoEvent,
    \dur, 0.5,
    \num, key + FuncStream({
        var scst = "";
        var nn = noteIndex.next;
        var n = ~scale[nn];
        12.do({"".postln});
        (n).asString.padLeft(nn*4+(n.asString.size), " ").postln;
        ~scale.do({|item|scst=scst++item.asString.padRight(4, ".")});
        scst.postln;
        n;
        }),
    \dyn, Pseq([1, 1], inf),
    \amp, Pseq([0.5, 0.125] * 0.5, inf),
    \pan, Pwhite(-0.75, 0.75, inf),
    \rel, 2
).play(quant: [2]);
)

(
var key = ~toMidi.("C2");
~pianoKey.stop;
~pianoKey = Pbind(
    \type, \pianoEvent,
    \dur, Pseq([2], inf),
    \num, key,
    \dyn, Pseq([0, 0], inf),
    \amp, Pseq([0.5, 0.25], inf),
    \pan, Pwhite(-0.75, 0.75, inf),
    \rel, 4
).play(quant: [2]);
)

~scale
(
~wholeToneScale = {
    |r|
    var scale = [0];
    [2, 2, 2, 2, 2, 2].do({|step, i| scale = scale.add(scale[i] + step)});
    ~scale = scale;
};
~wholeToneScale.();
)


(
var key = ~toMidi.("C4");
var notes = key + (Scale.major.degrees ++ [12]);
notes.postln;
key = ~toMidi.("A3");
notes = key + (Scale.minor.degrees ++ [12]);
notes.postln;
)