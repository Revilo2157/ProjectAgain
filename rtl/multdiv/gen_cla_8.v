module cla_8(
    input carry_in, 
    input [7:0] operandA, 
    input [7:0] operandB, 
    output [7:0] sum, 
    output [7:0] ps,
    output [7:0] gs,
    output prop, 
    output gen, 
    output overflow
);

    wire [7:0] carry;
    assign carry[0] = carry_in;

    // Generate Ps, Gs, and Sum
    genvar bit;
    generate
        for (bit = 0; bit < 8; bit= bit + 1) begin:lookaheads
            and g(gs[bit], operandA[bit], operandB[bit]);
            or p(ps[bit], operandA[bit], operandB[bit]);
            xor sum2(sum[bit], operandA[bit], operandB[bit], carry[bit]);
        end
    endgenerate

    // Create c1 (i=0)
    wire c1_t1;
    and and1_c1(c1_t1, carry_in, ps[0]);
    or out_c1(carry[1], c1_t1, gs[0]);

    // Create c2 (i=1)
    wire c2_t1, c2_t2;
    and and1_c2(c2_t1, carry_in, ps[0], ps[1]);
    and and2_c2(c2_t2, gs[0], ps[1]);
    or out_c2(carry[2], c2_t1, c2_t2, gs[1]);

    // Create c3 (i=2)
    wire c3_t1, c3_t2, c3_t3;
    and and1_c3(c3_t1, gs[1], ps[2]);
    and and2_c3(c3_t2, ps[1], ps[2], gs[0]);
    and and3_c3(c3_t3, ps[1], ps[2], ps[0], carry_in);
    or out_c3(carry[3], c3_t1, c3_t2, c3_t3, gs[2]);

    // Create c4 (i=3)
    wire c4_t1, c4_t2, c4_t3, c4_t4;
    and and1_c4(c4_t1, gs[2], ps[3]);
    and and2_c4(c4_t2, gs[1], ps[2], ps[3]);
    and and3_c4(c4_t3, gs[0], ps[1], ps[2], ps[3]);
    and and4_c4(c4_t4, carry_in, ps[0], ps[1], ps[2], ps[3]);
    or out_c4(carry[4], c4_t1, c4_t2, c4_t3, c4_t4, gs[3]);

    // Create c5 (i=4)
    wire c5_t1, c5_t2, c5_t3, c5_t4, c5_t5;
    and and1_c5(c5_t1, gs[3], ps[4]);
    and and2_c5(c5_t2, gs[2], ps[4], ps[3]);
    and and3_c5(c5_t3, gs[1], ps[4], ps[3], ps[2]);
    and and4_c5(c5_t4, gs[0], ps[4], ps[3], ps[2], ps[1]);
    and and5_c5(c5_t5, carry_in, ps[4], ps[3], ps[2], ps[1], ps[0]);
    or out_c5(carry[5], c5_t1, c5_t2, c5_t3, c5_t4, c5_t5, gs[4]);

    // Create c6 (i=5)
    wire c6_t1, c6_t2, c6_t3, c6_t4, c6_t5, c6_t6;
    and and1_c6(c6_t1, gs[4], ps[5]);
    and and2_c6(c6_t2, gs[3], ps[5], ps[4]);
    and and3_c6(c6_t3, gs[2], ps[5], ps[4], ps[3]);
    and and4_c6(c6_t4, gs[1], ps[5], ps[4], ps[3], ps[2]);
    and and5_c6(c6_t5, gs[0], ps[5], ps[4], ps[3], ps[2], ps[1]);
    and and6_c6(c6_t6, carry_in, ps[5], ps[4], ps[3], ps[2], ps[1], ps[0]);
    or out_c6(carry[6], c6_t1, c6_t2, c6_t3, c6_t4, c6_t5, c6_t6, gs[5]);

    // Create c7 (i=6)
    wire c7_t1, c7_t2, c7_t3, c7_t4, c7_t5, c7_t6, c7_t7;
    and and1_c7(c7_t1, gs[5], ps[6]);
    and and2_c7(c7_t2, gs[4], ps[6], ps[5]);
    and and3_c7(c7_t3, gs[3], ps[6], ps[5], ps[4]);
    and and4_c7(c7_t4, gs[2], ps[6], ps[5], ps[4], ps[3]);
    and and5_c7(c7_t5, gs[1], ps[6], ps[5], ps[4], ps[3], ps[2]);
    and and6_c7(c7_t6, gs[0], ps[6], ps[5], ps[4], ps[3], ps[2], ps[1]);
    and and7_c7(c7_t7, carry_in, ps[6], ps[5], ps[4], ps[3], ps[2], ps[1], ps[0]);
    or out_c7(carry[7], c7_t1, c7_t2, c7_t3, c7_t4, c7_t5, c7_t6, c7_t7, gs[6]);

    // Create overall propogate signal
    and prop_out(prop, ps[0], ps[1], ps[2], ps[3], ps[4], ps[5], ps[6], ps[7]);

    // Create overall generate signal
    wire gen_t1, gen_t2, gen_t3, gen_t4, gen_t5, gen_t6, gen_t7, gen_t8;
    and and1_gen(gen_t1, gs[6], ps[7]);
    and and2_gen(gen_t2, gs[5], ps[7], ps[6]);
    and and3_gen(gen_t3, gs[4], ps[7], ps[6], ps[5]);
    and and4_gen(gen_t4, gs[3], ps[7], ps[6], ps[5], ps[4]);
    and and6_gen(gen_t5, gs[2], ps[7], ps[6], ps[5], ps[4], ps[3]);
    and and7_gen(gen_t6, gs[1], ps[7], ps[6], ps[5], ps[4], ps[3], ps[2]);
    and and8_gen(gen_t7, gs[0], ps[7], ps[6], ps[5], ps[4], ps[3], ps[2], ps[1]);
    and and9_gen(gen_t8, carry_in, ps[7], ps[6], ps[5], ps[4], ps[3], ps[2], ps[1], ps[0]);
    or out_gen(gen, gen_t1, gen_t2, gen_t3, gen_t4, gen_t5, gen_t6, gen_t7, gen_t8, gs[7]);

    // Overflow bit (value only used for the most significant adder)
    xor(overflow, gen, carry[7]);

endmodule
