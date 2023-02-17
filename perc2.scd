(
SynthDef(\samplerMono, {
    arg buf, rate = 1, spos = 0, pan = 1, amp = 1, atk = 0.001, susT = 1, rel = 0.01, out = 0;
    var sig, env, lfo;
    // env = EnvGen.kr(Env.new([0, 1, 1, 0], [atk, susT, rel], ['lin', -8]), doneAction: 2);
    sig = PlayBuf.ar(
        1, buf,
        rate * BufRateScale.ir(buf),
        startPos: spos * BufSampleRate.ir(buf),
        doneAction: 2
    );
    sig = sig * amp;
    sig = Pan2.ar(sig, pan);
    Out.ar(out, sig);
}).add;
)

~snare = Buffer.read(s, "/Users/guillaumepelletier/Desktop/Dropbox/Art/SuperCollider/Dirt-Samples-master/808sd/SD5075.WAV");
~kick = Buffer.read(s, "/Users/guillaumepelletier/Desktop/Dropbox/Art/SuperCollider/Dirt-Samples-master/808bd/BD7525.WAV");
~kick = Buffer.read(s, "/Users/guillaumepelletier/Desktop/Dropbox/Art/SuperCollider/Dirt-Samples-master/808bd/BD2575.WAV");
~hats = Buffer.read(s, "/Users/guillaumepelletier/Desktop/Dropbox/Art/SuperCollider/Dirt-Samples-master/808/CH.WAV");
~clav = Buffer.read(s, "/Users/guillaumepelletier/Desktop/Dropbox/Art/SuperCollider/Dirt-Samples-master/808/CL.WAV");
~kick.numChannels
~kick.play
~snare.play

~kickSeq = [1, 0, 0, 1, 0, 0, 1, 0] ++ [0, 0, 1, 0, 1, 0, 0, 0];
~snarSeq = [0, 0, 1, 0, 1, 0, 0, 0] ++ [0, 1, 0, 0, 1, 0, 0, 1];
~hatsSeq = [1, 1, 1, 0, 1, 0, 1, 1];
~clavSeq = [0, 0, 0, 0, 0, 0, 0, 0];// ++ [0, 0, 1, 0, 1, 0, 0, 0];
~clavSeq


(
var a = Pwrand([0, 1], [0.5, 0.5], inf).asStream;
var b = Pwrand([0, 1], [0.1, 0.9], inf).asStream;
var c = Pwrand([0, 1], [0.9, 0.1], inf).asStream;
~kickSeq = [1, 0, 0, 0, 1, 0, 0, 0];
~snarSeq = [0, 0, 0, 0, 1, 0, 0, 0] ++ [0, a, 0, 0, 1, 0, 0, 1];
~hatsSeq = [1, b, 1, 0, 1, 0, 1, 1];
)


(
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
).play(quant: [2]);
)




(
SynthDef("kick808", {arg out = 0, freq1 = 240, freq2 = 60, amp = 1, ringTime = 10, att = 0.001, rel = 1, dist = 0.5, pan = 0;
    var snd, env;
    snd = Ringz.ar(
        in: Impulse.ar(0), // single impulse
        freq: XLine.ar(freq1, freq2, 0.1),
        decaytime: ringTime);
    env = Env.perc(att, rel, amp).kr(doneAction: 2);
    snd = (1.0 - dist) * snd + (dist * (snd.distort));
    snd = snd * env;
    Out.ar(0, Pan2.ar(snd, pan));
}).add;
)



(
SynthDef("snare909", {
    arg
    //Standard Values
    out = 0, pan = 0, freq = 185, amp = 1, att = 0.0005, curve = -2,
    //Other Controls
    toneRel = 0.075, toneAmp = 0.25, noiseRel = 0.4, noiseAmp = 0.2,
    nyquist = 500, lpFreq = 7040, hpFreq = 523;
    var relTimes, env, tone, noise, snd;
    relTimes = ([1, 0.733] * toneRel) ++ ([1, 0.708] * noiseRel);
    env = Env.perc(attackTime: att, releaseTime: relTimes, level: amp, curve: curve).kr;
    tone = LFTri.ar(freq: [1, 1.78] * freq, mul: toneAmp);
    noise = Latch.ar(WhiteNoise.ar, Impulse.ar(nyquist * 2));
    noise = LPF.ar(in: noise, freq: lpFreq, mul: noiseAmp);
    snd = tone ++ [noise, HPF.ar(in: noise, freq: hpFreq)];
    snd = Mix.ar(snd * env);
    DetectSilence.ar(in: snd, doneAction: 2);
    Out.ar(out, Pan2.ar(snd, pan));
}).add;
)

Synth.new(\kick808)
Synth.new(\snare909, [\freq, 220])


var kick =  [1, 0, 0, 1, 0, 0];
var snare = [1, 0, 1, 0, 1, 0];


// Backbeat
// The Knife - 'Handy-Man (FPU Remix)' (Official Audio)
// https://www.youtube.com/watch?v=gj9tb7hzIks
(
var a = Pwrand([0, 1], [0.5, 0.5], inf).asStream;
var b = Pwrand([0, 1], [0.1, 0.9], inf).asStream;
var c = Pwrand([0, 1], [0.9, 0.1], inf).asStream;
~kickSeq = [1, 0, 0, 0, 1, 0, 0, 0];
~snarSeq = [0, 0, 0, 0, 1, 0, 0, 0];
~hatsSeq = [0, 0, 1, 0, 1, 0, 1, 0];
)
~snarSeq = [1, 0, 0, 1, 0, 0, 1, 0] ++ [0, 0, 1, 0, 1, 0, 0, 0]
~snarSeq = [1, 0, 0, 1, 0, 0, 1, 0]
~snarSeq = [1, 0, 0, 1, 0, 0, 1, 0] ++ [0, 0, 0, 0, 0, 0, 0, 0]
~hatsSeq = [0];

(
var key = 62 - 12;
var notes = key + ([0, 0, -5 + 24, -2 + 24].stutter(2).scramble);
~pianoRiff.stop;
~pianoRiff = Pbind(
    \type, \pianoEvent,
    \dur, Pseq([Rest(0.25), 0.25], inf),
    \num, Pseq(notes.stutter(2), inf),
    \dyn, Pseq([0], inf),
    \amp, Pseq([2], inf),
    \pan, Pwhite(-0.75, 0.75, inf),
    \rel, 4
).play(quant: [2]);
)


(
var key = 62 + 24;
var notes = key + ([0, 7, -5, 3] ++ [0, 7, -5, 2]);
~pianoRiff2.stop;
~pianoRiff2 = Pbind(
    \type, \pianoEvent,
    \dur, Pseq([Rest(0.25), 0.25].reverse, inf),
    \num, Pseq(notes.stutter(2), inf),
    \dyn, Pseq([1], inf),
    \amp, Pseq([1], inf),
    \pan, Pwhite(-0.75, 0.75, inf),
    \rel, 4
).play(quant: [2]);
)

// Tresillo & Son Clave
// The Knife - Silent Shout (Official Music Video)
// https://www.youtube.com/watch?v=mWzZnxPAQhs
// Son and Rumba Clave: Learn the Rhythm!
// https://www.youtube.com/watch?v=nCv1Zu9Iocw
(
~kickSeq = [1, 0, 0, 0, 1, 0, 0, 0];
~snarSeq = [1, 0, 0, 1, 0, 0, 1, 0] ++ [0, 0, 0, 0, 0, 0, 0, 0];
~hatsSeq = [0];
)

(
~kickSeq = [1, 0, 0, 1, 0, 0, 0, 0] ++ [0, 0, 0, 0, 0, 0, 0, 0];
~snarSeq = [0, 0, 0, 0, 1, 0, 0, 0];
)

~kickSeq = [1, 0, 0, 1, 0, 0, 1, 0] ++ [0, 0, 1, 0, 1, 0, 0, 0];
~hatsSeq = [1];

(
~snarSeq = [1, 0, 0, 1, 0, 0, 1, 0] ++ [0, 0, 1, 0, 1, 0, 0, 0];
~kickSeq = [1, 0, 0, 0, 1, 0, 0, 0];
)


// CK LADZEKPO (1) - Drum Rhythm Principles of Percussion Polyrhythm from Ghana, West Africa
// https://www.youtube.com/watch?v=yK42w0H8rSU