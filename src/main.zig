const std = @import("std");
const c = @cImport({
    @cInclude("stdlib.h");
    @cInclude("stdio.h");
    @cInclude("readline/readline.h");
    @cInclude("readline/history.h");
});
const debug = std.debug.print;
const print = std.io.getStdOut().writer().print;
const allocator = std.testing.allocator;

// fn ask_user() ![]u8 {
//     const stdin = std.io.getStdIn().reader();
//     const kbyte = 1024;
//     var buf: [kbyte * kbyte]u8 = undefined;

//     if (stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |user_input| {
//         return user_input orelse "";
//     } else |err| {
//         return err;
//     }
// }

fn read_line(prompt: [*c]const u8) ?[*c]u8 {
    if (c.readline(prompt)) |line| {
        return line;
    }
    return null;
}

fn read_ptr(p: [*c]u8) []u8 {
    var i: usize = 0;
    var list = std.ArrayList(u8).init(allocator);
    while (true) {
        list.append(p[i]) catch {
            debug("err", .{});
        };
        if (p[i + 1] == 0) {
            break;
        }
        i += 1;
    }
    const result = list.toOwnedSlice();

    list.deinit();
    return result;
}

pub fn main() anyerror!void {
    _ = c.rl_bind_key('\t', c.rl_complete);
    const prompt = "<HAVA> ";

    outer: while (true) {
        if (read_line(prompt)) |input| {
            c.add_history(input);
            const ptr_value = read_ptr(input);
            if (std.mem.eql(u8, ptr_value, "q") or std.mem.eql(u8, ptr_value, "exit")) {
                c.free(input);
                break :outer;
            }
            c.free(input);
        } else {
            continue;
        }
    }
}
