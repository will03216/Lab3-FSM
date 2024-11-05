module lfsr7(
    input logic clk,
    input logic rst,
    output logic [7:1] data_out
);

logic [7:1]     sreg; // shift register
always_ff @(posedge clk) 
    if (rst)
        sreg <= 4'b1;
    else
        sreg <= {sreg[6:1],sreg[3] ^ sreg[7]};

assign data_out = sreg;
endmodule
