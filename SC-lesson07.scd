// SuperCollider Course
// Fall 2022 - Winter 2023
// Lesson No. 7 --- More harmony concepts


7th chords, 9th, 11th, 13th


░█░█░░█░█░█░░█░█░░█░█░█░
c d ef g a bc d ef g a b
c  x...x..x
d    x..x...x
e      x..x...x
f       x...x..x
g         x...x..x
a           x..x...x
b             x..x...x


░█░█░░█░█░█░░█░█░░█░█░█░
c d ef g a bc d ef g a b
c  x...x..x...x
d    x..x...x..x
e      x..x...x..x
f       x...x..x...x
g         x...x..x..x
a           x..x...x..x
b             x..x..x...x

~two_oct = ~scale[0..6] ++ (~scale[0..6]+12);
~three_oct = ~scale[0..6] ++ (~scale[0..6]+12) ++ (~scale[0..6]+24);

// Make chords from triads
~chords = []; 7.do({|i| ~chords = ~chords.add(~two_oct[i+0,i+2..i+4])}); ~chords;

// Make seventh chords
~chords = []; 7.do({|i| ~chords = ~chords.add(~three_oct[i+0,i+2..i+6])}); ~chords;

// Make ninth chords
~chords = []; 7.do({|i| ~chords = ~chords.add(~three_oct[i+0,i+2..i+8])}); ~chords;

// Make eleventh chords
~chords = []; 7.do({|i| ~chords = ~chords.add(~three_oct[i+0,i+2..i+10])}); ~chords;

// Make thirteenth chords
~chords = []; 7.do({|i| ~chords = ~chords.add(~three_oct[i+0,i+2..i+12])}); ~chords;

// Stacking fourths
~chords = []; 7.do({|i| ~chords = ~chords.add(~three_oct[i+0,i+3..i+6])}); ~chords;
~chords = []; 7.do({|i| ~chords = ~chords.add(~three_oct[i+0,i+3..i+9])}); ~chords;

// Stacking fifths
~chords = []; 7.do({|i| ~chords = ~chords.add(~three_oct[i+0,i+4..i+8])}); ~chords;
~chords = []; 7.do({|i| ~chords = ~chords.add(~three_oct[i+0,i+4..i+12])}); ~chords;
~chords = []; 7.do({|i| ~chords = ~chords.add(~three_oct[i+0,i+4..i+16])}); ~chords;


(
var key = ~toMidi.("C4");
var siz = ~chords[0].size;
var repeats = 1; // repeats must be a positive integer.
var transpositions = [0, 0].stutter(siz);
var noteIndex = Pseq((0..((siz*7)*repeats-1)), inf).asStream;
var keyIndex = Pseq((0..6), inf).asStream;
var arpeggio = 0.025/2;
var durs = (arpeggio!(siz-1)) ++ [2 - (arpeggio*(siz-1))];
// var arpeggio = 2/3;
var r = repeats;
var displayChordFunctions = {
    | n |
    var names = ["I", "II", "III", "IV", "V", "VI", "VII"];
    var c = ~chords.stutter(r).[n/siz];
    var name = if (c[1] - c[0] == 4, {names[n/siz/r]}, {names[n/siz/r].toLower});
    var pad = 12;
    if (c[2] - c[0] == 6, {name = name ++ "°"; pad = pad + 1});
    name = ("Chord " ++ name).padRight(pad, string: " ");
    if (n % (siz*r) == 0, {((name + ~chords.stutter(r).[n / siz])).postln});
};
var amps = Pseries(0.25, 0.75/siz, siz).asStream.nextN(siz);
~ascendingChords.stop;
~ascendingChords = Pbind(
    \type, \pianoEvent,
    \dur, Pseq(durs * r.reciprocal, inf),
    \num, key + FuncStream({
        var n = noteIndex.next;
        displayChordFunctions.(n);
        (~chords.stutter(r).flat + transpositions).[n];
    }),
    \dyn, 1,
    \amp, Pseq(amps * 0.25, inf),
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

// -----------------------------------------------------------------------------
// Chord inversions
// -----------------------------------------------------------------------------

(
~inversion = {
    | a, n |
    var si = a.size;
    a = a.rotate(n * -1);
    if (n > 0, {
        a = a + ((0!(si-n))++(12!(n)));
    }, {
        a = a + ((-12!(abs(n)))++(0!(si-abs(n))));
    });
};
~inversion.(~chords[0], -1);
)
~chords[0]

(
var notes = ~inversion.(~chords[0], 1);
Pbind(\type, \pianoEvent, \dur, 0.01, \num, Pseq(~toMidi.("C4")+notes),\dyn,1,).play;
)

// -----------------------------------------------------------------------------
// Chords as drones
// -----------------------------------------------------------------------------


~lfo = {|f,b=0,e=1|SinOsc.kr(f).unipolar.linlin(0,1,b,e)};
~v = {|in,f=500,r=0,t=1|VadimFilter.ar(in,f,r,t)};

~chords[0]

(
var root = ~toMidi.("A3");
var notes = root + ~inversion.(~chords[0], 0);
var normArr = (0..(notes.size-1))/(notes.size-1);
normArr.postln;
x.set(\gate, 0, \fadeTime, 0.5);
x = {
    var sig = MiBraids.ar(notes ++ [root-24],
        timbre: 0.5, color: 0.5, model: 29
    );
    sig = sig.sum ! 2;
    // sig = Splay.ar(sig)*4;
    sig = ~v.(sig,4e3);
    sig = sig * 0.1;
}.play(fadeTime: 0.5);
)




Suspended chords
Harmonic functions
Chords progressions
Voice leading
