module lfsr_7 (
    input logic clk,          // 时钟信号
    input logic rst,          // 复位信号
    output logic [6:0] data_out  // 7 位伪随机输出
);

    logic [6:0] sreg;          // 7 位移位寄存器

    always_ff @ (posedge clk or posedge rst) begin
        if (rst)
            sreg <= 7'b0000001;   // 复位时将状态设置为 1
        else
            sreg <= {sreg[5:0], sreg[6] ^ sreg[5]};  // 根据多项式 x^7 + x^6 + 1 生成反馈
    end

    assign data_out = sreg;     // 输出当前寄存器状态

endmodule
