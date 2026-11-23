// https://adventofcode.com/2025/day/3

const std = @import("std");
const u = @import("utils");

fn largestByRemovingK(bank: []const u8, out_len: usize) u64 {
    if (bank.len < out_len) return 0;

    const remove_count = bank.len - out_len;
    var result: u64 = 0;
    var skip: usize = 0;

    for (0..out_len) |i| {
        var max_digit: u8 = bank[skip];
        var max_pos: usize = skip;

        const search_limit = remove_count + i + 1;

        for (skip + 1..search_limit) |j| {
            if (bank[j] > max_digit) {
                max_digit = bank[j];
                max_pos = j;
            }
        }

        result = result * 10 + (max_digit - '0');
        skip = max_pos + 1;
    }

    return result;
}

pub fn largestBatteries(bank: []const u8) u32 {
    return @intCast(largestByRemovingK(bank, 2));
}

pub fn largestBatteries2(bank: []const u8) u64 {
    return largestByRemovingK(bank, 12);
}

pub const solution: u.solution.DaySolution = .{
    .solve_part_1 = solvePart1Impl,
    .solve_part_2 = solvePart2Impl,
};

fn solvePart1Impl(_: std.mem.Allocator, data: []const u8) !u64 {
    var lines = std.mem.tokenizeScalar(u8, data, '\n');
    var part1_total: u64 = 0;

    while (lines.next()) |line| {
        const trimmed = u.parse.trimLine(line);
        if (trimmed.len == 0) continue;
        part1_total += largestBatteries(trimmed);
    }

    return part1_total;
}

fn solvePart2Impl(_: std.mem.Allocator, data: []const u8) !u64 {
    var lines = std.mem.tokenizeScalar(u8, data, '\n');
    var part2_total: u64 = 0;

    while (lines.next()) |line| {
        const trimmed = u.parse.trimLine(line);
        if (trimmed.len == 0) continue;
        part2_total += largestBatteries2(trimmed);
    }

    return part2_total;
}
