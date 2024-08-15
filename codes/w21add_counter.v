
module w21add_counter(clk,w21ra_rst,adv,W21ra);
    input clk,w21ra_rst,adv;
    output reg [8:0]W21ra;
    wire [8:0]W21ra_next;
    assign W21ra_next=W21ra+1;
    always@(posedge clk)begin 
        if(w21ra_rst)
            W21ra<=1;
        else if(adv)
            W21ra<=W21ra_next;
        else
            W21ra<=W21ra;
    end
endmodule