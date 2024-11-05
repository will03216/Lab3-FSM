module clktick #(
    parameter WIDTH = 16
)(
  // interface signals
  input  logic             clk,      // clock 
  input  logic             rst,      // reset
  input  logic             en,       // enable signal
  input  logic [WIDTH-1:0] N,        // clock divided by N+1
  output logic             tick      // tick output
);

logic [WIDTH-1:0] count;

always_ff @ (posedge clk) begin
    if (rst) begin
        tick <= 1'b0;
        count <= N;  
    end
    else if (en) begin
        if (count == 0) begin
            tick <= 1'b1;
            count <= N;
        end
        else begin
            tick <= 1'b0;
            count <= count - 1'b1;
        end
    end
    else begin
        tick <= 1'b0; // 添加此行，以确保在 `en` 为低时 tick 始终为 0
    end
end

endmodule
