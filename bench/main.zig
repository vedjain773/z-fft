const std = @import("std");

const zig_fft = @import("zig_fft");
const benchmark = @import("benchmark.zig").benchmark;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    benchmark(io, 1024);
}
