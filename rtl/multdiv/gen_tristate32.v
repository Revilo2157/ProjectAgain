module tristate32(
    input [31:0] data,
    input enable,
    output [31:0] out
);

    assign out = enable ? data : {32{1'bz}};

endmodule