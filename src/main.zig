const std = @import("std");
const Complex = std.math.complex.Complex;

const zig_fft = @import("zig_fft");

pub fn main() !void {
    //const input = [_]Complex(f32) {
    //    .{.re = 1, .im = 0},
    //    .{.re = 1, .im = 0},
    //    .{.re = 1, .im = 0},
    //    .{.re = 1, .im = 0}
    //};

    //var output: [4]Complex(f32) = undefined; 
    
    //zig_fft.recursiveFFT(@constCast(&input), &output, 4);

    //for (0..input.len) |k| {
    //    std.debug.print("{} + {}i\n", .{output[k].re, output[k].im});
    //}
    
    const table = zig_fft.getTwiddleTable(4);
    var config = try zig_fft.ZConfig.init(std.heap.smp_allocator, 4);
    defer config.deinit();

    for (0..2) |i| {
        const real = config.twiddle_table[i].re;
        const imag = config.twiddle_table[i].im;

        std.debug.print("{} + {}i\n", .{real, imag});
    }

    for (0..2) |i| {
        std.debug.print("{} + {}i\n", .{table[i].re, table[i].im});
    } 
}
