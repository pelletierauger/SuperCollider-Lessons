t = TempoClock.new(1).permanent_(true);
(
var run = 0;
~modalTask.stop;
~modalTask = Task {
    var tonic = ~toMidi.("A1");
    var melody = Pseq([0, -2], inf).asStream;
    {
        x.set(\pit, tonic + melody); // Pitch input.
        4.wait;
    }.loop;
}.start(t, quant: [1]);
)



x.set(\bright, 0.455); // Controls the brightness of the resonator.
x.set(\damp, 0.6); // Controls the high frequency damping of the resonator.
x.set(\pos, 0.46); // Position: controls at which point the string/surface is excited.


x.set(\bright, 0.285, \damp, 0.96, \pos, 0.246);
 x.set(\pit, 43);
(
var run = 0;
// x.set(\bright, 0.3, \damp, 0.96, \pos, 0.246);
// x.set(\pit, ~toMidi.("G2"));
~textureTask.stop;
~textureTask = Task {
    var tonic = ~toMidi.("A2");
    var melody = Pwhite(0, 1, inf).asStream;
    {
        // x.set(\bow_level, melody);
        x.set(\geom, melody);
        (1/16).wait;
    }.loop;
}.start(t, quant: [1]);
)
~modalTask.stop;
x.get(\geom, {|i|i.postln});
x.set(\geom, 0.25);
x.set(\contour, 0.5);
x.set(\flow, 0.94);
x.set(\bow_level, 0); // Controls the amplitude of scratching/bowing noise from the BOW generator sent to the resonator.
x.set(\blow_level, 0); 