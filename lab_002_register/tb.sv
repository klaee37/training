`timescale 1ns/1ps

module tb
# (
    parameter CLK_FREQ_KHZ = 1000,
    parameter SCK_FREQ_KHZ = 100
)
();
    localparam CLK_PERIOD_NS = 1e9/(CLK_FREQ_KHZ * 1e3);
    localparam SCK_PERIOD_NS = 1e9/(SCK_FREQ_KHZ * 1e3);

    initial
        check_freq: assert (CLK_FREQ_KHZ > SCK_FREQ_KHZ)
        else
            $error("   *** Assertion failed!. CLK_FREQ_KHZ must be larger than SCK_FREQ_KHZ");

    logic clk;
    logic reset;            // active high
    logic ssn;              // active low
    logic sck;
    logic sdi;
    logic sdo;
    logic [6:0] addr;
    logic [7:0] data_w;
    logic en_write;
    logic [7:0] data_r;
    logic en_read;

    logic is_fail;
    logic [7:0] tb_write_data;
    logic [7:0] tb_read_data;
    logic [11:0] tb_status;

    // reg addr : 0x00
    logic [7:0] CONFIG_0;

    // reg addr : 0x01
    logic [2:0] CONFIG_1;
    logic EN_0;

    // reg addr : 0x02
    logic [7:0] STATUS_0;

    // reg addr : 0x03
    logic EN_1;
    logic [2:0] STATUS_2;
    logic STATUS_1;
    
    spi i_spi (.*);
    register i_register (.*);

    initial
    begin
        is_fail = 0;
        ssn = 1'b1;
        sck = 1'b0;
        sdi = 1'b0;
        Reset();

        STATUS_0 = 8'bXXXX_XXXX;
        STATUS_1 = 1'bX;
        STATUS_2 = 3'bXXX;

        $display("=============================");
        $display("   Register Reset Value");
        $display("=============================");
        $display("   CONFIG_0");
        test(CONFIG_0, 8'h00, 8);

        $display("\n   EN_0");
        test(EN_0, 1'b1, 1);

        $display("\n   CONFIG_1");
        test(CONFIG_1, 3'h5, 3);

        $display("\n   EN_1");
        test(EN_1, 1'b1, 1);

        $display("");
        $display("=============================");
        $display("   Read Reset Vaue via SPI");
        $display("=============================");
        spi_read(7'h00, tb_read_data);
        test(tb_read_data, 8'h00, 8);

        $display("");
        spi_read(7'h01, tb_read_data);
        test(tb_read_data, 8'h51, 8);

        $display("");
        spi_read(7'h02, tb_read_data);
        test(tb_read_data, 8'bXXXX_XXXX, 8);

        $display("");
        spi_read(7'h03, tb_read_data);
        test(tb_read_data, 8'b10XX_X00X, 8);

        $display("");
        Reset();
        for (int ii = 0; ii <= 8; ii = ii + 1)
        begin
            if (ii == 8)
                tb_write_data = 8'b00;
            else
                tb_write_data = {8{1 << ii}};

            $display("=============================");
            spi_write(8'h00, tb_write_data);
            $display("=============================");

            $display("   CONFIG_0");
            test(CONFIG_0, tb_write_data, 8);

            $display("\n   EN_0");
            test(EN_0, 1'b1, 1);

            $display("\n   CONFIG_1");
            test(CONFIG_1, 3'h5, 3);

            $display("\n   EN_1");
            test(EN_1, 1'b1, 1);
        end

        $display("");
        Reset();
        for (int ii = 0; ii <= 8; ii = ii + 1)
        begin
            if (ii == 8)
                tb_write_data = 8'b00;
            else
                tb_write_data = {8{1 << ii}};

            $display("=============================");
            spi_write(8'h01, tb_write_data);
            $display("=============================");
            $display("   CONFIG_0");
            test(CONFIG_0, 8'h00, 8);

            $display("\n   EN_0");
            test(EN_0, tb_write_data[0], 1);

            $display("\n   CONFIG_1");
            test(CONFIG_1, tb_write_data[6:4], 3);

            $display("\n   EN_1");
            test(EN_1, 1'b1, 1);
        end

        $display("");
        Reset();
        for (int ii = 0; ii <= 8; ii = ii + 1)
        begin
            if (ii == 8)
                tb_write_data = 8'b00;
            else
                tb_write_data = {8{1 << ii}};

            $display("=============================");
            spi_write(8'h02, tb_write_data);
            $display("=============================");

            $display("   CONFIG_0");
            test(CONFIG_0, 8'h00, 8);

            $display("\n   EN_0");
            test(EN_0, 1'b1, 1);

            $display("\n   CONFIG_1");
            test(CONFIG_1, 3'h5, 3);

            $display("\n   EN_1");
            test(EN_1, 1'b1, 1);
        end

        $display("");
        Reset();
        for (int ii = 0; ii <= 8; ii = ii + 1)
        begin
            if (ii == 8)
                tb_write_data = 8'b00;
            else
                tb_write_data = {8{1 << ii}};

            $display("=============================");
            spi_write(8'h03, tb_write_data);
            $display("=============================");

            $display("   CONFIG_0");
            test(CONFIG_0, 8'h00, 8);

            $display("\n   EN_0");
            test(EN_0, 1'b1, 1);

            $display("\n   CONFIG_1");
            test(CONFIG_1, 3'h5, 3);

            $display("\n   EN_1");
            test(EN_1, tb_write_data[7], 1);
        end

        $display("");
        Reset();
        for (int ii = 0; ii <= 12; ii = ii + 1)
        begin
            if (ii == 12)
                tb_status = 0;
            else
                tb_status = 1 << ii;

            STATUS_0 = tb_status[7:0];
            STATUS_1 = tb_status[8];
            STATUS_2 = tb_status[11:9];

            $display("=============================");
            $display("   Read Status for ii = %0d", ii);
            $display("=============================");
            spi_read(7'h00, tb_read_data);
            test(tb_read_data, 8'h00, 8);

            $display("");
            spi_read(7'h01, tb_read_data);
            test(tb_read_data, 8'h51, 8);

            $display("");
            spi_read(7'h02, tb_read_data);
            test(tb_read_data, tb_status[7:0], 8);

            $display("");
            spi_read(7'h03, tb_read_data);
            test(tb_read_data, {2'b10, tb_status[11:9], 2'b00, tb_status[8]}, 8);
        end

        #SCK_PERIOD_NS;
        $finish;
    end

    task spi_write;
        input [6:0] addr;
        input [7:0] data;
    begin
        logic [15:0] sdi_reg;
        real current_time;
        string str;
        
        current_time = $realtime / 1e6;
        sdi_reg = {1'b0, addr, data};
        ssn = 1'b1;
        sck = 1'b0;
        sdi = 1'b0;

        #SCK_PERIOD_NS;
        ssn = 1'b0;

        for (int ii = 0; ii < 16; ii = ii + 1)
        begin
            sdi = sdi_reg[15];
            #(SCK_PERIOD_NS/2);
            sck = 1'b1;
            #(SCK_PERIOD_NS/2);
            sck = 1'b0;
            sdi_reg = {sdi_reg[14:0], 1'b0};
        end

        $sformat(str, "%04b_%04b", data[7:4], data[3:0]);
        $display("   spi_write(h%02X, b%s)", addr, str.toupper());

        #(SCK_PERIOD_NS/2);
        ssn = 1'b1;
        #SCK_PERIOD_NS;
    end
    endtask

    task spi_read;
        input [6:0] addr;
        output [7:0] data;
    begin
        logic [15:0] sdi_reg;
        logic [7:0] read_data_temp;
        real current_time;
        string str;
        
        current_time = $realtime / 1e6;
        sdi_reg = {1'b1, addr, 8'h00};
        ssn = 1'b1;
        sck = 1'b0;
        sdi = 1'b0;

        #SCK_PERIOD_NS;
        ssn = 1'b0;

        for (int ii = 0; ii < 16; ii = ii + 1)
        begin
            sdi = sdi_reg[15];
            #(SCK_PERIOD_NS/2);
            sck = 1'b1;
            read_data_temp = {read_data_temp[6:0], sdo};
            #(SCK_PERIOD_NS/2);
            sck = 1'b0;
            sdi_reg = {sdi_reg[14:0], 1'b0};
        end

        data = read_data_temp;
        
        $sformat(str, "%04b_%04b", data[7:4], data[3:0]);
        $display("   spi_read(h%02X) -> b%s", addr, str.toupper());
        
        #(SCK_PERIOD_NS/2);
        ssn = 1'b1;
        #SCK_PERIOD_NS;
    end
    endtask

    task test;
        input logic [7:0] actual_data;
        input logic [7:0] expected_data;
        input integer bit_num;
    begin
        string str_t;
        string str_a;
        string str_e;

        str_a = "";
        str_e = "";
  
        for (int ii = 0; ii < bit_num; ii = ii + 1)
        begin
            if (ii == 4) begin
                str_a = {"_", str_a};
                str_e = {"_", str_e};
            end

            $sformat(str_t, "%01b", actual_data[ii]);
            str_a = {str_t, str_a};

            $sformat(str_t, "%01b", expected_data[ii]);
            str_e = {str_t, str_e};
        end

        if (actual_data === expected_data)
        begin
            $display("   %.3fms actual = b%s, expected = b%s : PASS", $realtime/1e6, str_a.toupper(), str_e.toupper());
        end else
        begin
            is_fail = 1;
            #SCK_PERIOD_NS;
            $display("   %.3fms actual = b%s, expected = b%s : FAIL", $realtime/1e6, str_a.toupper(), str_e.toupper());
            $finish;
        end
    end
    endtask

    task Reset();
        reset = 1'b1;
        @(posedge clk);
        @(negedge clk);
        reset = 1'b0;
    endtask

    initial
    begin
        clk = 0;
        forever begin
            #(CLK_PERIOD_NS/2);
            clk = ~clk;
        end
    end

    initial
    begin
        $dumpfile("sim.vcd");
        $dumpvars(0);
    end

    final
    begin
        if (is_fail)
        begin
$display("");
$display("=========================================="); $display("  $$$$$$$$\\  $$$$$$\\  $$$$$$\\ $$\\    "); $display("  $$  _____|$$  __$$\\ \\_$$  _|$$ |      ");
$display("  $$ |      $$ /  $$ |  $$ |  $$ |      "); $display("  $$$$$\\    $$$$$$$$ |  $$ |  $$ |      "); $display("  $$  __|   $$  __$$ |  $$ |  $$ |      ");
$display("  $$ |      $$ |  $$ |  $$ |  $$ |      "); $display("  $$ |      $$ |  $$ |$$$$$$\\ $$$$$$$$\\ "); $display("  \\__|      \\__|  \\__|\\______|\\________|");
$display("==========================================");
        end else
        begin
$display("=========================================="); $display("  $$$$$$$\\   $$$$$$\\   $$$$$$\\   $$$$$$\\  ");$display("  $$  __$$\\ $$  __$$\\ $$  __$$\\ $$  __$$\\ ");
$display("  $$ |  $$ |$$ /  $$ |$$ /  \\__|$$ /  \\__|");$display("  $$$$$$$  |$$$$$$$$ |\\$$$$$$\\  \\$$$$$$\\  "); $display("  $$  ____/ $$  __$$ | \\____$$\\  \\____$$\\ ");
$display("  $$ |      $$ |  $$ |$$\\   $$ |$$\\   $$ |"); $display("  $$ |      $$ |  $$ |\\$$$$$$  |\\$$$$$$  |");$display("  \\__|      \\__|  \\__| \\______/  \\______/ "); 
$display("==========================================");
        end
    end

endmodule
