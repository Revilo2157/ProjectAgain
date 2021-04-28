module not32_2(
    output [31:0] out,
    input [31:0] in
);

    genvar bit;
    generate
        for (bit = 0; bit < 32; bit = bit + 1) begin
            not gate(out[bit], in[bit]);
        end
    endgenerate

endmodule