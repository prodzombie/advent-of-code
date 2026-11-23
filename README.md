# Advent of Code

My Advent of Code solutions, organized by year and language.

| Year | Language | Project |
| --- | --- | --- |
| 2025 | Zig | [Days 1–12](solutions/2025/zig/) |
| 2026 | Haskell | [Cabal scaffold](solutions/2026/haskell/) |

Each project has its own build and test commands. Download your personal inputs
from [Advent of Code](https://adventofcode.com/) and put them in
`inputs/<year>/dayNN.txt`. For example, 2026 Day 1 uses `inputs/2026/day01.txt`.
The `inputs/` directory is ignored by version control.

## 2025 Zig

Use Zig 0.15.2 on your `PATH`.

```sh
cd solutions/2025/zig
zig build
zig build test
zig build run -- 1
zig build run -- all
zig build run -- 1 /path/to/sample.txt
```

Builds and sample tests work without personal inputs. With the 2025 inputs in
place, run `zig build regression` to check the recorded answers and
`zig build perf` to compare timings with the saved baseline. To replace the
baseline, run `zig build perf -- save-baseline`. The performance script uses
Bash 4 or later.

## 2026 Haskell

Use GHC 9.6 or later and Cabal.

```sh
cd solutions/2026/haskell
cabal build
cabal test
cabal run aoc2026
cabal run aoc2026 -- /path/to/sample.txt
```

The executable defaults to `inputs/2026/day01.txt` from the repository root.
Day 1 currently reports that the solver is pending. The sample test runs
without a personal input file.

## Local tool paths

If your compilers are already on `PATH`, you can run the commands above
directly. To use a compiler installed elsewhere, put a `PATH_add` line in
the gitignored `.envrc.local` and run `direnv allow` from the repository root.
For example, `PATH_add "$HOME/.local/zig-0.15.2"` adds the directory containing
the pinned Zig executable.
