


   ░█░█░░█░█░█░░█░█░░█░█░█░
   C D EF G A BC D EF G A B
C  x...x..x
D    x..x...x
E      x..x...x
F       x...x..x
G         x...x..x
A           x..x...x
B             x..x...x


~scale;
~two_oct = ~scale[0..6] ++ (~scale[0..6]+12);
~two_oct[0,2..4]

var a = 1; ~chord = ~two_oct[a+0,a+2..a+4];

~chords = []; 7.do({|i| ~chords = ~chords.add(~two_oct[i+0,i+2..i+4])}); ~chords;

(
var key = ~toMidi.("C4");
var repeats = 1; // repeats must be a positive integer.
var transpositions = [0, 0].stutter(3);
var chords = ~chords;
var noteIndex = Pseq((0..((chords.stutter(repeats).size*3)-1)), inf).asStream;
var keyIndex = Pseq((0..(chords.size-1)), inf).asStream;
var arpeggio = 0.025;
var r = repeats;
var scale = chords.collect({|item|item[0]});
~ascendingChords.stop;
~ascendingChords = Pbind(
    \type, \pianoEvent,
    \dur, Pseq([arpeggio, arpeggio, 2 - (arpeggio * 2)] * r.reciprocal, inf),
    \num, key + FuncStream(
        {
            var n = noteIndex.next;
            // Code to display the Chord functions in the Post window.
            var names = ["I", "II", "III", "IV", "V", "VI", "VII"];
            var c = ~chords.stutter(repeats).[n/3];
            var name = if (c[1] - c[0] == 4, {names[n/3/r]}, {names[n/3/r].toLower});
            var pad = 12;
            if (c[2] - c[0] == 6, {name = name ++ "°"; pad = pad + 1});
            name = ("Chord " ++ name).padRight(pad, string: " ");
            if (n % (3*r) == 0, {((name + ~chords.stutter(repeats).[n / 3])).postln});
            // End of code to display the Chord functions in the Post window.
            (~chords.stutter(repeats).flat + transpositions).[n];
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
    \num, key - 24 + FuncStream({scale[keyIndex.next]}),
    \dyn, Pseq([0], inf),
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