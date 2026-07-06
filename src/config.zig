const std = @import("std");
const Complex = std.math.complex.Complex;

const getDynTwiddleTable = @import("complex.zig").getDynTwiddleTable;

pub const ZConfig = struct {
    allocator: std.mem.Allocator,
    size: usize,
    twiddle_table: []Complex(f32),
    bit_perm: []usize,

    pub fn init(allocator: std.mem.Allocator, N: usize) !ZConfig {
        const table = try getDynTwiddleTable(allocator, N);
        const perms = try bitReversePerm(allocator, N);

        return .{
            .allocator = allocator,
            .size = N,
            .twiddle_table = table,
            .bit_perm = perms
        };
    }

    pub fn deinit(self: *ZConfig) void {
        self.allocator.free(self.twiddle_table);
        self.allocator.free(self.bit_perm);
    }
};

fn bitReversePerm(allocator: std.mem.Allocator, size: usize) ![]usize {
    var perms = try allocator.alloc(usize, size);
    
    const num_of_bits: usize = std.math.log2(size);
    
    for (0..size) |i| {
        var index = i;
        var new_index: usize = 0;
        
        for (0..num_of_bits) |_| {
            new_index <<= 1;
            new_index += index % 2;
            index >>= 1;
        }

        perms[i] = new_index;
    }

    return perms;
}
