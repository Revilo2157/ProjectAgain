module reg65 (
	input clock,
	input write_enable,
	input clear,
	input [64:0] input_data,
	output [64:0] output_data
);

	// 32 bits
    genvar bit;
    generate
        for (bit = 0; bit < 65; bit = bit + 1) begin:memory
			dffe_ref dff(
				.q		(output_data[bit]),
				.d		(input_data[bit]),
				.en   	(write_enable),
				.clk	(clock),
				.clr	(clear));
        end
    endgenerate

endmodule