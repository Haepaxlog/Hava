const std = @import("std");
const c = @import("c.zig");

const debug = std.debug.print;
const print = std.io.getStdOut().writer.print;
const allocator = std.testing.allocator;

pub extern fn add_history([*c]u8) void;

pub fn print_banner() void {
    const text =
        \\Hava 0.0.1
        \\---------------------------------------------------------------------------------
        \\Hava is an interactive language learning tool.                                   |
        \\It is here to aid in the creation of vocabulary collections and anki flashcards.|
        \\Type "help" for additional information!                                          |
        \\---------------------------------------------------------------------------------
        \\
        \\
    ;

    std.debug.print(text, .{});
}

pub fn enable_auto_completion() void {
    c.rl_attempted_completion_function = c.keyword_completion;
    _ = c.rl_bind_key('\t', c.rl_complete);
}

pub fn read_line(prompt: [*c]const u8) ?[*c]u8 {
    if (c.readline(prompt)) |line| {
        return line;
    }
    return null;
}

pub fn read_ptr(p: [*c]u8) []u8 {
    var i: usize = 0;
    var list = std.ArrayList(u8).init(allocator);
    defer list.deinit();
    while (true) {
        list.append(p[i]) catch {
            debug("list.append err", .{});
        };
        if (p[i + 1] == 0) {
            break;
        }
        i += 1;
    }
    const result = list.toOwnedSlice();

    return result;
}

pub fn is_eql(comptime T: type, str1: []const T, str2: []const T) bool {
    if (std.mem.eql(T, str1, str2)) {
        return true;
    }
    return false;
}
