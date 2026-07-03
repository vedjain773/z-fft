const std = @import("std");
const random = std.Random;
const Complex = std.math.complex.Complex;

const zig_fft = @import("zig_fft");
const dft = zig_fft.dft;
const fft = zig_fft.fft;

pub fn benchmark(io: std.Io, comptime size: usize) void {
    const curr_seed: u64 = 1;
    var r = random.Xoshiro256.init(curr_seed);

    const input = randomArr(r.random(), size);

    var output_dft: [size] Complex(f32) = undefined;
    
    var start = benchtime(io).toNanoseconds();
    dft(&input, &output_dft);
    var end = benchtime(io).toNanoseconds();

    const dft_time_in_s = (end - start);
   
    var output_fft: [size] Complex(f32) = undefined;
    
    start = benchtime(io).toNanoseconds();
    fft(@constCast(&input), &output_fft, size);
    end = benchtime(io).toNanoseconds();

    const fft_time_in_s = (end - start);
    
    std.debug.print("Size: {}    DFT: {}    FFT: {}\n", .{size, dft_time_in_s, fft_time_in_s});
}

fn benchtime(io: std.Io) std.Io.Timestamp {
    return std.Io.Clock.awake.now(io);
}

fn randomArr(r: std.Random, comptime size: usize) [size]Complex(f32) {
    var result: [size]Complex(f32) = undefined;

    for (0..size) |i| {
        result[i].re = random.float(r, f32);
        result[i].im = random.float(r, f32);
    }

    return result;
}
