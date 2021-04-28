module tristate(
    input data,
    input enable,
    output out
);

    assign out = enable ? data : 1'bz;

endmodule