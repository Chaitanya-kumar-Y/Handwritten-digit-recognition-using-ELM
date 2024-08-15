

module din_load_counter (clk,rst,adv,out);
    input clk,rst,adv;
    output reg [7:0]out;

    wire [7:0]out_next;
    assign out_next=out+1;
    always@(posedge clk)begin
        if(rst)
            out<=0;
        else
            out<=out_next;
    end
endmodule