module mux32_4(
    input [1:0] select,
    input [31:0] in0,
    input [31:0] in1,
    input [31:0] in2,
    input [31:0] in3,
    output [31:0] out
);

    wire [31:0] w1, w2;

    // "Layer" 1
    mux32_2 mux1(
        .out    (w1), 
        .in0    (in0), 
        .in1    (in1),
        .select (select[0]));
    mux32_2 mux2(
        .out    (w2), 
        .in0    (in2), 
        .in1    (in3),
        .select (select[0]));

    // "Layer" 2
    mux32_2 mux3(
        .out    (out), 
        .in0    (w1), 
        .in1    (w2),
        .select (select[1]));
    
endmodule