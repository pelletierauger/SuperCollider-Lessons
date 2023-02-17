// SuperCollider Course
// Fall 2022 - Winter 2023
// Lesson No. 8 --- Samples and rhythmic patterns

// ---------------------------------------------------------------------
// Dealing with percussive samples for our rhythmic experimentations.
// ---------------------------------------------------------------------

// Loading samples individually

~kick = Buffer.read(s, "/Users/guillaumepelletier/Desktop/Dropbox/Art/SuperCollider/Dirt-Samples-master/808bd/BD2575.WAV");
~snare = Buffer.read(s, "/Users/guillaumepelletier/Desktop/Dropbox/Art/SuperCollider/Dirt-Samples-master/808sd/SD5075.WAV");
~hat = Buffer.read(s, "/Users/guillaumepelletier/Desktop/Dropbox/Art/SuperCollider/Dirt-Samples-master/808/CH.WAV");

~kick.play;
~snare.play;
~hat.play;


// Loading a folder of samples into an array.
(
var dir = "/Users/guillaumepelletier/Desktop/Dropbox/Art/SuperCollider/Dirt-Samples-master/808bd/";
var sf = PathName.new(dir);
~kicks = [];
sf.entries.do({| path, i |
    ~kicks = ~kicks.add(Buffer.read(s, path.fullPath));
    path.postln;
});
~kicks.size;
)

// Listening to the first sample in the array.
~kicks[0].play;

// Scanning the array and listening to each sample.
a = 0;
(
~kicks[15].play;
a = (a + 1) % ~kicks.size;
)

// The same thing with snares.
// Loading a folder of samples into an array.
(
var dir = "/Users/guillaumepelletier/Desktop/Dropbox/Art/SuperCollider/Dirt-Samples-master/808sd/";
var sf = PathName.new(dir);
~snares = [];
sf.entries.do({| path, i |
    ~snares = ~snares.add(Buffer.read(s, path.fullPath));
    path.postln;
});
~snares.size;
)

// Listening to the first sample in the array.
~snares[0].play;

// Scanning the array and listening to each sample.
a = 0;
(
~snares[a].play;
a = (a + 1) % ~snares.size;
)


// ---------------------------------------------------------------------
// Using Pbind to create rhythmic patterns.
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
)

// Listening to all samples using a Pbind.
(
~allSnares.stop;
~allSnares = Pbind(
    \instrument, \samplerMono,
    \dur, Pseq([1/4], inf),
    \buf, Pindex(~snares, Pseq((0..~snares.size), inf))
).play;
)

(
~allKicks.stop;
~allKicks = Pbind(
    \instrument, \samplerMono,
    \dur, Pseq([1/4], inf),
    \buf, Pindex(~kicks, Pseq((0..~kicks.size), inf))
).play;
)

// ---------------------------------------------------------------------
// TempoClock
// ---------------------------------------------------------------------

~clock = TempoClock.new(1).permanent_(true);

(
~allSnares.stop;
~allSnares = Pbind(
    \instrument, \samplerMono,
    \dur, Pseq([1/4], inf),
    \buf, Pindex(~snares, Pseq((0..~snares.size), inf)),
    \amp, 0.5
).play(~clock, quant: [1]);
)

(
~allKicks.stop;
~allKicks = Pbind(
    \instrument, \samplerMono,
    \dur, Pseq([1/2], inf),
    \buf, Pindex(~kicks, Pseq((0..~kicks.size), inf)),
    \amp, 0.5
).play(~clock, quant: [1]);
)

// ---------------------------------------------------------------------
// A more visual approach to representing rhythmic ideas in code.
// ---------------------------------------------------------------------

(
var a = Pwrand([0, 1], [0.5, 0.5], inf).asStream;
var b = Pwrand([0, 1], [0.1, 0.9], inf).asStream;
var c = Pwrand([0, 1], [0.9, 0.1], inf).asStream;
~kickSeq = [1, 0, 0, 0, 1, 0, 0, 0];
~snarSeq = [0, 0, 0, 0, 1, 0, 0, 0];
~hatsSeq = [1, 0, 1, 0, 1, 0, 1, 0];
)

(
~visualDrums = {
    var stepIndex = Pseq((0..15), inf).asStream;
    ~drums.stop;
    ~drums = Pbind(
        \instrument, \samplerMono,
        \dur, Pseq([1/8], inf),
        \buf, FuncStream({
            var step = stepIndex.next;
            var bufs = [];
            var ff = {|item|if(item.isNumber,{item},{"?"})};
            var ksh = [~kickSeq, ~snarSeq, ~hatsSeq];
            ksh = ksh.collect({|item|item.wrapExtend(16)});
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
~visualDrums.();
)

// ---------------------------------------------------------------------
// First rhythmic principle: The backbeat
// ---------------------------------------------------------------------

// https://en.wikipedia.org/wiki/Beat_(music)#Backbeat
// A back beat, or backbeat, is a syncopated accentuation on the "off" beat.
// In a simple 4/4 rhythm these are beats 2 and 4.

// Example of a song structured by a backbeat
// The Knife - 'Handy-Man (FPU Remix)' (Official Audio)
// https://www.youtube.com/watch?v=gj9tb7hzIks
(
var a = Pwrand([0, 1], [0.5, 0.5], inf).asStream;
var b = Pwrand([0, 1], [0.1, 0.9], inf).asStream;
var c = Pwrand([0, 1], [0.9, 0.1], inf).asStream;
//          1           2           3           4
~kickSeq = [1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0];
~snarSeq = [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0]; // Backbeat
~hatsSeq = [0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0];
)
~visualDrums.();

// A simple bass SynthDef to make some tests.
(
SynthDef.new(\bassNote, {
    arg freq = 440, amp = 1;
    var env = Env([0.001, 1, 0.001], [0.0005, 0.6], \exp);
    var envG = EnvGen.kr(env, doneAction: 2);
    var sig = LFTri.ar(freq);
    sig = VadimFilter.ar(sig, 7000 * envG + 1000, 0);
    Out.ar(0, sig * amp * envG ! 2);
}).add;
)

// Bass notes on the beat
(
var key = 43;
var notes = key + ([0, 0, -5 + 24, -2 + 24].stutter(2));
~bass.stop;
~bass = Pbind(
    \instrument, \bassNote,
    \dur, Pseq([Rest(0.25), 0.25].reverse, inf),
    \freq, Pseq([key.midicps], inf),
    \dyn, Pseq([0], inf),
    \amp, Pseq([1], inf),
    \pan, Pwhite(-0.75, 0.75, inf),
    \rel, 4
).play(~clock, quant: [2]);
)

// Bass notes that are offbeat
(
var key = 43;
var notes = key + ([0, 0, -5 + 24, -2 + 24].stutter(2));
~bass.stop;
~bass = Pbind(
    \instrument, \bassNote,
    \dur, Pseq([Rest(0.25), 0.25], inf),
    \freq, Pseq([key.midicps], inf),
    \dyn, Pseq([0], inf),
    \amp, Pseq([1], inf),
    \pan, Pwhite(-0.75, 0.75, inf),
    \rel, 4
).play(~clock, quant: [2]);
)

// ---------------------------------------------------------------------
// Second rhythmic principle: Tresillo & Son Clave
// ---------------------------------------------------------------------

// Tresillo
(
~kickSeq = [1, 0, 0, 0, 1, 0, 0, 0];
~snarSeq = [1, 0, 0, 1, 0, 0, 1, 0]; // This is tresillo (3 hits).
~hatsSeq = [0];
)
~visualDrums.();

// Tresillo is a fragment of a cross-rhythm (2 contradicting pulses).
// This is why it’s exciting and makes you wanna dance. It has tension.
// This a "completed cross-rhythm". We’re gonna hear it later.
~kickSeq = [1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0]; // First pulse.
~snarSeq = [1, 0, 0, 1, 0, 0, 1, 0]; // Second pulse: tresillo
~snarSeq = [1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0]; // Continued tresillo.

// Cinquillo, an embellished tresillo.
~snarSeq = [1, 0, 1, 1, 0, 1, 1, 0]; // Cinquillo (5 hits).
~kickSeq = [1, 0, 0, 0, 0, 0, 0, 0];
~kickSeq = [1, 0, 0, 0, 1, 0, 0, 0];

// Example of tresillo
// Lido Pimienta - "Eso Que Tu Haces"
// https://www.youtube.com/watch?v=2azy1D-yyWc

// Son Clave
(
~kickSeq = [1, 0, 0, 0, 1, 0, 0, 0];
~snarSeq = [1, 0, 0, 1, 0, 0, 1, 0] ++ [0, 0, 1, 0, 1, 0, 0, 0]; // This is son clave.
~hatsSeq = [0];
)
~visualDrums.();

// Son Clave from 1926 to 2022:
// Sexteto Occidente - Adriana - Columbia 2478-X
// https://www.youtube.com/watch?v=u-Sq0GnzEAs
// Pierre Kwenders, Uproot Andy - Ofele (Official video)
// https://www.youtube.com/watch?v=7FpTEl0KDuc

// A lot more information about Son Clave:
// Son and Rumba Clave: Learn the Rhythm!
// https://www.youtube.com/watch?v=nCv1Zu9Iocw

// A variant: Rumba Clave
~snarSeq = [1, 0, 0, 1, 0, 0, 0, 1] ++ [0, 0, 1, 0, 1, 0, 0, 0];

// Tresillo in a song by The Knife
// The Knife - Silent Shout (Official Music Video)
// https://www.youtube.com/watch?v=mWzZnxPAQhs
(
~snarSeq = [0, 0, 0, 0, 0, 0, 0, 0];
~kickSeq = [1, 0, 0, 1, 0, 0, 1, 0] ++ [0, 0, 0, 0, 0, 0, 0, 0];
~hatsSeq = [0];
)
~visualDrums.();
// An alternative with no cross-rhythm.
~kickSeq = [1, 0, 0, 0, 1, 0, 0, 0] ++ [1, 0, 0, 0, 0, 0, 0, 0];
~hatsSeq = [1, 0, 0, 0, 1, 0, 0, 0]; // Bring in the hats.

// Tresillo in a song by The Smashing Pumpkins
// Siva (Remastered 2011)
// https://youtu.be/9QUk__7Z3zk?t=161
(
~snarSeq = [0, 0, 0, 0, 0, 0, 0, 0];
~kickSeq = [1, 0, 0, 1, 0, 0, 1, 0] ++ [0, 0, 1, 0, 1, 0, 1, 0];
~hatsSeq = [0];
)
~visualDrums.();


// ---------------------------------------------------------------------
// Third rhythmic principle: Hemiola
// ---------------------------------------------------------------------

// Continuing tresillo... what do we get???
(
~snarSeq = [1, 0, 0, 1, 0, 0, 1, 0]; // Tresillo
~kickSeq = [1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0];
~snarSeq = [1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0]; // Continued tresillo.
~hatsSeq = [0];
)

// Hemiola = 3 against 2.
(
~kickSeq = [1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0];
~snarSeq = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0];
~hatsSeq = [0];
)

(
~visualDrums = {
    var stepIndex = Pseq((0..11), inf).asStream;
    ~drums.stop;
    ~drums = Pbind(
        \instrument, \samplerMono,
        \dur, Pseq([1/8], inf),
        \buf, FuncStream({
            var step = stepIndex.next;
            var bufs = [];
            var ff = {|item|if(item.isNumber,{item},{"?"})};
            var ksh = [~kickSeq, ~snarSeq, ~hatsSeq];
            ksh = ksh.collect({|item|item.wrapExtend(12)});
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
~visualDrums.();
)

// An example of hemiola
// Asha gèdawo, Menelik Wèsnatchèw
// https://www.youtube.com/watch?v=mw1SGxC7lU8

// More information on hemiola
// CK LADZEKPO (1) - Drum Rhythm Principles of Percussion Polyrhythm from Ghana, West Africa
// https://www.youtube.com/watch?v=yK42w0H8rSU