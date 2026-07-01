const std = @import("std");
const Complex = std.math.complex.Complex;
const cis = @import("complex.zig").cis;

pub fn dft(input: []const Complex(f32), output: []Complex(f32), comptime size: usize) void {
    const N: usize = size;
    
    for (0..N) |k| {
        for (input, 0..) |element, n| {
            const N_f: f32 = @floatFromInt(N);
            const n_f: f32 = @floatFromInt(n);
            const k_f: f32 = @floatFromInt(k);

            const theta: f32 = 2 * std.math.pi * k_f * n_f / N_f;
            output[k] = output[k].add(element.mul(cis(theta))); 
        }
    }
}
