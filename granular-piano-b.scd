
~pianoSamples[10].play
~pianoSamples[10].readChannel

(
~pianoNote = {
    arg num, dyn;
    var makeLookUp = {
        |note, dynamic|
        var octave = floor(note / 12) - 2;
        var degree = note % 12;
        var sampledNote = [1,  1,  1,  1,  2,  2,  2,  3,  3,  3,  3,  3];
        var noteDeltas = [-1, 0,  1,  2, -1,  0,  1, -2, -1,  0,  1,  2];
        var dynamicOffset = dynamic * 23;
        var sampleToGet = octave * 3 + sampledNote[degree] + dynamicOffset;
        var pitch = noteDeltas[degree];
        [sampleToGet, pitch];
    };
    var indices = 3.collect({|j| (20..110).collect({|i| makeLookUp.(i, j)[0]})}).flat;
    var pitches = 3.collect({|j| (20..110).collect({|i| makeLookUp.(i, j)[1]})}).flat;
    var index, rate;
    if (num.isNil, {num = 60}, {num = min(max(20, num), 110)});
    if (dyn.isNil, {dyn = 0}, {dyn = floor(min(max(0, dyn), 2))});
    index = floor(num) - 20 + (dyn * 91);
    rate = (pitches[index] + frac(num)).midiratio;
    [~pianoSamples[indices[index]], rate];
};
)
~pianoNote.(~toMidi.("A2"), 1)[0].play
~pianoNote.(~toMidi.("A2"), 1)[1]
{SinOsc.ar(220*1.midiratio)*0.1!2}.play;
(
{
    var notes = ~toMidi.("A2")+[0,4,7,14+24+12];
    var dyn = 1;
    var bufs = ~pianoNote.(notes, dyn)[0];
    var rates = ~pianoNote.(notes, dyn)[1];
    var sig = PlayBuf.ar(2, bufnum: bufs, rate: rates * BufRateScale.ir(bufs));
    // sig.size.poll;
    sig = DelayN.ar(sig, 1, [0, 0.1, 0.2, 0.3]*0.5);
    sig = sig * [1, 1, 1, 2];
    sig = sig.sum;
    sig = sig * 2;
}.play;

)



(
~grain.set(\fadeTime, 0.1, \gate, 0);
~grain = {
    var trig, trate, dur, clk, pos, pan, sig, bufn;
    var notes = ~toMidi.("A2")+[0,4,7,16+24+12];
    var dyn = 1;
    var bufs = ~pianoNoteMono.(notes, dyn)[0];
    var rates = ~pianoNoteMono.(notes, dyn)[1];

    // bufn = [~chords00monoA.bufnum, ~chords00monoB.bufnum];
    trate = MouseY.kr(8, 220, 1);
    dur = 2 / trate;
    clk = Impulse.kr(trate);
    pos = MouseX.kr(0, BufDur.kr(bufs)) + WhiteNoise.kr(0.1);
    pan = WhiteNoise.kr(1);
    trig = Impulse.kr(~t.tempo * 128);
    dur = 0.009;
    sig = TGrains3.ar(
        numChannels: 1,
        trigger: trig,
        bufnum: bufs,
        rate: rates,
        centerPos: pos,
        dur: 0.25,
        pan: pan,
        amp: 0.1 * Demand.kr(trig, 0, Dseq([1, 0.5], inf)),
        att: dur * 0.1 * 4,
        dec: dur * 0.3 * 4,
        window: ~grainShape.bufnum,
        interp: 4
    );
    sig = sig.sum;
    VadimFilter.ar(sig, 8000, 0, 1) * 0.25;
}.play;
)


(
~pianoNoteMono = {
    arg num, dyn;
    var makeLookUp = {
        |note, dynamic|
        var octave = floor(note / 12) - 2;
        var degree = note % 12;
        var sampledNote = [1,  1,  1,  1,  2,  2,  2,  3,  3,  3,  3,  3];
        var noteDeltas = [-1, 0,  1,  2, -1,  0,  1, -2, -1,  0,  1,  2];
        var dynamicOffset = dynamic * 23;
        var sampleToGet = octave * 3 + sampledNote[degree] + dynamicOffset;
        var pitch = noteDeltas[degree];
        [sampleToGet, pitch];
    };
    var indices = 3.collect({|j| (20..110).collect({|i| makeLookUp.(i, j)[0]})}).flat;
    var pitches = 3.collect({|j| (20..110).collect({|i| makeLookUp.(i, j)[1]})}).flat;
    var index, rate;
    if (num.isNil, {num = 60}, {num = min(max(20, num), 110)});
    if (dyn.isNil, {dyn = 0}, {dyn = floor(min(max(0, dyn), 2))});
    index = floor(num) - 20 + (dyn * 91);
    rate = (pitches[index] + frac(num)).midiratio;
    [~pianoSamplesMono[indices[index]], rate];
};
)
~pianoSamplesMono[10]