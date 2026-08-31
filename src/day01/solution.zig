// https://adventofcode.com/2025/day/1

const std = @import("std");
const u = @import("utils");

const day1_data = @embedFile("input.txt");

const STARTING_POSITION: i32 = 50;
const MODULO: i32 = 100;
const INITIAL_CAPACITY: usize = 100;

pub fn turn(start: i32, op: i32) i32 {
    return @rem((@rem((start + op), MODULO) + MODULO), MODULO);
}

pub fn countZeroCrossings(start: i32, op: i32) i32 {
    if (op > 0) {
        return @divFloor(start + op, MODULO);
    } else {
        const abs_op = -op;
        if (start == 0) {
            return @divFloor(abs_op, MODULO);
        } else if (abs_op < start) {
            return 0;
        } else {
            return 1 + @divFloor(abs_op - start, MODULO);
        }
    }
}

/// Parse input data once and return all operations
/// Caller owns the returned ArrayList and must deinit it
fn parseInput(allocator: std.mem.Allocator) !std.ArrayList(i32) {
    var ops = try std.ArrayList(i32).initCapacity(allocator, INITIAL_CAPACITY);
    errdefer ops.deinit(allocator);

    var lines = std.mem.splitSequence(u8, day1_data, "\n");
    while (lines.next()) |line| {
        if (line.len < 2) continue;

        const direction = line[0];
        const num = try std.fmt.parseInt(i32, line[1..], 10);
        const value: i32 = if (direction == 'L') -num else num;
        try ops.append(allocator, value);
    }

    return ops;
}

pub const solution: u.solution.DaySolution = .{
    .solve_part_1 = solvePart1Impl,
    .solve_part_2 = solvePart2Impl,
};

fn solvePart1Impl(allocator: std.mem.Allocator) !u64 {
    var ops = try parseInput(allocator);
    defer ops.deinit(allocator);

    var start: i32 = STARTING_POSITION;
    var res: i32 = 0;
    for (ops.items) |value| {
        start = turn(start, value);
        if (start == 0) {
            res += 1;
        }
    }
    return @intCast(res);
}

fn solvePart2Impl(allocator: std.mem.Allocator) !u64 {
    var ops = try parseInput(allocator);
    defer ops.deinit(allocator);

    var start: i32 = STARTING_POSITION;
    var res: i32 = 0;
    for (ops.items) |value| {
        res += countZeroCrossings(start, value);
        start = turn(start, value);
    }
    return @intCast(res);
}
