module dut
(
    input wire clk,
    input wire reset_button_n,   // active low
    input wire ssn,              // active low
    input wire sck,
    input wire sdi,
    output wire sdo,
    output wire [6:0] addr,
    output wire [7:0] data_w,
    output wire en_write,
    input wire [7:0] data_r,
    output wire en_read
);
    wire reset;
    wire ssn_sync;
    wire sck_sync;
    wire sdi_sync;

    synchronizer #(.RESET_VAL(1'b1)) i_sync_reset
    (
        .clk        (clk),
        .reset      (!reset_button_n),
        .in         (1'b0),
        .out        (reset)     // asynchronous reset assert/synchronous reset deassert
    );

    synchronizer i_sync_sck
    (
        .clk        (clk),
        .reset      (reset),
        .in         (sck),
        .out        (sck_sync)
    );

    synchronizer #(.WIDTH(2), .DEPTH(3), .RESET_VAL(2'b10)) i_sync_ssn_sdi
    (
        .clk        (clk),
        .reset      (reset),
        .in         ({ssn, sdi}),
        .out        ({ssn_sync, sdi_sync})
    );

    spi i_spi
    (
        .clk        (clk),
        .reset      (reset),        // active high
        .ssn        (ssn_sync),     // active low
        .sck        (sck_sync),
        .sdi        (sdi_sync),
        .sdo        (sdo),
        .addr       (addr),
        .data_w     (data_w),
        .en_write   (en_write),
        .data_r     (data_r),
        .en_read    (en_read)
    );
endmodule
