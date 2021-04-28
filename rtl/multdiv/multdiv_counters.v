module multdiv_counters(
    input clock,
    input enable,
    input reset,
    output ovf16,
    output ovf32
);

    wire w1, w2, w3, w4, w5, w6, w7;

    wire clk_not;
    not clock_not(clk_not, clock);
    
    tff tff_0(
        .toggle     (enable), 
        .clock      (clk_not), 
        .clear      (reset),
        .data       (),
        .data_not   (w1));

    tff tff_1(
        .toggle     (enable), 
        .clock      (w1), 
        .clear      (reset),
        .data       (),
        .data_not   (w2));

    tff tff_2(
        .toggle     (enable), 
        .clock      (w2), 
        .clear      (reset),
        .data       (),
        .data_not   (w3));

    tff tff_3(
        .toggle     (enable), 
        .clock      (w3), 
        .clear      (reset),
        .data       (),
        .data_not   (w4));

    tff tff_4(
        .toggle     (enable), 
        .clock      (w4), 
        .clear      (reset),
        .data       (w5),
        .data_not   (w6));

    tff tff_5(
        .toggle     (enable), 
        .clock      (w6), 
        .clear      (reset),
        .data       (w7),
        .data_not   ());

    dffe_ref output16_dff(
        .q      (ovf16),
        .d      (w5),
        .clk    (clock),
        .en     (enable),
        .clr    (reset));

    dffe_ref output32_dff(
        .q      (ovf32),
        .d      (w7),
        .clk    (clock),
        .en     (enable),
        .clr    (reset));

endmodule