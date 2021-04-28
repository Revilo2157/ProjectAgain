module mux32_2(
    input select,
    input [31:0] in0,
    input [31:0] in1,
    output [31:0] out
);

    assign out = select ? in1 : in0;
    
endmodule