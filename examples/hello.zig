// hello.zig — smallest Zig program (static example; zig not installed locally)
const std = @import("std");

pub fn main() void {
    std.debug.print("Hello, Zig!\n", .{});
}