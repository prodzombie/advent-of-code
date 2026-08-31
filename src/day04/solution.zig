// https://adventofcode.com/2025/day/4

const std = @import("std");
const u = @import("utils");

const data = @embedFile("input.txt");

pub fn solvePart1(grid: [][]const u8) usize {
    if (grid.len == 0) return 0;

    var valid_rolls: usize = 0;

    for (0..grid.len) |y| {
        for (0..grid[0].len) |x| {
            if (grid[y][x] != '@') continue;

            if (u.grid.countNeighborsWhere(grid, y, x, '@') < 4) {
                valid_rolls += 1;
            }
        }
    }

    return valid_rolls;
}

pub fn solvePart2(allocator: std.mem.Allocator, grid: [][]u8) !usize {
    var candidates = try std.ArrayList(u.geometry.Point).initCapacity(allocator, 100);
    defer candidates.deinit(allocator);

    var total_removed: usize = 0;

    while (true) {
        for (0..grid.len) |y| {
            for (0..grid[0].len) |x| {
                if (grid[y][x] != '@') continue;

                const grid_const = @as([][]const u8, @ptrCast(grid));
                if (u.grid.countNeighborsWhere(grid_const, y, x, '@') < 4) {
                    try candidates.append(allocator, .{ .y = @intCast(y), .x = @intCast(x) });
                }
            }
        }

        if (candidates.items.len == 0) {
            break;
        }

        for (candidates.items) |p| {
            grid[@intCast(p.y)][@intCast(p.x)] = '.';
        }

        total_removed += candidates.items.len;

        candidates.clearRetainingCapacity();
    }

    return total_removed;
}

pub const solution: u.solution.DaySolution = .{
    .solve_part_1 = solvePart1Impl,
    .solve_part_2 = solvePart2Impl,
};

fn solvePart1Impl(allocator: std.mem.Allocator) !u64 {
    var grid = try u.grid.readGrid(allocator, data);
    defer {
        for (grid.items) |line| {
            allocator.free(line);
        }
        grid.deinit(allocator);
    }
    const result = solvePart1(@as([][]const u8, @ptrCast(grid.items)));
    return @intCast(result);
}

fn solvePart2Impl(allocator: std.mem.Allocator) !u64 {
    var grid = try u.grid.readGrid(allocator, data);
    defer {
        for (grid.items) |line| {
            allocator.free(line);
        }
        grid.deinit(allocator);
    }
    const result = try solvePart2(allocator, grid.items);
    return @intCast(result);
}
