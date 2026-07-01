const std = @import("std");
const Complex = std.math.complex.Complex;
const cis = @import("complex.zig").cis;

pub fn dft(input: []Complex) []Complex {
    const N: usize = input.len;
    var output: [N]Complex = undefined;
    
    for (0..N) |k| {
        for (input, 0..) |element, n| {
            const theta: f32 = 2 * std.math.pi * k * n / N;
            output[k] += element.mul(cis(theta)); 
        }
    }

    return output;
}
