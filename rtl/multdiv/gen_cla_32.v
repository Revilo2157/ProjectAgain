module cla_32(
    input carry_in, 
    input [31:0] operandA, 
    input [31:0] operandB, 
    output [31:0] sum, 
    output [31:0] or_val,
    output [31:0] and_val,
    output overflow
);

    wire p0, p1, p2, p3, g0, g1, g2, g3, c1, c2, c3;

    // Add 4 8-bit CLA adders
    cla_8 adder1(
        .carry_in   (carry_in), 
        .operandA   (operandA[7:0]), 
        .operandB   (operandB[7:0]), 
        .sum        (sum[7:0]), 
        .ps         (or_val[7:0]),
        .gs         (and_val[7:0]),
        .prop       (p0), 
        .gen        (g0), 
        .overflow   ());

    cla_8 adder2(
        .carry_in   (c1),
        .operandA   (operandA[15:8]),
        .operandB   (operandB[15:8]),
        .sum        (sum[15:8]),
        .ps         (or_val[15:8]),
        .gs         (and_val[15:8]),
        .prop       (p1),
        .gen        (g1),
        .overflow   ());

    cla_8 adder3(
        .carry_in   (c2),
        .operandA   (operandA[23:16]),
        .operandB   (operandB[23:16]),
        .sum        (sum[23:16]),
        .ps         (or_val[23:16]),
        .gs         (and_val[23:16]),
        .prop       (p2),
        .gen        (g2),
        .overflow   ());
        
    cla_8 adder4(
        .carry_in   (c3),
        .operandA   (operandA[31:24]),
        .operandB   (operandB[31:24]),
        .sum        (sum[31:24]),
        .ps         (or_val[31:24]),
        .gs         (and_val[31:24]),
        .prop       (p3),
        .gen        (g3),
        .overflow   (overflow));

    // Create c1
    wire c1_t1;
    and and1_c1(c1_t1, p0, carry_in);
    or (c1, g0, c1_t1);

    // Create c2
    wire c2_t1, c2_t2;
    and and1_c2(c2_t1, p1, p0, carry_in);
    and and2_c2(c2_t2, p1, g0);
    or (c2, g1, c2_t1, c2_t2);

    // Create c3
    wire c3_t1, c3_t2, c3_t3;
    and and1_c3(c3_t1, p2, p1, p0, carry_in);
    and and2_c3(c3_t2, p2, p1, g0);
    and and3_c3(c3_t3, p2, g1);
    or (c3, g2, c3_t1, c3_t2, c3_t3);  

endmodule
