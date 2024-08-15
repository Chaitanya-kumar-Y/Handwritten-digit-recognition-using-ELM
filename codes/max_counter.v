module max_counter(clk,max_rst,adv,max_cnt);
    input clk,max_rst,adv;
    output reg [3:0]max_cnt;
    wire [3:0]max_next;
    assign max_next=max_cnt+1;
    always@(posedge clk)begin 
        if(max_rst)
            max_cnt<=0;
        else if(adv)
            max_cnt<=max_next;
        else
            max_cnt<=0;
    end
endmodule