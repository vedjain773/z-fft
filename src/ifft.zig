const std = @import("std");
const Complex = std.math.complex.Complex;
const assert = std.debug.assert;

const cis = @import("complex.zig").cis;
const getTwiddleTable = @import("complex.zig").getTwiddleTable;
const dft = @import("dft.zig").dft;
const FFTError = @import("fft.zig").FFTError;

pub fn ifft(input: []const Complex(f32), output: []Complex(f32),
    twiddle_table: []Complex(f32)) void {
   
    const input_size = input.len;
    bitReverse(input, output);

    const num_of_stages: usize = std.math.log2(input.len);
    var gap: u32 = 1;

    for (0..num_of_stages) |_| {
        var curr_index: usize = 0;
        while (curr_index + gap < input.len) {
            var j: usize = 0;
            
            while (j < gap) : (j += 1) {
                const even = output[curr_index + j];
                const odd = output[curr_index + j + gap];

                const factor = twiddle_table[j * input_size / (gap * 2)];
                const term_2 = factor.mul(odd);

                output[curr_index + j] = even.add(term_2);
                output[curr_index + j + gap] = even.add(term_2.neg());
            }

            curr_index += gap * 2;
        }

        gap *= 2;
    }
}

fn bitReverse(input: []const Complex(f32), output: []Complex(f32)) void {
    const num_of_bits: usize = std.math.log2(input.len);
    
    for (0..input.len) |i| {
        var index = i;
        var new_index: usize = 0;
        
        for (0..num_of_bits) |_| {
            new_index <<= 1;
            new_index += index % 2;
            index >>= 1;
        }

        output[new_index] = input[i];
    }
}

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
    
    const table = getTwiddleTable(4);
    
    dft(&input, &output_dft);
    ifft(&input, &output_fft, @constCast(&table));

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
    
    const table = getTwiddleTable(4);
    
    dft(&input, &output_dft);
    ifft(&input, &output_fft, @constCast(&table));

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
    
    const table = getTwiddleTable(4);
    
    dft(&input, &output_dft);
    ifft(&input, &output_fft, @constCast(&table));

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
    
    const table = getTwiddleTable(4);
    
    dft(&input, &output_dft);
    ifft(&input, &output_fft, @constCast(&table));

    for (0..input.len) |i| {
        try expectEqualComplex(output_dft[i], output_fft[i], 0.0001);
    } 
}
