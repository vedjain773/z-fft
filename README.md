# z-fft

A fast, lightweight Fast Fourier Transform (FFT) library written in Zig.

The library provides efficient implementations of the Discrete Fourier Transform (DFT) and Fast Fourier Transform (FFT), with an emphasis on simplicity.

> **Status:** Under active development.

## Features

* Radix-2 Cooley–Tukey FFT
* Recursive and iterative implementations
* Forward and inverse FFT (FFT/IFFT)
* Optional FFT planning and precomputed twiddle tables
* Pure Zig implementation with no runtime dependencies
* Benchmarking utilities for performance evaluation

## Installation

Add the package to your project:

```sh
zig fetch --save git+https://github.com/vedjain773/z-fft
```

Then add it as a dependency in your `build.zig`.

## Usage

```zig
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
```

Inverse transforms 
```zig
var inv_output: [4]Complex(f32) = undefined; 

zig_fft.invIterFFT(&output, &inv_output, 4);

for (0..input.len) |k| {
    std.debug.print("{} + {}i\n", .{inv_output[k].re, inv_output[k].im});
}
```

## Design

The library separates the FFT algorithm from optional planning infrastructure.

For one-off transforms, the library can compute twiddle factors internally.

For repeated transforms of the same size, users can create reusable plans that cache twiddle tables and other implementation-specific data to improve performance.

Both recursive and iterative implementations share the same public API whenever possible.

## Benchmarks

Benchmarking utilities are included to compare:

* FFT vs. naïve DFT
* Recursive vs. iterative FFT
* Different transform sizes

Benchmarks can be run with:

```sh
zig build benchmark
```

![benchmark](assets/benchmark.svg)

The benchmarks were run on:
- CPU: AMD A6
- Zig: 0.17 (dev) (ReleaseFast)
- OS: Ubuntu 22.04

Additionally, z-fft was able to compute the Fast Fourier Transform of 10,000
1024-pt buffers in 0.18s

## Building

Build the library:

```sh
zig build
```

Run tests:

```sh
zig build test
```

Run benchmarks:

```sh
zig build benchmark
```
