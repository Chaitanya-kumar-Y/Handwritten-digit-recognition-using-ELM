
module w10loop_counter(clk,W10loop_rst,adv,W10loop);
    input clk,W10loop_rst,adv;
    output reg [5:0]W10loop;
    wire [5:0]W10loop_next;
    assign W10loop_next=W10loop+1;
    always@(posedge clk)begin //Products counter : MOD-256
        if(W10loop_rst)begin
            W10loop<=1;
        end
        else if(adv)
            W10loop<=W10loop_next;//increment it based on multiplier delay
        else
            W10loop<=W10loop;
    end
endmodule