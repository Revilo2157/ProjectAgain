module decoder8(
    input [2:0] select,
    output [7:0] out
);

    wire[2:0] select_not;

    // Inverted bits
    not not0(select_not[0], select[0]);
    not not1(select_not[1], select[1]);
    not not2(select_not[2], select[2]);

    // Brute force
    and and0(out[0], select_not[0], select_not[1], select_not[2]);
    and and1(out[1], select[0], select_not[1], select_not[2]);
    and and2(out[2], select_not[0], select[1], select_not[2]);
    and and3(out[3], select[0], select[1], select_not[2]);
    and and4(out[4], select_not[0], select_not[1], select[2]);
    and and5(out[5], select[0], select_not[1], select[2]);
    and and6(out[6], select_not[0], select[1], select[2]);
    and and7(out[7], select[0], select[1], select[2]);

endmodule
