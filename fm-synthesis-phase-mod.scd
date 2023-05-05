
play({ PMOsc.ar(220, 220, Line.kr(0, 900, 30), 0) * 0.1 !2 });


(
x.free;
x = {
    var l = Line.kr(0, 100000, 30);
    var mod = SinOsc.ar(440) * l;
    SinOsc.ar(440 + mod) * 0.1 ! 2;
}.play
)

(
x.free;
x = {
    var f = 440;
    var x = MouseX.kr();
    var mod = SinOsc.ar(f * 17) * 10000 * x;
    var car = SinOsc.ar(f + mod);
    car * 0.1 ! 2;
}.play;
)

(
x.free;
x = {
    var mod = SinOsc.ar(220) * 256 * 32;
    SinOsc.ar(440 + mod) * 0.1 ! 2;
}.play;
)



(
var freq = 55;
{
    var x = Phaser.ar(freq * 0.5) * 2pi;
    var modIndex = Line.ar(0, 1200, 120);
    var modulator = sin(x);
    var carrier = sin(x + (modulator * modIndex));
    carrier = carrier * MouseX.kr(0,1).round;
    carrier * 0.1!2;
}.play();
{
    var modIndex = Line.ar(0, 1200, 120);
    var modulator = SinOsc.ar(freq);
    var carrier = SinOsc.ar(freq, modulator * modIndex % 2pi);
    carrier = carrier * (1 - MouseX.kr(0,1).round);
    carrier * 0.1!2;
}.play;
)


(
var freq = 55;
{
    var modIndex = Line.ar(0, 1200, 120);
    var modulator = SinOsc.ar(freq);
    var carrier = SinOsc.ar(freq, modulator * modIndex);
    carrier = carrier * (1 - MouseX.kr(0,1).round);
    carrier * 0.1!2;
}.play;
{
    var modIndex = Line.ar(0, 1200, 120);
    var modulator = SinOsc.ar(freq);
    var carrier = SinOsc.ar(freq, modulator * modIndex % 2pi);
    carrier = carrier * MouseX.kr(0,1).round;
    carrier * 0.1!2;
}.play;
)