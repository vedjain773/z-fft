const std = @import("std");
const Complex = std.math.complex.Complex;

pub fn cis(theta: f32) Complex(f32) {
    return Complex(f32) {
        .re = std.math.cos(theta),
        .im = std.math.sin(theta)
    };  
}

pub fn getTwiddleTable(comptime N: usize) [N / 2]Complex(f32) {
    var twiddle_table: [N / 2]Complex(f32) = undefined;

    for (0..N/2) |i| {
        const denom: f32 = @floatFromInt(N);
        const k_f: f32 = @floatFromInt(i);

        twiddle_table[i] = cis(-2 * std.math.pi * k_f / denom);
    } 

    return twiddle_table;
}

pub fn getDynTwiddleTable(allocator: std.mem.Allocator, N: usize) ![]Complex(f32) {
    var twiddle_table = try allocator.alloc(Complex(f32), N / 2); 

    for (0..N/2) |i| {
        const denom: f32 = @floatFromInt(N);
        const k_f: f32 = @floatFromInt(i);

        twiddle_table[i] = cis(-2 * std.math.pi * k_f / denom);
    } 

    return twiddle_table;
}
