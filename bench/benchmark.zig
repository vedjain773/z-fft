const std = @import("std");
const random = std.Random;
const Complex = std.math.complex.Complex;

const zig_fft = @import("zig_fft");
const dft = zig_fft.dft;
const rfft = zig_fft.rFFTconf;
const ifft = zig_fft.iFFTconf;

pub fn benchmark(io: std.Io, comptime size: usize, comptime num_bench_marks: u32) !void {
    const curr_seed: u64 = 5768;
    var r = random.Xoshiro256.init(curr_seed);
   
    var config = try zig_fft.ZConfig.init(std.heap.smp_allocator, size);
    defer config.deinit();

    var output_dft: [size] Complex(f32) = undefined;
    var output_fft: [size] Complex(f32) = undefined;
    var output_ifft: [size] Complex(f32) = undefined;

    var dft_time_in_s: i64 = 0;
    var fft_time_in_s: i64 = 0;
    var ifft_time_in_s: i64 = 0;
    
    for (0..num_bench_marks) |_| {
        const input = randomArr(r.random(), size);

        var start = benchtime(io).toMicroseconds();
        dft(&input, &output_dft);
        std.mem.doNotOptimizeAway(&output_dft);
        var end = benchtime(io).toMicroseconds();
        
        dft_time_in_s += (start - end);

        start = benchtime(io).toMicroseconds();
        rfft(@constCast(&input), &output_fft, &config, size);
        std.mem.doNotOptimizeAway(&output_fft);
        end = benchtime(io).toMicroseconds();

        fft_time_in_s += (start - end);

        start = benchtime(io).toMicroseconds();
        ifft(&input, &output_ifft, &config);
        std.mem.doNotOptimizeAway(&output_ifft);
        end = benchtime(io).toMicroseconds();

        ifft_time_in_s += (start - end);
    }

    dft_time_in_s = -1 * @divTrunc(dft_time_in_s, num_bench_marks);
    fft_time_in_s = -1 * @divTrunc(fft_time_in_s, num_bench_marks);
    ifft_time_in_s = -1 * @divTrunc(ifft_time_in_s, num_bench_marks);
   
    std.debug.print("Size: {}    DFT: {}    FFT: {}    IFFT: {}\n",
        .{size, dft_time_in_s, fft_time_in_s, ifft_time_in_s});
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
