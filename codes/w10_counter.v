
module w10_counter(clk,W10ra_rst,adv,W10ra);
    input clk,W10ra_rst,adv;
    output reg [7:0]W10ra;
    wire [7:0]W10ra_next;
    assign W10ra_next=W10ra+1;
    always@(posedge clk)begin //Products counter : MOD-256
        if(W10ra_rst)begin
            W10ra<=0;
        end
        else if(adv)
            W10ra<=W10ra_next;//increment it based on multiplier delay
        else
            W10ra<=0;
    end
endmodule