module mux2(
    input logic     d0,
    input logic     d1,
    input logic     s,
    output logic    y
);

assign y = s ? d1:d0;
endmodule
