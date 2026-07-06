const std = @import("std");

const zig_fft = @import("zig_fft");
const benchmark = @import("benchmark.zig").benchmark;
const benchTest = @import("benchmark.zig").benchTest;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    comptime var size = 8;

    std.debug.print("{s:<8} {s:<12} {s:<12} {s:<12}\n",
        .{"Size", "DFT", "FFT", "IFFT"});
    
    inline while (size <= 4096) : (size *= 2) {
        try benchmark(io, size, 10);
    } 

    try benchTest(io, 1024, 10000);
}
