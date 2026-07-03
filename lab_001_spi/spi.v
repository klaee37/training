module spi
(
    input wire clk,
    input wire reset,   // active high
    input wire ssn,     // active low
    input wire sck,
    input wire sdi,
    output wire sdo,
    output reg [6:0] addr,
    output wire [7:0] data_w,
    output reg en_write,
    input wire [7:0] data_r,
    output reg en_read
);
    // *** Please modify the code only between start/stop comment blocks.

    //      ___                                                                                                    ___
    // SSn     |__________________________________________________________________________________________________|
    //             __    __    __    __    __    __    __    __    __    __    __    __    __    __    __    __   
    // SCK  ______^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |______           
    //             _  _________________________________________ _______________________________________________
    // SDI  ___| R/W |________________7-bit_address____________|_____________8-bit_data_to_write_______________|______
    //                                                          _______________________________________________
    // SDO  ___________________________________________________|_____________8-bit_data_to_read________________|______
    
    // ================================
    //    SPI mode 0 : Write Command
    // ================================
    //      ___                                                                                                    ___
    // SSn     |__________________________________________________________________________________________________|
    //             __    __    __    __    __    __    __    __    __    __    __    __    __    __    __    __   
    // SCK  ______^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |______           
    //
    // SDI  ______0__|  A6 |  A5 |  A4 |  A3 |  A2 |  A1 |  A0 |  W7 |  W6 |  W5 |  W4 |  W3 |  W2 |  W1 |  W0 |______
    //
    // SDO  __________________________________________________________________________________________________________
    
    // ================================
    //    SPI mode 0 : Read Command
    // ================================
    //      ___                                                                                                    ___
    // SSn     |__________________________________________________________________________________________________|
    //             __    __    __    __    __    __    __    __    __    __    __    __    __    __    __    __   
    // SCK  ______^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |__^  |______           
    //          _____   
    // SDI  ___|  1  |  A6 |  A5 |  A4 |  A3 |  A2 |  A1 |  A0 |______________________________________________________
    //
    // SDO  ___________________________________________________|  R7 |  R6 |  R5 |  R4 |  R3 |  R2 |  R1 |  R0 |______
    //   
    
    // ================================================
    // detect rising edge and falling edge of sck
    // ================================================
    reg sck_prev, sck_prev_d;
    wire sck_posedge;
    wire sck_negedge;

    always @(*)
    begin
        if (ssn)
            sck_prev_d = 1'b0;
        else
            sck_prev_d = sck;
    end

    always @(posedge clk, posedge reset)
    begin
        if (reset)
            sck_prev <= 1'b0;
        else
            sck_prev <= sck_prev_d;
    end

    // start to fix combination logic : sck_posedge
    assign sck_posedge = 1'b0;
    // end : sck_posedge

    // start to fix combination logic : sck_negedge
    assign sck_negedge = 1'b0;
    // end : sck_negedge

    // ================================================
    // bit counter
    // ================================================
    reg [4:0] counter, counter_next;

    always @(*)
    begin
        // start to fix combination logic : counter_next
        counter_next = counter;
        // end : counter_next
    end

    always @(posedge clk or posedge reset)
    begin
        if (reset)
            counter <= 5'h00;
        else
            counter <= counter_next;
    end

    // ================================================
    // Read/Write bit
    // ================================================
    reg rw_bit, rw_bit_next; // rw_bit = 1 -> read, rw_bit = 0 -> write
    
    always @(*)
    begin
        // start to fix combination logic : rw_bit_next
        rw_bit_next = rw_bit;
        // end : rw_bit_next
    end

    always @(posedge clk or posedge reset)
    begin
        if (reset)
            rw_bit <= 1'b0;
        else
            rw_bit <= rw_bit_next;
    end

    // ================================================
    // en_write
    // ================================================
    reg en_write_next;

    always @(*)
    begin
        // start to fix combination logic : en_write_next
        en_write_next = en_write;
        // end : en_write_next
    end

    always @(posedge clk or posedge reset)
    begin
        if (reset)
            en_write <= 1'b0;
        else
            en_write <= en_write_next;
    end

    // ================================================
    // en_read
    // ================================================
    reg en_read_next;

    always @(*)
    begin
        // start to fix combination logic : en_read_next
        en_read_next = en_read;
        // end : en_read_next
    end

    always @(posedge clk or posedge reset)
    begin
        if (reset)
            en_read <= 1'b0;
        else
            en_read <= en_read_next;
    end

    // ================================================
    // shift_in from sdi
    // ================================================
    reg [15:0] shift_in, shift_in_next;

    always @(*)
    begin
        // start to fix combination logic : shift_in_next
        shift_in_next = shift_in;
        // end : shift_in_next
    end

    always @(posedge clk or posedge reset)
    begin
        if (reset)
            shift_in <= 16'h0000;
        else
            shift_in <= shift_in_next;
    end

    // ================================================
    // address
    // ================================================
    reg [6:0] addr_next;

    always @(*)
    begin
        // start to fix combination logic : addr_next
        addr_next = addr;
        // end : addr_next
    end

    always @(posedge clk or posedge reset)
    begin
        if (reset)
            addr <= 7'h00;
        else
            addr <= addr_next;
    end

    // ================================================
    // data_w
    // ================================================
    // start to fix combination logic : data_w
    assign data_w = shift_in[15:8];
    // end : data_w

    // ================================================
    // shift_out to sdo
    // ================================================
    reg [7:0] shift_out, shift_out_next;

    always @(*)
    begin
        // start to fix combination logic : shift_out_next
        shift_out_next = shift_out;
        // end : shift_out_next
    end

    always @(posedge clk or posedge reset)
    begin
        if (reset)
            shift_out <= 16'h0000;
        else
            shift_out <= shift_out_next;
    end

    // start to fix combination logic : sdo
    assign sdo = shift_out[0];
    // end : sdo

endmodule
