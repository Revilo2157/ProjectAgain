module tff(
    input toggle,
    input clock,
    input clear,
    output data,
    output data_not
);

    wire en = 1;
    wire t_not, w1, w2, d;
    not not_t(t_not, toggle);
    not not_q(data_not, data);

    and and1(w1, t_not, data);
    and and2(w2, toggle, data_not);
    or or1(d, w1, w2);

    dffe_ref dffe(
        .d      (d),
        .clk    (clock),
        .q      (data),
        .en     (en),
        .clr    (clear));

endmodule