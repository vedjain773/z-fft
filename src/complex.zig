const std = @import("std");
const Complex = std.math.complex.Complex;

pub fn cis(theta: f32) Complex {
    return Complex {
        .re = std.math.cos(theta),
        .im = std.math.sin(theta)
    };  
}
