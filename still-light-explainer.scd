// --------------------------------------------------------------------
// Opening riff, first version, wrongly in A
// --------------------------------------------------------------------

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

// --------------------------------------------------------------------
// Opening riff, second version, in D
// --------------------------------------------------------------------

(
{
    var root = ~toMidi.("D4");
    var t = Impulse.kr(2);
    var notes = [ 4, 12, 0, 2, 2, 2, 2, 2 ].wrapExtend(16)
    ++[ 4, 2, -3, 0, 0, 0, 0, 0 ].wrapExtend(16);
    var d = Demand.kr(t, 0, Dseq(notes, inf)).lag(1);
    var lfo = SinOsc.kr(4).unipolar*0.5;
    var sig = LFSaw.ar((root+d).midicps*[-5,0].midiratio*(1-(lfo*0.05)));
    sig = VadimFilter.ar(sig, 300 * (1-(lfo*0.5)) + 100,0.5) * 0.1;
    sig = sig + (PinkNoise.ar()*0.003*(lfo+0.5));
    sig ! 2;
}.play;
)

// The salient features of this riff:
// The harmony that moves in parallel fifths.
// The D major harmony.
// The heavy portamento (pitch slide), and pitch vibrato.

// --------------------------------------------------------------------
// New SC concepts that we haven't introduced yet.
// --------------------------------------------------------------------
// Triggers with the Impulse UGen.
// Demand rate UGens.
// Lag.

// --------------------------------------------------------------------
// Triggers
// --------------------------------------------------------------------

{Impulse.ar(1) * 0.1 ! 2}.play;
{Impulse.ar(220)}.plot(1);

// --------------------------------------------------------------------
// Demand rate UGens.
// --------------------------------------------------------------------

(
{
    var trig = Impulse.kr(1);
    var dem = Demand.kr(trig, 0, Dseq([0, 3, 7].midiratio, inf));
    LFTri.ar(440 * dem) * 0.1 ! 2;
}.play;
)

// --------------------------------------------------------------------
// Lag.
// --------------------------------------------------------------------

(
{EnvGen.kr(Env([0,1,0.5,0.5, 0], [0.125, 0.25, 0.5,0.5]))}.plot(2);
{EnvGen.kr(Env([0,1,0], [0.125, 0.25])).lag(1)}.plot(1);
)

{var e=EnvGen.kr(Env([0,1,0.5,0.5,0], [0.125,0.25,0.5,0.5]));[e,e.lag(0.5)]}.plot(2);

// --------------------------------------------------------------------
// Using lag to create portamento (or glide or slide), on a series of notes.
// --------------------------------------------------------------------

(
{
    var root = ~toMidi.("D4");
    var t = Impulse.kr(2*24);
    var notes = [ 4, 12, 0, 2, 2, 2, 2, 2 ].wrapExtend(16)
    ++[ 4, 2, -3, 0, 0, 0, 0, 0 ].wrapExtend(16);
    var d = Demand.kr(t, 0, Dseq(notes, inf));
    [d, d.lag(1/24)];
}.plot(1);
)

// Using lag to glide from one note to another.
(
{
    var trig = Impulse.kr(1);
    var dem = Demand.kr(trig, 0, Dseq([0, 3, 7].midiratio, inf));
    LFTri.ar(440 * dem.lag(0.5)) * 0.1 ! 2;
}.play;
)

// Another demonstration, faster, with lag.
(
{
    var trig = Impulse.kr(8);
    var dem = Demand.kr(trig, 0, Dseq([0, 4, 7, 11, 9, 5, 2].midiratio, inf));
    LFTri.ar(440 * dem.lag(0.125)) * 0.1 ! 2;
}.play;
)

// The same thing without lag is a completely different musical idea.
(
{
    var trig = Impulse.kr(8);
    var dem = Demand.kr(trig, 0, Dseq([0, 4, 7, 11, 9, 5, 2].midiratio, inf));
    LFTri.ar(440 * dem) * 0.1 ! 2;
}.play;
)

// --------------------------------------------------------------------
// Closing upward arpeggio.
// --------------------------------------------------------------------

(
{
    var root = ~toMidi.("D3");
    var t = Impulse.kr(5);
    var notes = [0, 2, 7, 9, 12, 14, 19, 21];
    // var notes = Scale.major.degrees++(Scale.major.degrees+12);
    var d = Demand.kr(t, 0, Dseq(notes, inf)).lag(0.2);
    var e = EnvGen.kr(Env([0.001,1,0.001], [0.15, 0.15], 'exp'), t);
    var lfo = SinOsc.kr(4).unipolar*0.5;
    var sig = LFSaw.ar((root+d).midicps*(1-(lfo*0.05)));
    sig = VadimFilter.ar(sig,1600 * (1-(lfo*0.5)) * e + 100,0.125) * 0.1;
    // sig = sig + (PinkNoise.ar()*0.003*(lfo+0.5));
    GVerb.ar(sig, damping: 0.1)*0.2+(sig);
}.play;
)

// --------------------------------------------------------------------
// Some notes on the harmony of the closing upward arpeggio.
// --------------------------------------------------------------------

// The arpeggio is very structured and solid,
// based on a series of fifths and octaves.

// The notes
[0, 2, 7, 9, 12, 14, 19, 21];
// Another way to write down the notes, which emphasizes the structure.
[0, 2].wrapExtend(8) + [0,7,12,19].stutter(2);

// Is it in minor or major?
(y.free;y={LFTri.ar(~toFreq.("D4")*(3).midiratio)*0.05!2}.play); // Minor third
(y.free;y={LFTri.ar(~toFreq.("D4")*(4).midiratio)*0.05!2}.play); // Major third


// --------------------------------------------------------------------
// Closing upward arpeggio, with chorus effect.
// --------------------------------------------------------------------

(
{
    var root = ~toMidi.("D3");
    var t = Impulse.kr(5);
    var notes = [0, 2, 7, 9, 12, 14, 19, 21];
    // var notes = Scale.major.degrees++(Scale.major.degrees+12);
    var d = Demand.kr(t, 0, Dseq(notes, inf)).lag(0.1);
    var e = EnvGen.kr(Env([0.001,1,0.001], [0.15, 0.15], 'exp'), t);
    var lfo = SinOsc.kr(4).unipolar*0.5;
    var sig = LFSaw.ar((root+d).midicps*(1-(lfo*0.05))*((0..5)/15).midiratio,(0..5)).sum;
    sig = VadimFilter.ar(sig, 600 * (1-(lfo*0.5)) * e + 100,0.125) * 0.1;
    // sig = sig + (PinkNoise.ar()*0.003*(lfo+0.5));
    GVerb.ar(sig, damping: 0.1)*0.2+(sig);
}.play;
)

// --------------------------------------------------------------------
// Closing upward arpeggio, with ascending octaves.
// --------------------------------------------------------------------

(
{
    var root = ~toMidi.("D3");
    var t = Impulse.kr(5);
    var notes = [0, 2, 7, 9, 12, 14, 19, 21];
    // var notes = Scale.major.degrees++(Scale.major.degrees+12);
    var d = Demand.kr(t, 0, Dseq(notes, inf)).lag(0.1);
    var e = EnvGen.kr(Env([0.001,1,0.001], [0.15, 0.15], 'exp'), t);
    var lfo = SinOsc.kr(4).unipolar*0.5;
    var sig = LFSaw.ar((root+d).midicps*(1-(lfo*0.05))*((0..5)/15).midiratio,(0..3)/3).sum;
    sig = VadimFilter.ar(sig, 600 * (1-(lfo*0.5)) * e + 10,0.125) * 0.1;
    // sig = sig + (PinkNoise.ar()*0.003*(lfo+0.5));
    GVerb.ar(sig, damping: 0.1)*0.2+(sig);
}.play;
{
    var root = ~toMidi.("D3")+12;
    var t = Impulse.kr(5);
    var notes = [0, 2, 7, 9, 12, 14, 19, 21];
    // var notes = Scale.major.degrees++(Scale.major.degrees+12);
    var d = Demand.kr(t, 0, Dseq(notes, inf)).lag(0.1);
    var e = EnvGen.kr(Env([0.001,1,0.001], [0.15, 0.15], 'exp'), t);
    var lfo = SinOsc.kr(4).unipolar*0.5;
    var sig = LFSaw.ar((root+d).midicps*(1-(lfo*0.05))*((0..5)/15).midiratio,(0..3)/3).sum;
    sig = VadimFilter.ar(sig, 600 * (1-(lfo*0.5)) * e + 10,0.125) * 0.1;
    // sig = sig + (PinkNoise.ar()*0.003*(lfo+0.5));
    GVerb.ar(sig, damping: 0.1)*0.2+(sig)*Line.kr(0,1,30)*2;
}.play;
)

// --------------------------------------------------------------------
// Variations
// --------------------------------------------------------------------

(
{
    var root = ~toMidi.("D3");
    var t = Impulse.kr(5);
    var notes = [0, 3].wrapExtend(8) + [0,7,12,19].stutter(2)+([0,-5].stutter(16));
    // var notes = Scale.major.degrees++(Scale.major.degrees+12);
    var d = Demand.kr(t, 0, Dseq(notes, inf)).lag(0.1);
    var e = EnvGen.kr(Env([0.001,1,0.001], [0.15, 0.15], 'exp'), t);
    var lfo = SinOsc.kr(4).unipolar*0.5;
    var sig = LFSaw.ar((root+d).midicps*(1-(lfo*0.05))*((0..5)/15).midiratio,(0..5)).sum;
    sig = VadimFilter.ar(sig, 600 * (1-(lfo*0.5)) * e + 100,0.125) * 0.1;
    // sig = sig + (PinkNoise.ar()*0.003*(lfo+0.5));
    GVerb.ar(sig, damping: 0.1)*0.2+(sig);
}.play;
)

(y.free;y={LFTri.ar(~toFreq.("D4")*(2).midiratio)*0.05!2}.play); // Minor third


(
{
    var root = ~toMidi.("D3");
    var t = Impulse.kr(5);
    var notes = [0,3,7,8].wrapExtend(8) + [0,7,12,19].stutter(4).reverse+([0,-2].stutter(16));
    // var notes = Scale.major.degrees++(Scale.major.degrees+12);
    var d = Demand.kr(t, 0, Dseq(notes, inf)).lag(0.1);
    var e = EnvGen.kr(Env([0.001,1,0.001], [0.05, 0.15], 'exp'), t);
    var lfo = SinOsc.kr(8).unipolar*0.5;
    var sig = LFSaw.ar((root+d).midicps*(1-(lfo*0.1))*((0..5)/15).midiratio,(0..5)).sum;
    sig = VadimFilter.ar(sig, 1600 * (1-(lfo*0.5)) * e + 10,0.125) * 0.1;
    // sig = sig + (PinkNoise.ar()*0.003*(lfo+0.5));
    VadimFilter.ar(GVerb.ar(sig, damping: 0.1),2500,0,1)*0.2+(sig);
}.play;
)