module decoder32(
    input [4:0] select,
    output [31:0] out
);

    wire[4:0] select_not;

    // Inverted bits
    not not0(select_not[0], select[0]);
    not not1(select_not[1], select[1]);
    not not2(select_not[2], select[2]);
    not not3(select_not[3], select[3]);
    not not4(select_not[4], select[4]);

    // Brute force
    and and0(out[0], select_not[0], select_not[1], select_not[2], select_not[3], select_not[4]);
    and and1(out[1], select[0], select_not[1], select_not[2], select_not[3], select_not[4]);
    and and2(out[2], select_not[0], select[1], select_not[2], select_not[3], select_not[4]);
    and and3(out[3], select[0], select[1], select_not[2], select_not[3], select_not[4]);
    and and4(out[4], select_not[0], select_not[1], select[2], select_not[3], select_not[4]);
    and and5(out[5], select[0], select_not[1], select[2], select_not[3], select_not[4]);
    and and6(out[6], select_not[0], select[1], select[2], select_not[3], select_not[4]);
    and and7(out[7], select[0], select[1], select[2], select_not[3], select_not[4]);
    and and8(out[8], select_not[0], select_not[1], select_not[2], select[3], select_not[4]);
    and and9(out[9], select[0], select_not[1], select_not[2], select[3], select_not[4]);
    and and10(out[10], select_not[0], select[1], select_not[2], select[3], select_not[4]);
    and and11(out[11], select[0], select[1], select_not[2], select[3], select_not[4]);
    and and12(out[12], select_not[0], select_not[1], select[2], select[3], select_not[4]);
    and and13(out[13], select[0], select_not[1], select[2], select[3], select_not[4]);
    and and14(out[14], select_not[0], select[1], select[2], select[3], select_not[4]);
    and and15(out[15], select[0], select[1], select[2], select[3], select_not[4]);
    and and16(out[16], select_not[0], select_not[1], select_not[2], select_not[3], select[4]);
    and and17(out[17], select[0], select_not[1], select_not[2], select_not[3], select[4]);
    and and18(out[18], select_not[0], select[1], select_not[2], select_not[3], select[4]);
    and and19(out[19], select[0], select[1], select_not[2], select_not[3], select[4]);
    and and20(out[20], select_not[0], select_not[1], select[2], select_not[3], select[4]);
    and and21(out[21], select[0], select_not[1], select[2], select_not[3], select[4]);
    and and22(out[22], select_not[0], select[1], select[2], select_not[3], select[4]);
    and and23(out[23], select[0], select[1], select[2], select_not[3], select[4]);
    and and24(out[24], select_not[0], select_not[1], select_not[2], select[3], select[4]);
    and and25(out[25], select[0], select_not[1], select_not[2], select[3], select[4]);
    and and26(out[26], select_not[0], select[1], select_not[2], select[3], select[4]);
    and and27(out[27], select[0], select[1], select_not[2], select[3], select[4]);
    and and28(out[28], select_not[0], select_not[1], select[2], select[3], select[4]);
    and and29(out[29], select[0], select_not[1], select[2], select[3], select[4]);
    and and30(out[30], select_not[0], select[1], select[2], select[3], select[4]);
    and and31(out[31], select[0], select[1], select[2], select[3], select[4]);

endmodule