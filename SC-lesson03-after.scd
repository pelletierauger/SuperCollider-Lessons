// ░░░░▒▒▒▒▒▒▓▓▓▓█████        SuperCollider Course        █████▓▓▓▓▒▒▒▒▒▒░░░░
// ░░░░▒▒▒▒▒▒▓▓▓▓█████      Fall 2022 - Winter 2023       █████▓▓▓▓▒▒▒▒▒▒░░░░
//
//          ███████▓▒░
//         ██▓▒░  ██▓▒░                                              ███▓▒░ █████▓▒░
//         █▓▒░     ███▓▒░  █▓▒░               █▓▒░░      ████▓▒░░      █▓▒███▓▒░ ██▓▒░
//         █▓▒░░           █▓▒░░   █▓▒░  ████████▓▒░░    █▓▒░  ██▓▒░    ████▓▒░
//           █▓▒░░░░       █▓▒░    █▓▒░   █▓▒░    █▓▒░   █▓▒░  █▓▒░     ██▓▒░
//              █▓▒░░░     █▓▒░    █▓▒░   █▓▒░    █▓▒░░  █▓▒░███▓▒░     █▓▒░
//                 █▓▒░   █▓▒░     █▓▒░   █▓▒░     █▓▒░   █▓▒░          █▓▒░
//       ███▓▒░    ██▓▒░  █▓▒░    ██▓▒░   ██▓▒░   █▓▒░    █▓▒░  ██▓▒░    █▓▒░
//          ███▓▒░██▓▒░   █▓▒░  ████▓▒░   ████▓▒███▓▒░    ██▓▒░██▓▒░    █▓▒░
//             ███▓▒░      ██████▓▒█      █▓▒░ ██▓▒░       ████▓▒░      █▓▒░
//                                        █▓▒░
//                                       █▓▒░                            █▓▒░
//                                                           ██▓▒░        █▓▒░   █▓▒░░░░░░     █▓▒░ ███████▓▒░
//              ██████▓▒░░░                █▓▒░    █▓▒░                   █▓▒░   █▓▒░  █▓▒░    █▓▒██▓▒░   █▓▒░
//           █▓▒░░    █▓▒░░░               █▓▒░    █▓▒░               ██▓██▓▒░   █▓▒░  █▓▒░     ███▓▒░
//          █▓▒░        █▓▒░░  █▓▒█▓▒░░     █▓▒░   █▓▒░     ███▓▒░   █▓▒░ █▓▒░░  █▓▒░███▓▒░     █▓▒░
//         █▓▒░               █▓▒░  █▓▒░    █▓▒░   █▓▒░      ██▓▒░  █▓▒░   █▓▒░  █▓▒░           █▓▒░
//        █▓▒░               █▓▒░░  █▓▒░   █▓▒░    █▓▒░       █▓▒░  █▓▒░░  █▓▒░  █▓▒░           █▓▒░
//        ██▓▒░      █▓▒░    █▓▒░   █▓▒░   █▓▒░    █▓▒░       █▓▒░   █▓▒░░██▓▒░  █▓▒░   █▓▒░    █▓▒░
//         ███▓▒░  ███▓▒░     ██████▓▒░    █▓▒░     █▓▒░     █▓▒░░    █▓▒░░░░░   ██▓▒░ █▓▒░      █▓▒░
//            █████▓▒░                     █▓▒░     █▓▒░     █▓▒░                 ██████▓▒░      █▓▒░
//
// ░░░░▒▒▒▒▒▒▓▓▓▓█████    SuperCollider As A Mechanism    █████▓▓▓▓▒▒▒▒▒▒░░░░
// ░░░░▒▒▒▒▒▒▓▓▓▓█████     To Encounter New Realities     █████▓▓▓▓▒▒▒▒▒▒░░░░
// ░░░░▒▒▒▒▒▒▓▓▓▓█████     and Expand The Mind Beyond     █████▓▓▓▓▒▒▒▒▒▒░░░░
// ░░░░▒▒▒▒▒▒▓▓▓▓█████        All Known Boundaries.       █████▓▓▓▓▒▒▒▒▒▒░░░░




{SinOsc.ar(220) * 0.1!2}.play;
{SinOsc.ar(220 + 100) * 0.1!2}.play;
{SinOsc.ar(220 + 110) * 0.1!2}.play;
x = {SinOsc.ar(220) * 0.1!2}.play;
x.free;

(
{
   var whitenoise = WhiteNoise.ar() * 0.1;
   var signal = SinOsc.ar(220) * 0.1!2;
   whitenoise = whitenoise * 0.1;
   signal + noise;
}.play;
)

// A very basic SynthDef
(
SynthDef.new(\tri, {
    arg freq = 54, atk = 0.1, dec = 0.1, sustime = 0.8, suslevel = 0.5, rel = 2, amp = 1;
    var env = Env.new([0, 1, suslevel, suslevel, 0], [atk, dec, sustime, rel]);
    var envSig = EnvGen.ar(env, doneAction: 2);
    var sig = LFTri.ar(freq.midicps) * envSig * amp;
    Out.ar(0, sig!2);
}).add;
)


// Plotting the envelope used in the SynthDef.
(
var freq = 54, atk = 0.1, dec = 0.1, sustime = 0.8, suslevel = 0.5, rel = 2, amp = 1;
var env = Env.new([0.0001, 1, suslevel, suslevel, 0.0001], [atk, dec, sustime, rel]);
env.plot;
)


// Calling the creation of one instance of our SynthDef.
Synth.new(\tri);


// Calling the creation of one instance of our SynthDef, using parameters.
Synth.new(\tri, [\freq, ~toMidi.("Gb3") + 14, \amp, 0.1]);


// Creating very simple patterns.
p = Pseq([0, 1, Prand([0, 1, 2, 3, 4, 5], 2)], inf).asStream;
p.next;

p = (Pwhite(0.0, 1.0, inf) * Prand([0, 1, 2, 3, 4, 5], inf)).asStream;
p.next;

p = Prand([0, 1, 2, 3, 4, 5], inf).asStream;
p.next;

// Using a Pbind to create a sequence of Synths with patterns.
(
~melody.stop;
~melody = Pbind(
    \instrument, \tri,
    \dur, 1,
    \freq, ~toMidi.("Gb3") + Pseq([0, 4, 7, 11, 9, 7], 1),
    \atk, 0.1,
    \dec, 0.1,
    \sustime, 0.1,
    \suslevel, 0.5,
    \rel, 1,
    \amp, 0.5
).play();
)

p = Pseq([0, 4, 7, 11, 9, 7], 1).asStream;
p.next;

// Extra *** A more musical example building on what we have done so far. ***

//                                                        ██▓▒░
//                                                     ███▒░░                             ████▓▒░░░
//                                                   ████▓▒░                            ██▓▒░░░░░▓▒░░
//                                        ████▓▒░  █████▓▒░                            ██▓▒░░    █▓▒░░
//        ██████▓▒░░     ███▓▒░░        ██▓▒░     ██████▓▒░                           ███▓▒░       █▓▒░
//      ██████▒░ █▓▒░░  ██████▓▒░     █▓▒░    ████████████▓█▓██▓▒░ ████▓▒░  ██▓▒░                  █▓▒░░
//     █████▓▒░    █▓▒░░ █▓▒░██▓▒░  ███▓▒░        █████▓▒░           ██▓████▓▒█▓████▓▒░           ███▓▒░
//    ██████▓▒░   ████▓▒░     ██▓▒░█▓▒░           █████▓▒░            █████▓▒░    ██▓▒░   ███████▓▒░█▓▒░
//    █████▓██▓████████▓▒░     ██▓▒░░             █████▓▒░            ████▒░            ██████▓▒░████▓▒░
//    █████▓▒░░               ████▓▒░             █████▓▒░    ██▓▒░   ████▒░           █████▓▒░  ████▓▒░
//     █████▓▒░             █▒██  ██▒░    █▓▒░     █████▒░   ██▓▒░    ████▒░          █████▒░     ████▓▒░▒░
//      ██████▓▒██▓▒░░    ██▒░     ████████▓▒░      ████▓▒░ ██▓▒░     ████▒░          ████▓▒░     █████▒░░░
//        ██████▓▒░    █▓████▓▒░      ███▓▒░           █▓███▓▒░       ████▒░          ████████░░  ██████▒░
//                                                      ████▓▒░    ████████▓▒░░░          ██████▓▒     ██▓▒░░


// Adding Pan and LFO to our original SynthDef.
(
SynthDef.new(\tri, {
    arg freq = 54, atk = 0.1, dec = 0.1, sustime = 0.8, suslevel = 0.5, rel = 2,
    amp = 1, pan = 0, lfoFreq = 3;
    var env = Env.new([0, 1, suslevel, suslevel, 0], [atk, dec, sustime, rel]);
    var envSig = EnvGen.ar(env, doneAction: 2);
    var lfo = SinOsc.kr(lfoFreq).unipolar;
    var sig = LFTri.ar(freq.midicps) * envSig * amp * lfo;
    sig = Pan2.ar(sig, pan);
    Out.ar(0, sig);
}).add;
)


// Using the scale object to get different scales.
a = Scale.lydian
a = Scale.lydian.degrees


// Using a Pbind to create a sequence of Synths with patterns.
// We are now using \dur to create different time durations between notes,
// the lydian scale in the \freq argument,
// a pan value between -1.0 and 1.0,
// and a ramdom value for the frequency (speed) of the LFO
// The values for the envelope (atk, dec, sustime, rel) have also been tweaked.
(
~melody.stop;
~melody = Pbind(
    \instrument, \tri,
    \dur, Prand([0.25, 0.5, 0.75, 1, 1.5], inf),
    \freq, ~toMidi.("Gb3") + Prand(Scale.lydian.degrees, inf) + Prand([-12, 0, 12], inf),
    \atk, 0.5,
    \dec, 0.5,
    \sustime, 0.1,
    \suslevel, 0.5,
    \rel, 3,
    \amp, 0.5,
    \pan, Pwhite(-1.0, 1.0, inf),
    \lfoFreq, Prand([1, 2, 3, 4, 6, 8, 9, 12, 16] / 3, inf)
).play();
)
