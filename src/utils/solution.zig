const std = @import("std");

pub const Metrics = struct {
    part1_result: u64,
    part1_time_ms: f64,
    part2_result: u64,
    part2_time_ms: f64,

    pub fn total_time_ms(self: Metrics) f64 {
        return self.part1_time_ms + self.part2_time_ms;
    }
};

pub const Solver = *const fn (allocator: std.mem.Allocator, input: []const u8) anyerror!u64;

pub const DaySolution = struct {
    solve_part_1: Solver,
    solve_part_2: Solver,
};

/// Measure performance of both solution parts with proper resource cleanup.
/// Each part gets its own arena allocator for isolated memory management.
pub fn measureMetrics(
    parent_allocator: std.mem.Allocator,
    solution: DaySolution,
    input: []const u8,
) !Metrics {
    var timer = try std.time.Timer.start();

    var arena1 = std.heap.ArenaAllocator.init(parent_allocator);
    defer arena1.deinit();
    const part1_result = try solution.solve_part_1(arena1.allocator(), input);
    const part1_time = timer.lap();

    var arena2 = std.heap.ArenaAllocator.init(parent_allocator);
    defer arena2.deinit();
    const part2_result = try solution.solve_part_2(arena2.allocator(), input);
    const part2_time = timer.lap();

    return Metrics{
        .part1_result = part1_result,
        .part1_time_ms = @as(f64, @floatFromInt(part1_time)) / 1_000_000,
        .part2_result = part2_result,
        .part2_time_ms = @as(f64, @floatFromInt(part2_time)) / 1_000_000,
    };
}
