~t = TempoClock.new(3.16 * -2.midiratio).permanent_(true);

(
var y, h, size;
size = s.sampleRate * 0.2;
y = Signal.hanningWindow(size * 2);
h = Array.fill(size, {|i| y[i]});
~grainShape = Buffer.alloc(s, size, 1);
~grainShape.loadCollection(h);
)
~path = "/Users/guillaumepelletier/Desktop/Dropbox/Art/p5/SuperCollider-Lessons/classical-guitar-chord.wav"

(
~chord = [
    Buffer.readChannel(s, ~path, channels: 0),
    Buffer.readChannel(s, ~path, channels: 1),
    ];
)
~chord[1].play

(
~grain.set(\fadeTime, 0.1, \gate, 0);
~grain = {
    var trig, trate, dur, clk, pos, pan, sig, bufn;
    bufn = [~chord[0].bufnum, ~chord[1].bufnum];
    trate = MouseY.kr(8, 220, 1);
    dur = 2 / trate;
    clk = Impulse.kr(trate);
    pos = MouseX.kr(0, BufDur.kr(bufn)) + WhiteNoise.kr(0.1);
    pan = WhiteNoise.kr(1);
    trig = Impulse.kr(~t.tempo * 128 * 0.5);
    trig = Dust.kr(MouseY.kr(0, 500));
    dur = 0.009;
    sig = TGrains3.ar(
        numChannels: 1,
        trigger: trig,
        bufnum: bufn,
        rate: Demand.kr(trig, 0, Dseq([1, 0.5], inf)),
        rate: 0.5,
        centerPos: pos,
        dur: 0.25,
        pan: 0,
        amp: 0.1 * Demand.kr(trig, 0, Dseq([1, 0.5], inf)),
        att: dur * 0.5,
        dec: dur * 0.5,
        window: ~grainShape.bufnum,
        interp: 4
    );
    sig = VadimFilter.ar(sig, 300, 0, 5);
    sig = VadimFilter.ar(sig, 12000, 0, 1);
    // sig = sig[0]!2;
    sig * 0.5;
}.play;
)