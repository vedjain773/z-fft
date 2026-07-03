const std = @import("std");
const Complex = std.math.complex.Complex;
const assert = std.debug.assert;

const cis = @import("complex.zig").cis;
const dft = @import("dft.zig").dft;

pub fn fft(input: []Complex(f32), output: []Complex(f32), comptime size: usize) void {
    assert(input.len == size);
    assert(output.len == size);
    
    if (size == 1) {
        output[0] = input[0];
    } else {
        const next_size = size / 2; 

        var input_next: [next_size] Complex(f32) = undefined;
        var output_even: [next_size] Complex(f32) = undefined;
        var output_odd: [next_size] Complex(f32) = undefined;
        
        var counter: usize = 0;
        for (0..size) |i| {
            if (i % 2 == 0) {
                input_next[counter] = input[i];
                counter += 1;
            }
        }

        fft(&input_next, &output_even, next_size);

        counter = 0;
        for (0..size) |i| {
            if (i % 2 != 0) {
                input_next[counter] = input[i];
                counter += 1;
            }
        }
        
        fft(&input_next, &output_odd, next_size);

        const size_f: f32 = @floatFromInt(size);
        
        for (0..next_size) |k| {
            const k_f: f32 = @floatFromInt(k);
            const factor = cis(-2 * std.math.pi * k_f / size_f);
            const term_2 = factor.mul(output_odd[k]);

            output[k] = output_even[k].add(term_2);
            output[k + next_size] = output_even[k].add(term_2.neg());
        }
    } 
}

const FFTError = error {
    OutputMismatch,
};

fn expectEqualComplex(a: Complex(f32), b: Complex(f32), epsilon: f32) !void {
    const real: bool = @abs(a.re - b.re) < epsilon;
    const imag: bool = @abs(a.im - b.im) < epsilon;

    const both = real and imag;

    if (!both) return FFTError.OutputMismatch;
}

test "zero signal" {
    const input = [_]Complex(f32) {
        .{.re = 0, .im = 0},
        .{.re = 0, .im = 0},
        .{.re = 0, .im = 0},
        .{.re = 0, .im = 0}
    };

    var output_dft: [4]Complex(f32) = undefined;
    var output_fft: [4]Complex(f32) = undefined;
    
    dft(&input, &output_dft);
    fft(@constCast(&input), &output_fft, 4);

    for (0..input.len) |i| {
        try expectEqualComplex(output_dft[i], output_fft[i], 0.0001);
    } 
}

test "impulse signal" {
    const input = [_]Complex(f32) {
        .{.re = 1, .im = 0},
        .{.re = 0, .im = 0},
        .{.re = 0, .im = 0},
        .{.re = 0, .im = 0}
    };

    var output_dft: [4]Complex(f32) = undefined;
    var output_fft: [4]Complex(f32) = undefined;
    
    dft(&input, &output_dft);
    fft(@constCast(&input), &output_fft, 4);

    for (0..input.len) |i| {
        try expectEqualComplex(output_dft[i], output_fft[i], 0.0001);
    } 
}

test "const signal" {
    const input = [_]Complex(f32) {
        .{.re = 1, .im = 0},
        .{.re = 1, .im = 0},
        .{.re = 1, .im = 0},
        .{.re = 1, .im = 0}
    };

    var output_dft: [4]Complex(f32) = undefined;
    var output_fft: [4]Complex(f32) = undefined;
    
    dft(&input, &output_dft);
    fft(@constCast(&input), &output_fft, 4);

    for (0..input.len) |i| {
        try expectEqualComplex(output_dft[i], output_fft[i], 0.0001);
    } 
}

test "random signal" {
    const input = [_]Complex(f32) {
        .{.re = 1, .im = 0},
        .{.re = 2, .im = -1},
        .{.re = 0, .im = -1},
        .{.re = -1, .im = 2}
    };

    var output_dft: [4]Complex(f32) = undefined;
    var output_fft: [4]Complex(f32) = undefined;
    
    dft(&input, &output_dft);
    fft(@constCast(&input), &output_fft, 4);

    for (0..input.len) |i| {
        try expectEqualComplex(output_dft[i], output_fft[i], 0.0001);
    } 
}
