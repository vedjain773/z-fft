const std = @import("std");
const Complex = std.math.complex.Complex;

const zig_fft = @import("zig_fft");
const ifft = zig_fft.iterativeFFT;

pub fn main() !void {
    const input = [_]Complex(f32) {
        .{.re = 1, .im = 0},
        .{.re = 1, .im = 0},
        .{.re = 1, .im = 0},
        .{.re = 1, .im = 0}
    };

    var output: [4]Complex(f32) = undefined; 
    
    ifft(&input, &output, 4);

    for (0..input.len) |k| {
        std.debug.print("{} + {}i\n", .{output[k].re, output[k].im});
    }
}
