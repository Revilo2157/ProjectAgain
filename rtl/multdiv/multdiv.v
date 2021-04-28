module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    // Product wires 
    wire [64:0] product_out;
    wire [64:0] product_in;
    wire nop, done;

    // Arithmetic wires
    wire operation, shift;

    // Control wires
    wire op_mult, op_div, div_ready, div_0_error;

    // Control circuit
    multdiv_ctrl ctrl(
        .ctrl_sequence  (product_out[2:0]),
        .div_msb        (product_out[63]),
        .start_mult     (ctrl_MULT),
        .start_div      (ctrl_DIV),
        .div_sign       (data_operandB[31]),
        .clock          (clock),
        .operation      (operation),
        .nop            (nop),
        .shift          (shift),
        .ready          (done),
        .op_mult        (op_mult),
        .op_div         (op_div),
        .div_ready      (div_ready));

    // Add circuitry to negate data_operandA
    wire [31:0] operandA; // Correct inversion
    wire [31:0] data_operandA_not;
    not32_2 a_inv(
        .out    (data_operandA_not),
        .in     (op_mult ? data_operandA : data_operandB));
    mux32_2 add_sub_mux(
        .select     (operation),
        .in0        (op_mult ? data_operandA : data_operandB), 
        .in1        (data_operandA_not),
        .out        (operandA));


    // Shift the operandA if necessary
    wire [31:0] operandA_shift, operandA_resolved;
    assign operandA_shift[31:1] = operandA[30:0];
    assign operandA_shift[0] = operation;
    mux32_2 shift_booth_mux(
        .select     (shift),
        .in0        (operandA),
        .in1        (operandA_shift),
        .out        (operandA_resolved));

    // Nop if needed
    wire [31:0] nop_wire = 0;
    wire [31:0] alu_operand;
    mux32_2 nop_mux(
        .select     (nop),
        .in0        (operandA_resolved),
        .in1        (nop_wire),
        .out        (alu_operand));

    // Adder (main)
    wire [31:0] adder_out;
    cla_32 adder(
        .carry_in   (operation),
        .operandA   (op_mult ? product_out[64:33] : product_out[63:32]), 
        .operandB   (alu_operand),
        .sum        (adder_out),
        .or_val     (), 
        .and_val    (),
        .overflow   () // Nothing?
        );

    // Adder (for fixing signs)
    wire div_sign_ovf;
    wire [31:0] sign_fixed;
    cla_32 adder_sign(
        .carry_in   (1'b0),
        .operandA   (ctrl_DIV ? ~data_operandA : ~product_out[32:1]),
        .operandB   (32'd1),
        .sum        (sign_fixed),
        .or_val     (), 
        .and_val    (),
        .overflow   (div_sign_ovf));

    // Product
    reg65 product_reg(
        .clock          (clock),
        .write_enable   (~done), // Only write to the product register if the data isn't ready
        .clear          (1'b0), 
        .input_data     (product_in),
        .output_data    (product_out));
    
    // Insert data into the product register (arithemtic shift 2 bit) (mult)  
    assign product_in[30:0] = op_mult ? product_out[32:2] : {31{1'bz}};
    assign product_in[62:31] = op_mult ? adder_out[31:0] : {32{1'bz}};
    assign product_in[64:63] = op_mult ? {2{product_in[62]}} : {2{1'bz}};

    // Initial states (mult)
    assign product_in[32:1] = ctrl_MULT ? data_operandB : {32{1'bz}};
    assign product_in[0] = ctrl_MULT ? {1'b0} : {1'bz};
    assign product_in[64:33] = ctrl_MULT ?  {32{1'b0}} : {32{1'bz}};

    // Initial states (div)
    assign product_in[0] = ctrl_DIV ? {1'b0} : {1'bz};
    assign product_in[32:1] = ctrl_DIV ? (data_operandA[31] ? sign_fixed[31:0] : data_operandA[31:0]) : {32{1'bz}};
    assign product_in[63:33] = ctrl_DIV ? {31'b0} : {31'bz};

    // Insert data into the product register (shift 1 bit) (div)
    assign product_in[63:33] = op_div ? adder_out[30:0] : {31{1'bz}};
    assign product_in[32:2] = op_div ? product_out[31:1] : {31{1'bz}};
    assign product_in[1] = op_div ? (~adder_out[31]) : {1'bz};
    assign product_in[0] = op_div ? {1'b0} : {1'bz};

    // Output
    assign data_result = (div_ready & ((~data_operandA[31] & data_operandB[31]) | (data_operandA[31] & ~data_operandB[31]))) ? sign_fixed[31:0] : product_out[32:1];
    assign data_resultRDY = done;

    // Overflow Check (upper 32 bits of product_out not all 0 or not all 1)
    wire mult_all_neg, mult_all_pos, mult_sign_ovf, mult_sign_mismatch;
    nor nor_sign_check(mult_all_pos,  product_out[64], product_out[63], product_out[62], product_out[61], product_out[60],
                            product_out[59], product_out[58], product_out[57], product_out[56], product_out[55],
                            product_out[54], product_out[53], product_out[52], product_out[51], product_out[50],
                            product_out[49], product_out[48], product_out[47], product_out[46], product_out[45],
                            product_out[44], product_out[43], product_out[42], product_out[41], product_out[40], 
                            product_out[39], product_out[38], product_out[37], product_out[36], product_out[35],
                            product_out[34], product_out[33], product_out[32]);
    and and_sign_check(mult_all_neg,  product_out[64], product_out[63], product_out[62], product_out[61], product_out[60],
                            product_out[59], product_out[58], product_out[57], product_out[56], product_out[55],
                            product_out[54], product_out[53], product_out[52], product_out[51], product_out[50],
                            product_out[49], product_out[48], product_out[47], product_out[46], product_out[45],
                            product_out[44], product_out[43], product_out[42], product_out[41], product_out[40], 
                            product_out[39], product_out[38], product_out[37], product_out[36], product_out[35],
                            product_out[34], product_out[33], product_out[32]);
    nor(mult_sign_ovf, mult_all_neg, mult_all_pos);
    wire neq_zero;
    or eq_gate(neq_zero,  data_result[0], data_result[1], data_result[2], data_result[3], data_result[4],
                            data_result[5], data_result[6], data_result[7], data_result[8], data_result[9],
                            data_result[10], data_result[11], data_result[12], data_result[13], data_result[14],
                            data_result[15], data_result[16], data_result[17], data_result[18], data_result[19],
                            data_result[20], data_result[21], data_result[22], data_result[23], data_result[24], 
                            data_result[25], data_result[26], data_result[27], data_result[28], data_result[29],
                            data_result[30], data_result[31]);

    nor div_0_gate(div_0_error, data_operandB[0], data_operandB[1], data_operandB[2], data_operandB[3], data_operandB[4],
                            data_operandB[5], data_operandB[6], data_operandB[7], data_operandB[8], data_operandB[9],
                            data_operandB[10], data_operandB[11], data_operandB[12], data_operandB[13], data_operandB[14],
                            data_operandB[15], data_operandB[16], data_operandB[17], data_operandB[18], data_operandB[19],
                            data_operandB[20], data_operandB[21], data_operandB[22], data_operandB[23], data_operandB[24], 
                            data_operandB[25], data_operandB[26], data_operandB[27], data_operandB[28], data_operandB[29],
                            data_operandB[30], data_operandB[31]);

    assign mult_sign_mismatch = (neq_zero & ~data_result[31] & ~data_operandA[31] & data_operandB[31]) | (neq_zero & ~data_result[31] & data_operandA[31] & ~data_operandB[31]) | (data_result[31] & ~data_operandA[31] & ~data_operandB[31]) | (data_result[31] & data_operandA[31] & data_operandB[31]);
    assign data_exception = div_ready ? (div_sign_ovf | div_0_error) : (mult_sign_ovf | mult_sign_mismatch);


endmodule