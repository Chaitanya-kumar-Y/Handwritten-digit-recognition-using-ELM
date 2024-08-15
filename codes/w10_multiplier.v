module w10_multiplier(clk,start_mul,xt_i,w10_i,xt_w10_o);
    input clk,xt_i,start_mul;
    input [15:0]w10_i;
    output reg [15:0]xt_w10_o;
    always@(posedge clk)
        if(start_mul)
            xt_w10_o<=xt_i?w10_i:16'b0;
endmodule
