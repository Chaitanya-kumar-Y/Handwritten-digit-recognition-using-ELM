
module onehot_encoder(clk,rst,start,count,in,hw_digit);
    input clk,rst,start;
    input signed[15:0]in;
    input [3:0]count;
    output reg [3:0]hw_digit;
    
    reg [15:0]max;
    reg [3:0]digit;
    wire max_up,digit_up;
    assign digit_up=((in>max)&(!in[15]));
    assign max_up=((in>max)&(!in[15]));
    reg start_pipe;
    always@(posedge clk)
        start_pipe<=start;
    always@(posedge clk)begin
        if(rst)begin
            max<=0;
        end
        else if(start_pipe) begin
            max<=max_up?in:max;
            digit<=digit_up?count-1:digit;
       end
       else
            max<=0;
    end
    always @(posedge clk)
        hw_digit<=(count==11)?digit:hw_digit;            
endmodule