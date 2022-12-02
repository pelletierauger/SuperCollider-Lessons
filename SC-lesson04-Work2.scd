
// A square wave obtained by adding sine waves

(
f = {
    ({arg i;
        var x = MouseX.kr(0, 60);
        var xa = K2A.ar(x);
        var xx = K2A.ar(i);
        var j = i * 2 + 1;
        var sig = SinOsc.ar(220 * j) * j.reciprocal * 0.5;
        Select.ar(xa > xx, [sig * 0.001, sig]);
    } ! 60).sum // we sum this function 60 times
    !2}; // and we make it a stereo signal
f.freqscope;
s.scope(zoom: 220.reciprocal * 64 * 16 * 1.00915);
)

// A sawtooth wave obtained by adding sine waves.

(
f = {
    ({arg i;
        var x = MouseX.kr(0, 60);
        var xa = K2A.ar(x);
        var xx = K2A.ar(i);
        var j = i * 1 + 1;
        var sig = SinOsc.ar(220 * j) * j.reciprocal * 0.5;
        Select.ar(xa > xx, [sig * 0.001, sig]);
    } ! 60).sum // we sum this function 60 times
    ! 2 }; // and we make it a stereo signal
f.freqscope;
s.scope(zoom: 220.reciprocal * 64 * 16 * 1.00915);
)

// A triangle wave obtained by adding sine waves.

(
f = {
    ({arg i;
        var x = MouseX.kr(0, 15);
        var xa = K2A.ar(x);
        var xx = K2A.ar(i);
        var j = i * 2 + 1;
        var sig = SinOsc.ar(220 * j, pi/2) * 0.7/j.squared;
        Select.ar(xa > xx, [sig * 0.001, sig]);
    } ! 15).sum // we sum this function 15 times
    ! 2 }; // and we make it a stereo signal
f.freqscope;
s.scope(zoom: 220.reciprocal * 64 * 16 * 1.00915);
)





(
f = {
    ({arg i;
        var x = MouseX.kr(0, 30);
        var xa = K2A.ar(x);
        var xx = K2A.ar(i);
        var j = i * 2 + 1;
        var sig = SinOsc.ar(220 * j) * j.reciprocal * 0.5;
        Select.ar(xa > xx, [sig * 0.001, sig]);
    } ! 30).sum // we sum this function 30 times
    !2}; // and we make it a stereo signal
f.plot;
)


(
f = {
    ({arg i;
        var x = MouseX.kr(0, 30);
        var xa = K2A.ar(x);
        var xx = K2A.ar(i);
        var j = i * 2 + 1;
        var sig = SinOsc.ar(220 * j) * j.reciprocal * 0.5;
        Select.ar(xa > xx, [sig * 0.001, sig]);
    } ! 30).sum // we sum this function 30 times
    !2}; // and we make it a stereo signal
f.play;
)
s.scope(zoom: 1.4251)
FreqScope.new()
s.scope(zoom: 220.reciprocal * 64 * 16 * 1.00915)

1.reciprocal