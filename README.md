# Advent of Code

Personal Advent of Code solutions organized by year and language. The original
2025 Zig project lives in `solutions/2025/zig/`.

Keep personal inputs in the gitignored `inputs/<year>/dayNN.txt` directory tree.
For example, Day 1 of 2025 reads `inputs/2025/day01.txt`. Download your inputs
from [Advent of Code](https://adventofcode.com/).

## 2025 Zig

Use Zig 0.15.2. The root Nix flake provides it through `nix develop` or
`direnv allow`.

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
