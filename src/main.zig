const std = @import("std");
const Complex = std.math.complex.Complex;
const dft = @import("dft.zig").dft;
const fft = @import("fft.zig").fft;

const zig_fft = @import("zig_fft");

pub fn main() !void {
    var input = [_]Complex(f32) {
        .{.re = 1, .im = 0},
        .{.re = 1, .im = 0},
        .{.re = 1, .im = 0},
        .{.re = 1, .im = 0}
    };

    var output: [4]Complex(f32) = undefined;

    fft(&input, &output, 4);

    for (0..4) |i| {
        std.debug.print("{} + {}i\n", .{output[i].re, output[i].im});
    }  
}
