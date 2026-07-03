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
    logic reset_button_n;   // active low
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
    logic [6:0] tb_addr;
    logic [7:0] tb_write_data;
    logic [7:0] tb_read_data;
    logic [34:0] sdo_reg;
    
    dut i_dut
    (
        .clk,
        .reset_button_n,
        .ssn,
        .sck,
        .sdi,
        .sdo,
        .addr,
        .data_w,
        .en_write,
        .data_r,
        .en_read
    );

    register i_register
    (
        .clk,
        .addr,
        .data_w,
        .en_write,
        .data_r,
        .en_read
    );

    initial
    begin
        is_fail = 0;
        ssn = 1'b1;
        sck = 1'b0;
        sdi = 1'b0;
        reset_button_n = 1'b0;
        @(posedge clk);
        @(negedge clk)
        reset_button_n = 1'b1;

        tb_addr = 7'h55;
        tb_write_data = 8'hAA;
        spi_write(tb_addr, tb_write_data);
        test_mem(tb_addr, tb_write_data);
        spi_read(tb_addr, tb_read_data);
        test_mem(tb_addr, tb_read_data);
        $display("");

        tb_addr = 7'h69;
        tb_write_data = 8'h96;
        spi_write(tb_addr, tb_write_data);
        test_mem(tb_addr, tb_write_data);
        spi_read(tb_addr, tb_read_data);
        test_mem(tb_addr, tb_read_data);
        $display("");

        tb_addr = 7'h55;
        tb_write_data = 8'hE1;
        spi_write_no_ssn(tb_addr, tb_write_data);
        test_mem(tb_addr, 8'hAA);
        spi_read_no_ssn(tb_addr, tb_read_data);

        for (int kk = 0; kk < 7; kk = kk + 1)
        begin
            tb_addr = 1 << kk;
            for (int ii = 0; ii < 8; ii = ii + 1)
            begin
                tb_write_data = ~(1 << ii);
                spi_write(tb_addr, tb_write_data);
                test_mem(tb_addr, tb_write_data);
                spi_read(tb_addr, tb_read_data);
                test_mem(tb_addr, tb_read_data);
                $display("");
            end
        end

        for (int ii = 0; ii < 8; ii = ii + 1)
        begin
            tb_addr = 1 << ii;
            tb_write_data = 8'h80 >> ii;
            spi_write(tb_addr, tb_write_data);
            test_mem(tb_addr, tb_write_data);
            $display("");
        end
        
        for (int ii = 0; ii < 8; ii = ii + 1)
        begin
            tb_addr = 1 << ii;
            spi_read(tb_addr, tb_read_data);
            test_mem(tb_addr, 8'h80 >> ii);
            $display("");
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
        
        sdo_reg = '0;
        sdo_reg[0] = sdo;
        current_time = $realtime / 1e6;
        sdi_reg = {1'b0, addr, data};
        ssn = 1'b1;
        sck = 1'b0;
        sdi = 1'b0;

        #SCK_PERIOD_NS;
        ssn = 1'b0;
        sdo_reg[1] = sdo;

        for (int ii = 0; ii < 16; ii = ii + 1)
        begin
            sdi = sdi_reg[15];
            #(SCK_PERIOD_NS/2);
            sck = 1'b1;
            sdo_reg[2 + (2*ii)] = sdo;
            #(SCK_PERIOD_NS/2);
            sck = 1'b0;
            sdi_reg = {sdi_reg[14:0], 1'b0};
            sdo_reg[3 + (2*ii)] = sdo;
        end

        $display("   %.3f ms - spi_write addr = 0x%02X, data = 0x%02X", current_time, addr, data);

        #(SCK_PERIOD_NS/2);
        sdo_reg[34] = sdo;
        ssn = 1'b1;
        #SCK_PERIOD_NS;

        if ((|sdo_reg) && ~(&sdo_reg))
        begin
            is_fail = 1;
            #SCK_PERIOD_NS;
            $display("   %.3f ms - WARNING : sdo should not be changed during spi_write.", current_time);
            $finish;
        end
    end
    endtask

    task spi_write_no_ssn;
        input [6:0] addr;
        input [7:0] data;
    begin
        logic [15:0] sdi_reg;
        real current_time;
        
        sdo_reg = '0;
        sdo_reg[0] = sdo;
        current_time = $realtime / 1e6;
        sdi_reg = {1'b0, addr, data};
        ssn = 1'b1;
        sck = 1'b0;
        sdi = 1'b0;

        #SCK_PERIOD_NS;
        ssn = 1'b1;
        sdo_reg[1] = sdo;

        for (int ii = 0; ii < 16; ii = ii + 1)
        begin
            sdi = sdi_reg[15];
            #(SCK_PERIOD_NS/2);
            sck = 1'b1;
            sdo_reg[2 + (2*ii)] = sdo;
            #(SCK_PERIOD_NS/2);
            sck = 1'b0;
            sdi_reg = {sdi_reg[14:0], 1'b0};
            sdo_reg[3 + (2*ii)] = sdo;
        end

        $display("   %.3f ms - spi_write_no_ssn addr = 0x%02X, data = 0x%02X", current_time, addr, data);

        #(SCK_PERIOD_NS/2);
        sdo_reg[34] = sdo;
        ssn = 1'b1;
        #SCK_PERIOD_NS;

        if ((|sdo_reg) && ~(&sdo_reg))
        begin
            is_fail = 1;
            #SCK_PERIOD_NS;
            $display("   %.3f ms - sdo should not be changed during spi_write : FAIL", current_time);
            $finish;
        end
    end
    endtask

    task spi_read;
        input [6:0] addr;
        output [7:0] data;
    begin
        logic [15:0] sdi_reg;
        logic [7:0] read_data_temp;
        real current_time;
        
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
        $display("   %.3f ms - spi_read  addr = 0x%02X, data = 0x%02X", current_time, addr, data);
        
        #(SCK_PERIOD_NS/2);
        sdo_reg[34] = sdo;
        ssn = 1'b1;
        #SCK_PERIOD_NS;
    end
    endtask

    task spi_read_no_ssn;
        input [6:0] addr;
        output [7:0] data;
    begin
        logic [15:0] sdi_reg;
        logic [7:0] read_data_temp;
        real current_time;
        
        sdo_reg = '0;
        sdo_reg[0] = sdo;
        current_time = $realtime / 1e6;
        sdi_reg = {1'b1, addr, 8'h00};
        ssn = 1'b1;
        sck = 1'b0;
        sdi = 1'b0;

        #SCK_PERIOD_NS;
        ssn = 1'b1;
        sdo_reg[1] = sdo;

        for (int ii = 0; ii < 16; ii = ii + 1)
        begin
            sdi = sdi_reg[15];
            #(SCK_PERIOD_NS/2);
            sck = 1'b1;
            read_data_temp = {read_data_temp[6:0], sdo};
            sdo_reg[2 + (2*ii)] = sdo;
            #(SCK_PERIOD_NS/2);
            sck = 1'b0;
            sdi_reg = {sdi_reg[14:0], 1'b0};
            sdo_reg[3 + (2*ii)] = sdo;
        end

        data = read_data_temp;
        $display("   %.3f ms - spi_read_no_ssn  addr = 0x%02X, data = 0x%02X", current_time, addr, data);
        
        #(SCK_PERIOD_NS/2);
        ssn = 1'b1;
        #SCK_PERIOD_NS;

        if ((|sdo_reg) && ~(&sdo_reg))
        begin
            is_fail = 1;
            #SCK_PERIOD_NS;
            $display("   %.3f ms - sdo should not be changed during spi_read_no_ssn : FAIL", current_time);
            $finish;
        end
    end
    endtask

    task test_mem;
        input [6:0] addr;
        input [7:0] expected_data;
    begin
        if (tb.i_register.mem[addr] === expected_data)
        begin
            $display("   %.3f ms - test_mem  addr = 0x%02X, expected = 0x%02X, actual = 0x%02X : PASS", $realtime/1e6, addr, expected_data, tb.i_register.mem[addr]);
        end else
        begin
            is_fail = 1;
            #SCK_PERIOD_NS;
            $display("   %.3f ms - test_mem  addr = 0x%02X, expected = 0x%02X, actual = 0x%02X : FAIL", $realtime/1e6, addr, expected_data, tb.i_register.mem[addr]);
            $finish;
        end
    end
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
