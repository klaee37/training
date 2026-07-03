module synchronizer
# (
    parameter WIDTH = 1, // bit number of in, out
    parameter DEPTH = 2, // number of Flipflop stage
    parameter RESET_VAL = 1'b0
)
(
    input wire clk,
    input wire reset,
    input wire [WIDTH-1:0] in,
    output wire [WIDTH-1:0] out
);
    reg [WIDTH-1:0] sync_reg [0:DEPTH-1];
    reg [WIDTH-1:0] sync_reg_next [0:DEPTH-1];
    integer ii;

    always @(*)
    begin
        sync_reg_next[0] = in;

        for (ii = 1; ii < DEPTH; ii = ii + 1)
            sync_reg_next[ii] <= sync_reg[ii-1];
    end

    always @(posedge clk or posedge reset)
    begin
        if (reset)
            for (ii = 0; ii < DEPTH; ii = ii + 1)
                sync_reg[ii] <= {WIDTH{RESET_VAL}};
        else
            for (ii = 0; ii < DEPTH; ii = ii + 1)
                sync_reg[ii] <= sync_reg_next[ii];
    end

    assign out = sync_reg[DEPTH-1];

endmodule
