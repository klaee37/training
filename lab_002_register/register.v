module register
(
    input wire clk,
    input wire reset,   // active high
    input wire [6:0] addr,
    input wire [7:0] data_w,
    input wire en_write,
    output reg [7:0] data_r,
    input wire en_read,

    // reg addr : 0x00
    output reg [7:0] CONFIG_0,

    // reg addr : 0x01
    output reg [2:0] CONFIG_1,
    output reg EN_0,

    // reg addr : 0x02
    input wire [7:0] STATUS_0,

    // reg addr : 0x03
    output reg EN_1,
    input wire [2:0] STATUS_2,
    input wire STATUS_1
);
    // Write Register Address : 0x00
    reg [7:0] config_0_next;

    always @(*)
    begin
        if (en_write && (addr == 7'h00))
            config_0_next = data_w; 
        else
            config_0_next = CONFIG_0;
    end

    always @(posedge clk or posedge reset)
    begin
        if (reset)
            CONFIG_0 <= 8'b00;
        else
            CONFIG_0 <= config_0_next;
    end

    // Write Register Address : 0x01
    reg EN_0_next;
    reg [2:0] config_1_next;

    always @(*)
    begin
        if (en_write && (addr == 7'h01))
        begin
            config_1_next = data_w[2:0];
            EN_0_next = data_w[7];
        end else
        begin
            config_1_next = CONFIG_1;
            EN_0_next = EN_0;
        end
    end

    always @(posedge clk or posedge reset)
    begin
        if (reset)
        begin
            CONFIG_1 <= 3'b000;
            EN_0 <= 1'b0;
        end else
        begin
            CONFIG_1 <= config_1_next;
            EN_0 <= EN_0_next;
        end
    end

    // Write Register Address : 0x03
    reg EN_1_next;

    always @(*)
    begin
        if (en_write && (addr == 7'h02))
        begin
            EN_1_next = data_w[0];
        end else
        begin
            EN_1_next = EN_0;
        end
    end

    always @(posedge clk or posedge reset)
    begin
        if (reset)
        begin
            EN_1 <= 1'b0;
        end else
        begin
            EN_1 <= EN_0_next;
        end
    end

    // Read
    reg [7:0] data_r_next;

    always @(*)
    begin
        if (en_read)
            case (addr)
                7'h00 : data_r_next = CONFIG_0;
                7'h01 : data_r_next = {EN_0, {3{1'b0}}, CONFIG_1, 1'b1};
                7'h02 : data_r_next = STATUS_0;
                7'h03 : data_r_next = {STATUS_1, {2{1'b0}}, STATUS_2, 1'b0, EN_0};
                default : data_r_next = 8'h00;
            endcase
        else
            data_r_next = data_r;
    end

    always @(posedge clk or posedge reset)
    begin
        if (reset)
            data_r <= 8'h00;
        else
            data_r <= data_r_next;
    end

endmodule
