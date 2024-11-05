module f1_light_system (
    input logic clk,         // 时钟信号
    input logic rst,         // 复位信号
    output logic [7:0] data_out  // 输出灯状态
);

    // 定义内部信号
    logic tick;
    logic en;

    // 实例化 clktick 模块
    clktick clkdiv (
        .clk(clk),
        .rst(rst),
        .en(1),        // 始终使能 clktick
        .N(50),        // 设置分频比，假设 16 对应于 1 秒延迟
        .tick(tick)    // 输出 tick 信号
    );

    // 实例化 f1_fsm 模块
    f1_fsm fsm (
        .clk(clk),
        .rst(rst),
        .en(tick),        // 使用 tick 信号作为 FSM 的使能信号
        .data_out(data_out)
    );

endmodule
