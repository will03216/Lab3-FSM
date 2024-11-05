module f1_fsm(
    input logic     clk,
    input logic     en,
    input logic     rst,
    input logic     trigger,
    output logic   [7:0] data_out,
    output logic    cmd_seq,
    output logic    cmd_delay
);
    // define states
    typedef enum  {S0,S1,S2,S3,S4,S5,S6,S7,S8 } my_state;
    my_state current_state, next_state;

// next state logic
always_comb 
    case (current_state)
        S0: if (en & trigger==1)      next_state = S1;
            else                      next_state = current_state;
        S1: if (en)     next_state = S2;
            else        next_state = current_state;
        S2: if (en)     next_state = S3;
            else        next_state = current_state;
        S3: if (en)     next_state = S4;
            else        next_state = current_state;
        S4: if (en)     next_state = S5;
            else        next_state = current_state;
        S5: if (en)     next_state = S6;
            else        next_state = current_state;
        S6: if (en)     next_state = S7;
            else        next_state = current_state;
        S7: if (en)     next_state = S8;
            else        next_state = current_state;
        S8: if (en)     next_state = S0;
            else        next_state = current_state;
            
        default: next_state = S0;
    endcase

always_ff @(posedge clk)
    begin
    if (rst)    current_state <= S0;
    else        current_state <= next_state;

    if(current_state==S8 & cmd_delay==1) cmd_delay = 0;
    end
always_comb
    case (current_state)
        S0:
            begin
            data_out = 8'b0;
            cmd_seq = 1;
            cmd_delay = 0;
            end
        S1: data_out = 8'b1;
        S2: data_out = 8'b11;
        S3: data_out = 8'b111;
        S4: data_out = 8'b1111;
        S5: data_out = 8'b11111;
        S6: data_out = 8'b111111;
        S7: 
            begin
            data_out = 8'b1111111;
            //cmd_delay = 1;
            end
        S8: 
            begin
            data_out = 8'b11111111;
            cmd_seq = 0;
            cmd_delay = 1;
            end
        default: begin
                 data_out = 8'b11111111;
                 cmd_seq = 1;
                 cmd_delay = 0;
                 end
    endcase
endmodule
