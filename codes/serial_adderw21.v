
module  serial_adderw21 (clk,rst,w21_mul,count,up_sum,in,out);
    input clk,rst,w21_mul;
    input [8:0]count;
    input [4:0]up_sum;
    input signed [15:0]in;
    output reg [15:0]out;

    reg signed[15:0]sum; //no need of signed keyword. since sign extension is not required as the input and output sizes are same 
    wire signed [15:0]sum_next;
    wire [15:0]out_next;
    assign sum_next=w21_mul?sum+in:sum;
    assign out_next=(count==420)?sum:out;
    always@(posedge clk)//rst or count
        if(rst)
            sum<=0;
        else if(up_sum==17)
            sum<=sum_next;
    always@(posedge clk)
        out<=out_next;
endmodule