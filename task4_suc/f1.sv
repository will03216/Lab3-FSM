module f1(
    input logic[5:0]     N,
    input logic     rst,
    input logic     clk,
    input logic     fsm_trigger,
    output logic [7:0]  data_out,
    output logic    cmd_seq,
    output logic cmd_delay
);
logic tick;
logic time_out;
logic mux_out;
logic[7:1] lfsr_out;

clktick Clocktick(
    .N(N),
    .en(cmd_seq),
    .rst(rst),
    .clk(clk),
    .tick(tick)
);

lfsr7 lfsr(
    .clk(clk),
    .rst(rst),
    .data_out(lfsr_out)
);

mux2 Mux2(
    .d1(tick),
    .d0(time_out),
    .s(cmd_seq),
    .y(mux_out)
);

f1_fsm fsm(
    .rst(rst),
    .en(mux_out),
    .trigger(fsm_trigger),
    .clk(clk),
    .data_out(data_out),
    .cmd_seq(cmd_seq),
    .cmd_delay(cmd_delay)
);

delay Delay(
    .n(lfsr_out),
    .trigger(cmd_delay),
    .rst(rst),
    .clk(clk),
    .time_out(time_out)
);

endmodule
