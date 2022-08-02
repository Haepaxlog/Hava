const readline = @import("readline.zig");
const c = @import("c.zig");

pub fn main() anyerror!void {
    readline.enable_auto_completion();
    const prompt = "<Hava> ";

    readline.print_banner();
    outer: while (true) {
        if (readline.read_line(prompt)) |input| {
            readline.add_history(input);
            var ptr_value = readline.read_ptr(input);
            for (ptr_value) |char, index| {
                if (char == ' ') {
                    ptr_value = ptr_value[0..index];
                    break;
                }
            }
            if (readline.is_eql(u8, ptr_value, "q") or readline.is_eql(u8, ptr_value, "exit")) {
                c.free(input);
                break :outer;
            }
            c.free(input);
        } else {
            continue;
        }
    }
}
