

module w10gen(clk,rst,start,seed,lfsr);
    input clk,rst,start;
    input [15:0]seed;
    output reg [15:0]lfsr;

    reg [16:1]r_LFSR;
    wire r_XNOR;    
    wire [15:0]lfsr_next;
    assign lfsr_next=(r_LFSR-32767)>>5;
    assign r_XNOR = r_LFSR[16] ^~ r_LFSR[15] ^~ r_LFSR[13] ^~ r_LFSR[4];
    always @(posedge clk)
        if(rst)begin
            r_LFSR<={seed[14:0],seed[15]^~seed[14]^~seed[12]^~seed[3]};
            lfsr<=(seed-32767)>>5;
         end
        else if(start)begin
            r_LFSR <= {r_LFSR[15:1], r_XNOR};
            lfsr<=lfsr_next;
        end
endmodule
