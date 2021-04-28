module mux32_8(
    input [2:0] select,
    input [31:0] in0,
    input [31:0] in1,
    input [31:0] in2,
    input [31:0] in3,
    input [31:0] in4,
    input [31:0] in5,
    input [31:0] in6,
    input [31:0] in7,
    output [31:0] out
);

    wire [31:0] w1, w2;

    // "Layer" 1
    mux32_4 mux1(
        .out    (w1), 
        .in0    (in0), 
        .in1    (in1),
        .in2    (in2), 
        .in3    (in3),
        .select (select[1:0]));
    mux32_4 mux2(
        .out    (w2), 
        .in0    (in4), 
        .in1    (in5),
        .in2    (in6), 
        .in3    (in7),
        .select (select[1:0]));

    // "Layer" 2
    mux32_2 mux3(
        .out    (out), 
        .in0    (w1), 
        .in1    (w2),
        .select (select[2]));
    
endmodule