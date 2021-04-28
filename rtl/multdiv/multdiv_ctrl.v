module multdiv_ctrl(
    input [2:0] ctrl_sequence,
    input div_msb,
    input start_mult,
    input start_div,
    input div_sign,
    input clock,
    output operation, // 0 for add, 1 for subtract
    output nop,
    output shift,
    output ready,
    output op_mult,
    output op_div,
    output div_ready // Useful for knowing if last op was div
);

    wire [7:0] decoded_seq;
    decoder8 decoder(
        .select (ctrl_sequence),
        .out    (decoded_seq));

    wire operation_mult, nop_mult, shift_mult, op_mult_int, op_div_int;

    wire new_op = start_mult | start_div;

    // When MSB is 1, always subtract (possibly do nothing!)
    or sub_gate(operation_mult, decoded_seq[4], decoded_seq[5], decoded_seq[6]);

    // Need to do something for every case except 111 and 000 (or when start_mult)
    nor write_gate(nop_mult, decoded_seq[1], decoded_seq[2], decoded_seq[3], decoded_seq[4], decoded_seq[5], decoded_seq[6], start_mult);

    // Shift for 100 and 011
    or shift_gate(shift_mult, decoded_seq[3], decoded_seq[4]);

    // Resolve signals
    assign operation = op_mult_int ? operation_mult : (div_sign ? (div_msb) : (~div_msb));
    assign nop = op_mult_int ? nop_mult : 1'b0;
    assign shift = op_mult_int ? shift_mult : 1'b0;

    // Ready?
    wire mult_ready;
    multdiv_counters counter(
        .clock      (clock),
        .enable     (1'b1),
        .reset      (new_op), 
        .ovf16      (mult_ready),
        .ovf32      (div_ready));
        
    // Construct actual ready signal
    assign ready = op_mult ? mult_ready : div_ready;

    dffe_ref cur_mult(
        .d      (start_mult),
        .clk    (clock),
        .q      (op_mult_int),
        .en     (new_op | ready),
        .clr    (1'b0));

    dffe_ref cur_div(
        .d      (start_div),
        .clk    (clock),
        .q      (op_div_int),
        .en     (new_op | ready),
        .clr    (1'b0));

    assign op_mult = op_mult_int & ~new_op;
    assign op_div= op_div_int & ~new_op;


endmodule