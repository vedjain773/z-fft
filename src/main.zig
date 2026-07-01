const std = @import("std");
const Complex = std.math.complex.Complex;
const dft = @import("dft.zig").dft;

const zig_fft = @import("zig_fft");

pub fn main() !void {
    const input = [_]Complex(f32) {
        .{.re = 0, .im = 0},
        .{.re = 0, .im = 0},
        .{.re = 0, .im = 0},
        .{.re = 0, .im = 0}
    };

    var output: [4]Complex(f32) = undefined;

    dft(&input, &output, 4);

    for (output) |ele| {
        std.debug.print("{}, {}\n", .{ele.re, ele.im});
    }
}
