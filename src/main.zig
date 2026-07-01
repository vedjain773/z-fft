const std = @import("std");
const Io = std.Io;

const zig_fft = @import("zig_fft");

pub fn main() !void {
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});
}
