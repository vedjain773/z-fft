const std = @import("std");
const Complex = std.math.complex.Complex;

const getDynTwiddleTable = @import("complex.zig").getDynTwiddleTable;

pub const ZConfig = struct {
    allocator: std.mem.Allocator,
    size: usize,
    twiddle_table: []Complex(f32),

    pub fn init(allocator: std.mem.Allocator, N: usize) !ZConfig {
        const table = try getDynTwiddleTable(allocator, N);

        return .{
            .allocator = allocator,
            .size = N,
            .twiddle_table = table
        };
    }

    pub fn deinit(self: *ZConfig) void {
        self.allocator.free(self.twiddle_table);
    }
};
