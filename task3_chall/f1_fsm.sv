module f1_fsm (
    input logic clk,          // 时钟信号
    input logic rst,          // 复位信号
    input logic en,           // 使能信号，控制状态转移
    output logic [7:0] data_out  // 8 位灯光输出信号
);

    // 定义状态类型
    typedef enum logic [3:0] {
        S0, S1, S2, S3, S4, S5, S6, S7, S8
    } state_t;

    state_t current_state, next_state;

    // 状态转移逻辑
    always_ff @ (posedge clk or posedge rst) begin
        if (rst)
            current_state <= S0;
        else if (en)
            current_state <= next_state;
    end

    // 状态机逻辑
    always_comb begin
        case (current_state)
            S0: begin
                data_out = 8'b00000000;
                next_state = S1;
            end
            S1: begin
                data_out = 8'b00000001;
                next_state = S2;
            end
            S2: begin
                data_out = 8'b00000011;
                next_state = S3;
            end
            S3: begin
                data_out = 8'b00000111;
                next_state = S4;
            end
            S4: begin
                data_out = 8'b00001111;
                next_state = S5;
            end
            S5: begin
                data_out = 8'b00011111;
                next_state = S6;
            end
            S6: begin
                data_out = 8'b00111111;
                next_state = S7;
            end
            S7: begin
                data_out = 8'b01111111;
                next_state = S8;
            end
            S8: begin
                data_out = 8'b11111111;
                next_state = S0;  // 返回初始状态，形成循环
            end
            default: begin
                data_out = 8'b00000000;
                next_state = S0;
            end
        endcase
    end

endmodule


