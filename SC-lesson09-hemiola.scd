// SuperCollider Course
// Fall 2022 - Winter 2023
// Lesson No. 9 --- Hemiola

// ---------------------------------------------------------------------
// Setting up the samples.
// ---------------------------------------------------------------------

(
SynthDef(\samplerMono, {
    arg buf, rate = 1, spos = 0, pan = 0, amp = 1, out = 0;
    var sig = PlayBuf.ar(
        numChannels: 1,
        bufnum: buf,
        rate: rate * BufRateScale.ir(buf),
        startPos: spos * BufSampleRate.ir(buf),
        doneAction: 2
    ) * amp;
    sig = Pan2.ar(sig, pan);
    Out.ar(out, sig);
}).add;
~kick = Buffer.read(s, "/Users/guillaumepelletier/Desktop/Dropbox/Art/SuperCollider/Dirt-Samples-master/808bd/BD2575.WAV");
~snare = Buffer.read(s, "/Users/guillaumepelletier/Desktop/Dropbox/Art/SuperCollider/Dirt-Samples-master/808sd/SD5075.WAV");
~hat = Buffer.read(s, "/Users/guillaumepelletier/Desktop/Dropbox/Art/SuperCollider/Dirt-Samples-master/808/CH.WAV");
~clock = TempoClock.new(1).permanent_(true);
)

// ---------------------------------------------------------------------
// First we need the ~visualDrums function.
// ---------------------------------------------------------------------

(
var length = 12;
~visualDrums = {
    var stepIndex = Pseq((0..(length-1)), inf).asStream;
    ~drums.stop;
    ~drums = Pbind(
        \instrument, \samplerMono,
        \dur, Pseq([1/16], inf),
        \buf, FuncStream({
            var step = stepIndex.next;
            var bufs = [];
            var ff = {|item|if(item.isNumber,{item},{"?"})};
            var ksh = [~kickSeq, ~snarSeq, ~hatsSeq];
            ksh = ksh.collect({|item|item.wrapExtend(length)});
            [~kick, ~snare, ~hats].do({
                |item, i|
                if (ksh[i][step].next == 1, {bufs = bufs.add(item)});
            });
            12.do({"".postln});
            ("  " ++ (("•").asString).padLeft((step+1)*3, " ")).postln;
            ksh.do({|item|item.collect(ff).postln});
            if (bufs.size == 0, {bufs = Rest()});
            bufs;
        }),
        \amp, Pseq([0.5, 0.5], inf),
        \pan, Pwhite(-0.75, 0.75, inf)
    ).play(~clock, quant: [2]);
};
// ~visualDrums.();
)

// ---------------------------------------------------------------------
// Third rhythmic principle: Hemiola.
// ---------------------------------------------------------------------

// Continuing tresillo... what do we get???
(
~kickSeq = [1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0];
~snarSeq = [1, 0, 0, 1, 0, 0, 1, 0]; // Tresillo
~snarSeq = [1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0]; // Continued tresillo.
~hatsSeq = [0];
)

~visualDrums.();

// Waltz
(
~kickSeq = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
~snarSeq = [0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0];
~hatsSeq = [0];
)

~visualDrums.();

// ---------------------------------------------------------------------
// Hemiola = 3 against 2.
// ---------------------------------------------------------------------

// 3 against 2
// Kicks have 2 and snares have 3.
(
~kickSeq = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0];
~snarSeq = [1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0];
~hatsSeq = [0];
)

~visualDrums.();

// 3 against 2
// Kicks have 3 and snares have 2.
(
~kickSeq = [1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0];
~snarSeq = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0];
~hatsSeq = [0];
)

~visualDrums.();

// 4 against 3
// Kicks have 3 and snares have 4.
(
~kickSeq = [1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0];
~snarSeq = [1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0];
~hatsSeq = [0];
)

~visualDrums.();

// 4 against 3
// Kicks have 4 and snares have 3.
(
~kickSeq = [1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0];
~snarSeq = [1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0];
~hatsSeq = [0];
)

~visualDrums.();

// ---------------------------------------------------------------------
// Examples of hemiola
// ---------------------------------------------------------------------

// Asha gèdawo, Menelik Wèsnatchèw
// https://www.youtube.com/watch?v=mw1SGxC7lU8
// Afrotopia ft. Jean-Patrice Keka & Vanyfox
// https://moonshinemu.bandcamp.com/track/afrotopia-ft-jean-patrice-keka-vanyfox

// Vanyfox | Boiler Room x Primavera Sound Barcelona
// https://youtu.be/9zoc4imT4pw?t=1808

// More information on hemiola
// CK LADZEKPO (1) - Drum Rhythm Principles of Percussion Polyrhythm from Ghana, West Africa
// https://www.youtube.com/watch?v=yK42w0H8rSU

// ---------------------------------------------------------------------
// Africab Bell Pattern
// ---------------------------------------------------------------------
// https://en.wikipedia.org/wiki/Bell_pattern

(
//          1                 2                     3                 4
~snarSeq = [1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0] ++ [0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0];
~kickSeq = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0] ++ [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0];
~hatsSeq = [0];
)

~kickSeq = [0];
~clock.tempo = 0.75;
~clock.tempo = 0.5;

~visualDrums.();
