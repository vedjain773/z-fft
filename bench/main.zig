const std = @import("std");

const zig_fft = @import("zig_fft");
const benchmark = @import("benchmark.zig").benchmark;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    comptime var size = 8;

    inline while (size <= 4096) : (size *= 2) {
        benchmark(io, size);
    }  
}
