
module w21sa_counter(clk,W21sa_rst,W21sa_cnt);
    input clk,W21sa_rst;
    output reg [4:0]W21sa_cnt;
    wire [4:0]W21sa_cnt_next;
    assign W21sa_cnt_next=W21sa_cnt+1;
    always@(posedge clk)begin //Products counter : MOD-256
        if(W21sa_rst)
            W21sa_cnt<=1;
        else
            W21sa_cnt<=W21sa_cnt_next;//increment it based on multiplier delay
    end
endmodule
