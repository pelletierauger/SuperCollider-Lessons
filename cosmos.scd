// -----------------------------------------------------------------------
// Run this first block to prepare the piece.
// Then go down to line 81.
// -----------------------------------------------------------------------
(
~carl = Buffer.read(s, thisProcess.nowExecutingPath.dirname +/+ "carl.wav");
~key = "Db1";
SynthDef(\samplerMono, {
    arg buf, rate = 1, spos = 0, pan = 0, amp = 1, out = 0;
    var env = EnvGen.kr(Env([0, 1, 1, 0], [0.01, 10.9 - 1.010, 1]));
    var env2 = EnvGen.kr(Env([0, 1, 1, 0], [0.01, 20.9 - 0.011, 0.001]), doneAction: 2);
    var model = Rand(1, 2).round;
    var sig = PlayBuf.ar(
        numChannels: 1,
        bufnum: buf,
        rate: rate * BufRateScale.ir(buf),
        startPos: spos * BufSampleRate.ir(buf),
        doneAction: 0
    ) * amp * env;
    sig = Pan2.ar(sig, pan);
    sig = sig + (CombN.ar(sig, 4, Rand(0.1, 0.5) * [1, 1.01], Rand(1.0, 3.0)) * Rand(0.0, 1.0));
    sig = LPF.ar(sig, Rand(3200.0, 9000.0));
    Out.ar(out, sig * env2 * 1.5);
}).add;
SynthDef.new(\chirp, {
    arg out, freq = 220, lon = 3, amp = 1, pan = 0, atk = 2, rel = 2, freqOsc = 6;
    var sig, sig2, env, osc, osc2, loopEnv, loopEnv2, linPass;
    osc = LFTri.ar(freqOsc, mul: 0.5, add:0.5);
    osc2 = LFTri.ar(1, pi, mul: 0.5, add:0.5);
    loopEnv = EnvGen.kr(Env.circle([0, 1, 0], [0.01, 0.1, 0.1 * freqOsc]));
    loopEnv2 = EnvGen.kr(Env.circle([1, 1.1, 1], [0.01, 0.1, 0.1 * freqOsc]));
    env = EnvGen.kr(Env.new([0.00001, 1, 0.00001], [atk, rel], curve: 'exp'), doneAction: 2);
    sig = SinOsc.ar([freq, freq + 0.1]) * 0.1;
    sig = sig + (LFTri.ar([freq + 0.1, freq + 0.2] * 1, pi) * 0.02);
    sig = sig * env * amp;
    sig = (sig * loopEnv) * (1 + LFSaw.ar([freq + 1, freq + 1.1] * 1.001, mul: loopEnv * 1) * (1 + WhiteNoise.ar(mul: loopEnv * 0.1)));
    linPass = XLine.kr(200, 6000, atk + rel * 0.5);
    sig = LPF.ar(sig, linPass) * 4;
    sig = Balance2.ar(sig[0], sig[1], pan, 1);
    Out.ar(out, sig);
}).add;
~twinkleCluster = {
    var key = ~key;
    var modif = 0.midiratio * 0.midiratio;
    var note1 = ~toFreq.(key) * [0, 12].midiratio.choose * modif;
    var note2 = ~toFreq.(key) * [24, 36].midiratio.choose * 4.midiratio * modif;
    var note3 = ~toFreq.(key) * [24, 36].midiratio.choose * 7.midiratio * modif;
    var note4 = ~toFreq.(key) * [24, 36].midiratio.choose * 11.midiratio * modif;
    var note5 = ~toFreq.(key) * 24.midiratio * 14.midiratio * modif;
    var mu = [1, 2].wchoose([0.9, 0.1]);
    var delay = 0.125 * 1;
    var max = rrand(1.0, 20);
    var t = Routine({
        play({ PMOsc.ar([note1, note1+1], note1 * mu, Line.ar(0,max,8), 0, XLine.ar(0.1,0.0001, 8, 1, 0, 2)) });
        delay.wait;
        play({ PMOsc.ar([note2, note2+1], note2 * mu, Line.ar(0,max,8), 0, XLine.ar(0.1,0.0001, 8, 1, 0, 2)) });
        delay.wait;
        play({ PMOsc.ar([note3, note3+1], note3 * mu, Line.ar(0,max,8), 0, XLine.ar(0.1,0.0001, 8, 1, 0, 2)) });
        delay.wait;
        play({ PMOsc.ar([note4, note4+1], note3 * mu, Line.ar(0,max,8), 0, XLine.ar(0.1,0.0001, 8, 1, 0, 2)) });
        delay.wait;
        play({ PMOsc.ar([note5, note5+1], note3 * mu, Line.ar(0,max,8), 0, XLine.ar(0.1,0.0001, 8, 1, 0, 2)) });
    }).play;
    4;
};
~chirps = {
    var modif = 0.midiratio * 0.midiratio;
    var key = ~toFreq.(~key) * [36, 48, 48].choose.midiratio * modif;
    var baseOsc = rrand(1, 12);
    var minOsc = baseOsc - 0.05 / 12;
    var maxOsc = baseOsc + 0.05 / 12;
    Synth.new(\chirp, [\freq, key, \amp, 1, \out, 0, \rel, 20, \pan, rrand(-0.5, 0.5), \freqOsc, rrand(minOsc, maxOsc)]);
    Synth.new(\chirp, [\freq, key * 4.midiratio * [1,2].choose, \amp, 1, \out, 0, \rel, 20, \pan, rrand(-0.5, 0.5), \freqOsc, rrand(minOsc, maxOsc)]);
    Synth.new(\chirp, [\freq, key * 11.midiratio * [1,2].choose, \amp, 1, \out, 0, \rel, 20, \pan, rrand(-0.5, 0.5), \freqOsc, rrand(minOsc, maxOsc)]);
    Synth.new(\chirp, [\freq, key * 14.midiratio, \amp, 1, \out, 0, \rel, 20, \pan, rrand(-0.5, 0.5), \freqOsc, rrand(minOsc, maxOsc)]);
    6;
};
)

// -----------------------------------------------------------------------
// Run this block to start the piece
// and go down to line 109 to stop it.
// -----------------------------------------------------------------------
(
{~twinkleClusters = Task {
{~twinkleCluster.(); 4.wait;
}.loop;}.start;

10.wait;

~chirpClusters = Task {
    {
        ~chirps.();
        6.wait;
}.loop;}.start;

10.wait;

~voice = Pbind(
    \instrument, \samplerMono,
    \dur, 15,
    \mix, Pwhite(0.0, 1.0, inf),
    \buf, ~carl,
    \amp, 1
).play;}.fork;
)

// -----------------------------------------------------------------------
// Stop the whole thing gently.
// -----------------------------------------------------------------------
(
~twinkleClusters.stop;
~voice.stop;
~chirpClusters.stop;
)