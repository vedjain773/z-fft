const std = @import("std");
const Complex = std.math.complex.Complex;

const zig_fft = @import("z-fft");

pub fn main() !void {
    var config = try zig_fft.ZConfig.init(std.heap.smp_allocator, 4);
    defer config.deinit();

    const input = [_]Complex(f32) {
        .{.re = 1, .im = 0},
        .{.re = 1, .im = 0},
        .{.re = 1, .im = 0},
        .{.re = 1, .im = 0}
    };

    var output: [4]Complex(f32) = undefined; 
   
    zig_fft.iFFTconf(&input, &output, &config);

    for (0..input.len) |k| {
        std.debug.print("{} + {}i\n", .{output[k].re, output[k].im});
    }
    
    var inv_output: [4]Complex(f32) = undefined; 

    zig_fft.invIterFFT(&output, &inv_output, 4);

    for (0..input.len) |k| {
        std.debug.print("{} + {}i\n", .{inv_output[k].re, inv_output[k].im});
    }
}
