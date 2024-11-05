module lfsr (
    input logic clk,          // 时钟信号
    input logic rst,          // 复位信号
    input logic en,
    output logic [3:0] data_out  
);

    logic [3:0] sreg;          // 移位寄存器

    always_ff @ (posedge clk or posedge rst) begin
        if (rst) 
            sreg <= 4'b0001;   
        else 
            sreg <= {sreg[2:0], sreg[3] ^ sreg[2]};  // 移位并生成反馈
    end

    assign data_out = sreg;     // 输出当前寄存器状态

endmodule
