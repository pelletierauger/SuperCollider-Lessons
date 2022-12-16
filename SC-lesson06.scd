// SuperCollider Course
// Fall 2022 - Winter 2023
// Lesson No. 6 --- Music theory concepts and explorations

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
~steps;
~steps.rotate(-5);

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

(
~wholeToneScale = {
    |r|
    var scale = [0];
    [2, 2, 2, 2, 2, 2].do({|step, i| scale = scale.add(scale[i] + step)});
    ~scale = scale;
};
~wholeToneScale.();
)
~scale;

(
var key = ~toMidi.("C4");
var notes = key + (Scale.major.degrees ++ [12]);
notes.postln;
key = ~toMidi.("A3");
notes = key + (Scale.minor.degrees ++ [12]);
notes.postln;
)

// -----------------------------------------------------------------------------
// What is a chord? How do we build one?
// -----------------------------------------------------------------------------

░█░█░░█░█░█░░█░█░░█░█░█░
c d ef g a bc d ef g a b
c  x...x..x
d    x..x...x
e      x..x...x
f       x...x..x
g         x...x..x
a           x..x...x
b             x..x...x

~scale;
~two_oct = ~scale[0..6] ++ (~scale[0..6]+12);
~two_oct[0,2..4];

var a = 1; ~chord = ~two_oct[a+0,a+2..a+4];

~chords = []; 7.do({|i| ~chords = ~chords.add(~two_oct[i+0,i+2..i+4])}); ~chords;

(
var key = ~toMidi.("C4");
var repeats = 1; // repeats must be a positive integer.
var transpositions = [0, 0].stutter(3);
var noteIndex = Pseq((0..(21*repeats-1)), inf).asStream;
var keyIndex = Pseq((0..6), inf).asStream;
var arpeggio = 0.025;
// var arpeggio = 2/3;
var r = repeats;
var displayChordFunctions = {
    | n |
    var names = ["I", "II", "III", "IV", "V", "VI", "VII"];
    var c = ~chords.stutter(r).[n/3];
    var name = if (c[1] - c[0] == 4, {names[n/3/r]}, {names[n/3/r].toLower});
    var pad = 12;
    if (c[2] - c[0] == 6, {name = name ++ "°"; pad = pad + 1});
    name = ("Chord " ++ name).padRight(pad, string: " ");
    if (n % (3*r) == 0, {((name + ~chords.stutter(r).[n / 3])).postln});
};
~ascendingChords.stop;
~ascendingChords = Pbind(
    \type, \pianoEvent,
    \dur, Pseq([arpeggio, arpeggio, 2 - (arpeggio * 2)] * r.reciprocal, inf),
    \num, key + FuncStream({
            var n = noteIndex.next;
            displayChordFunctions.(n);
            (~chords.stutter(r).flat + transpositions).[n];
    }),
    \dyn, 1,
    \amp, Pseq([0.25, 0.5, 1] * 0.25, inf),
    \pan, Pwhite(-0.75, 0.75, inf),
    \rel, 4
).play(quant: [2]);
~ascendingRootNotes.stop;
~ascendingRootNotes = Pbind(
    \type, \pianoEvent,
    \dur, Pseq([2], inf),
    // \num, Pseq(key - 24 + ~scale[0..6], inf),
    \num, key - 24 + FuncStream({~scale[keyIndex.next]}),
    \dyn, Pseq([0, 0], inf),
    \amp, Pseq([0.5, 0.25], inf),
    \pan, Pwhite(-0.75, 0.75, inf),
    \rel, 4
).play(quant: [2]);
)

(
// A version of ~makeScale that also builds the ~chords array;
~makeScale = {
    |r|
    var scale = [0];
    ~steps.rotate(r[0]).do({|step, i| scale = scale.add(scale[i] + step)});
    ~scale = scale;
    ~two_oct = ~scale[0..6] ++ (~scale[0..6]+12);
    ~chords = []; 7.do({|i| ~chords = ~chords.add(~two_oct[i+0,i+2..i+4])});
    ~scale;
};
)

// Arpeggiating ~chords.
(
var key = ~toMidi.("C4");
var notes = key + (~chords.stutter(4)).flat;
var arpeggio = 2/3;
~pianoRiff2.stop;
~pianoRiff2 = Pbind(
    \type, \pianoEvent,
    \dur, Pseq([arpeggio, arpeggio, 2 - (arpeggio * 2)] * 0.25, inf),
    \num, Pseq(notes + 12, inf) + Pseq([-12, 0, 12, 0].stutter(3), inf),
    \dyn, Pseq([1, 1], inf),
    \amp, Pseq([0.5, 0.125].reverse * 0.5, inf),
    \pan, Pwhite(-0.75, 0.75, inf),
    \rel, 4
).play(quant: [2]);
~pianoKey.stop;
~pianoKey = Pbind(
    \type, \pianoEvent,
    \dur, Pseq([2], inf),
    \num, Pseq(key - 24 + ~scale[0..6], inf),
    \dyn, Pseq([0, 0], inf),
    \amp, Pseq([0.5, 0.25], inf),
    \pan, Pwhite(-0.75, 0.75, inf),
    \rel, 4
).play(quant: [2]);
)