const std = @import("std");
const Complex = std.math.complex.Complex;
const assert = std.debug.assert;

const cis = @import("complex.zig").cis;

pub fn dft(input: []const Complex(f32), output: []Complex(f32)) void {
    assert(input.len == output.len);

    const N: usize = input.len;
    const N_f: f32 = @floatFromInt(N);

    for (0..N) |i| {
        output[i] = .{.re = 0.00, .im = 0.00};
    }
    
    for (0..N) |k| {
        const k_f: f32 = @floatFromInt(k);
        
        for (input, 0..) |element, n| {
            const n_f: f32 = @floatFromInt(n);

            const theta: f32 = -2 * std.math.pi * k_f * n_f / N_f;
            output[k] = output[k].add(element.mul(cis(theta))); 
        }
    }
}

const DFTError = error {
    IncorrectOutput
};

fn expectEqualComplex(a: Complex(f32), b: Complex(f32), epsilon: f32) !void {
    const real: bool = @abs(a.re - b.re) < epsilon;
    const imag: bool = @abs(a.im - b.im) < epsilon;

    const both = real and imag;

    if (!both) return DFTError.IncorrectOutput;
}

test "zero signal" {
    const input = [_]Complex(f32) {
        .{.re = 0, .im = 0},
        .{.re = 0, .im = 0},
        .{.re = 0, .im = 0},
        .{.re = 0, .im = 0}
    };

    var output: [4]Complex(f32) = undefined;
   
    dft(&input, &output);

    const expected = [_]Complex(f32) {
        .{.re = 0, .im = 0},
        .{.re = 0, .im = 0},
        .{.re = 0, .im = 0},
        .{.re = 0, .im = 0}
    };

    for (0..input.len) |i| {
        try expectEqualComplex(output[i], expected[i], 0.0001);
    } 
}

test "impulse signal" {
    const input = [_]Complex(f32) {
        .{.re = 1, .im = 0},
        .{.re = 0, .im = 0},
        .{.re = 0, .im = 0},
        .{.re = 0, .im = 0}
    };

    var output: [4]Complex(f32) = undefined;
   
    dft(&input, &output);

    const expected = [_]Complex(f32) {
        .{.re = 1, .im = 0},
        .{.re = 1, .im = 0},
        .{.re = 1, .im = 0},
        .{.re = 1, .im = 0}
    };

    for (0..input.len) |i| {
        try expectEqualComplex(output[i], expected[i], 0.0001);
    } 
}

test "const signal" {
    const input = [_]Complex(f32) {
        .{.re = 1, .im = 0},
        .{.re = 1, .im = 0},
        .{.re = 1, .im = 0},
        .{.re = 1, .im = 0}
    };

    var output: [4]Complex(f32) = undefined;
   
    dft(&input, &output);

    const expected = [_]Complex(f32) {
        .{.re = 4, .im = 0},
        .{.re = 0, .im = 0},
        .{.re = 0, .im = 0},
        .{.re = 0, .im = 0}
    };

    for (0..input.len) |i| {
        try expectEqualComplex(output[i], expected[i], 0.0001);
    } 
}

test "random signal" {
    const input = [_]Complex(f32) {
        .{.re = 1, .im = 0},
        .{.re = 2, .im = -1},
        .{.re = 0, .im = -1},
        .{.re = -1, .im = 2}
    };

    var output: [4]Complex(f32) = undefined;
   
    dft(&input, &output);

    const expected = [_]Complex(f32) {
        .{.re = 2, .im = 0},
        .{.re = -2, .im = -2},
        .{.re = 0, .im = -2},
        .{.re = 4, .im = 4}
    };

    for (0..input.len) |i| {
        try expectEqualComplex(output[i], expected[i], 0.0001);
    } 
}
