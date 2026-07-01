const std = @import("std");
const Complex = std.math.complex.Complex;

pub fn cis(theta: f32) Complex(f32) {
    return Complex(f32) {
        .re = std.math.cos(theta),
        .im = std.math.sin(theta)
    };  
}
