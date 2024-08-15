
module  serial_adderw10 (clk,rst,start_w10sum,count,in,out);
    input clk,rst,start_w10sum;
    input [7:0]count;
    input signed [15:0]in;
    output reg [23:0]out;

    reg signed[23:0]sum; 
    wire signed [23:0]sum_next,out_next;
    assign sum_next=start_w10sum?sum+{{8{in[15]}},in}:sum;
    assign out_next=(count==255)?sum:out;
    always@(posedge clk)begin//rst or count
        if(rst)begin
            sum<=0;out<=0;
         end
        else
            sum<=sum_next;
        out<=out_next;            
    end
endmodule