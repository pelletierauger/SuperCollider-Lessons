(
{
    var root = ~toMidi.("A3");
    var t = Impulse.kr(2);
    var notes = [2,10,-2,0,0,0,0,0].wrapExtend(16) ++ [2, 0, -5, -2, -2, -2, -2, -2].wrapExtend(16);
    var d = Demand.kr(t, 0, Dseq(notes, inf)).lag(1);
    var lfo = SinOsc.kr(4).unipolar*0.5;
    var sig = LFSaw.ar((root+d).midicps*[0,7].midiratio*(1-(lfo*0.05)));
    sig = VadimFilter.ar(sig, 300 * (1-(lfo*0.5)) + 100,0.5) * 0.1;
    sig = sig + (PinkNoise.ar()*0.003*(lfo+0.5));
    sig ! 2;
}.play;
)