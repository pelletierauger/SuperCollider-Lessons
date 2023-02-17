(
var a = Pwrand([0, 1], [0.5, 0.5], inf).asStream;
var b = Pwrand([0, 1], [0.1, 0.9], inf).asStream;
var c = Pwrand([0, 1], [0.9, 0.1], inf).asStream;
~kickSeq = [1, 0, 0, 0, 1, 0, 0, 0];
~snarSeq = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0];
~hatsSeq = [1, 0, 1, 0, 1, 0, 1, 0];
)

~snarSeq = [1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0];


(
var stepIndex = Pseq((0..11), inf).asStream;
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
