module register
(
    input logic clk,
    input logic [6:0] addr,
    input logic [7:0] data_w,
    input logic en_write,
    output logic [7:0] data_r,
    input logic en_read
);
    logic [7:0] mem [0:127];

    initial
    begin
        data_r = 8'h00;

        forever begin
            @(posedge clk);
            if (en_write)
                mem[addr] <= data_w;
            else if (en_read)
                data_r <= mem[addr];
        end
    end

endmodule
