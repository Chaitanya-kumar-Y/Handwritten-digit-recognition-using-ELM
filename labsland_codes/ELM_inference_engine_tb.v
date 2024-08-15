

/* -----------------------------------------------------*/




module ELM_inference_engine_tb(CLOCK_50,SW,LEDR,LEDG,HEX0,HEX1,HEX4,HEX5);
    input CLOCK_50;
input [1:0] SW;
// input [3:0] KEY;
output reg [3:0] LEDR;
output reg [3:0] LEDG;
output reg [6:0] HEX0,HEX4;
output  [6:0] HEX1,HEX5;
    parameter input_cnt=10;
    // If rst = 1-->system will reset, if start=1 (rst=0): testing process starts,  
   wire rst,start;
    reg din; //Test input
    reg din_valid; //If din_valid = 1 : Test Data which is to fed is still available ; else : Test_data = 0 : No test data to process (System remains idle) : state7    
    wire give_input; // Input is fed into the ELM inference engine if give_input=1 
    wire [3:0]hw_digit;//Decimal output
    wire output_valid; //Output is valid if output_valid = 1
     wire clk;
    //Instantiating Inference engine
    ELM_inference_engine dm1(CLOCK_50,rst,start,din,din_valid,give_input,hw_digit,output_valid);   
    //ELM_inference_engine dm1(CLOCK_50,rst,start, , , ,hw_digit,output_valid);
    //initializing
    initial begin
        din_valid=1;
    end
    
     assign rst = ~ SW[1];
     assign start = SW[0];
 always @(*) LEDR[3] = clk ;

    
    integer input_part,input_index,out_disp;
     reg [3:0]success;
    wire [1:256]X_test[1:input_cnt];  
    wire [3:0]Ytest_input[1:input_cnt];//Test outputs from "Y_test.txt" file : for comparison
    reg [3:0]Ytest_predict[1:input_cnt];//decimal outputs of all the test inputs
    
    assign X_test[1] =256'b0000001111111100000001111000111000011110000001110011110000000111011110000000001111111000000000111111000000000011111100000000001111000000000000111100000000000111111000000000111011100000000011100110000000011100011110001111100000111111111000000001111110000000;
    assign X_test[2] =256'b0000000000000111000000000000111100000000001111000000000001111000000000011110000000000111111000000000111111000000001111111000000011111111000000000000111000000000000111000000000000111000000000000111000000000000011100000000000001100000000000000111000000000000;
    assign X_test[3] =256'b0111111100000000111000110000000011110011000000000011011100000000000001100000000000001110000000000000110000000000000110000000000000110000000000000111000000000000011000000000000001100000000000000110000000000000011000000000000001111111111111110001111111111000;
    assign X_test[4] =256'b1111111111111000000000000001100000000000000110000000000011110000000000111100000000000111100000000000111111111110000000000000001100000000000000110000000000000011000000000000011000000000000011100000000000111100000111000111000000011111111000000000111110000000;
    assign X_test[5] =256'b0000000000011111000000000011111000000000111110000000000111100000000000111000000000001111000000000001111000000000001110000000000001111000000000001110000000001100111111111111111011111111000011100000000000001110000000000000111000000000000011100000000000011110; 
    assign X_test[6] =256'b0000011111111100011111111000000011000000000000001100000000000000111000000000000001111000000000000001111100000000000000111111000000000000001111000000000000000111000000000000001100100000000000110111110000000011011111000000011100011111111111100000000001110000;
    assign X_test[7] =256'b0000000001111000000000001110000000000111110000000000111100000000000011100000000000111100000000000011100000000000011110000000000011111111111110001111000000111100111000000000111011100000000000111110000000000011111100000001111101111111111110000001111111100000;
    assign X_test[8] =256'b0000000000001111110000000011111001111111111110000011111101110000000000001110000000000000111000000000000111000000000000011000000000000011100000001111111111110000100001111111110000001110000011100000110000000000000011000000000000001100000000000000110000000000;
    assign X_test[9] =256'b0000011111111100000111110000111001111100000001110111100000000111001111000000111100011100000111100000111101111100000001111111000000111111110000000111111110000000111000011100000011000001111000001110000111100000011000011110000001111111110000000001111100000000;
    assign X_test[10]=256'b0011111110000000111110111111100011100000111111111100000000001111111000000011111111100000001111110111110000111111000111111111111000000111110011100000000000001110000000000000111100000000000001100000000000000111000000000000011100000000000001110000000000000111;
		 
	assign Ytest_input[1]=4'd0;
   assign  Ytest_input[2]=4'd1;
    assign Ytest_input[3]=4'd2;
   assign  Ytest_input[4]=4'd3;
    assign Ytest_input[5]=4'd4;
    assign Ytest_input[6]=4'd5;
    assign Ytest_input[7]=4'd6;
    assign Ytest_input[8]=4'd7;
    assign Ytest_input[9]=4'd8;
    assign Ytest_input[10]=4'd9;
    initial begin
        input_part=1;input_index=1;success=0;//initialize the X_test array indices
    end

    localparam log2_slow_down_factor = 25 ; // for labsland remote fpga ( Hz freq )
 //localparam log2_slow_down_factor = 2 ; // for modelsim simulation
 reg [log2_slow_down_factor-1 : 0] k_bit_counter = 0 ;

 assign clk = k_bit_counter[ log2_slow_down_factor-1 ] ;
 always @(posedge CLOCK_50) begin
	k_bit_counter = k_bit_counter + 1 ;
 end
 
 
always@(posedge CLOCK_50)begin
    if(rst == 1'b0 & start ==1'b1) begin
    LEDR[2] = rst;
    LEDR[1] = start;
        if(output_valid)begin //Indicates the Output of given test input vector is available
            if(hw_digit==Ytest_input[input_index])
                success=success+1;
            Ytest_predict[input_index]=hw_digit;//store decimal outputs
            input_index=input_index+1;input_part=1;//increasing the X_test array indices
        end
        
        if(input_index==input_cnt+1)begin //If all the test input vectors are given , then activate this signal : indicates there is No test input to process  
            din_valid=0;        
        end
        
        if(give_input)begin //pass the test input vector : if give_input=1 
            din=X_test[input_index][input_part];//send input part wise to design
            input_part=input_part+1;
        end
    end
end 
integer k;
initial k =0;
assign HEX5 = 7'b0001100;
assign HEX1 =7'b0001000;
always @(posedge clk)
begin  

case (Ytest_input[k]) //case statement
                        4'b0000 : HEX0 = 7'b1000000;//    
                        4'b0001 : HEX0 = 7'b1111001;//
                        4'b0010 : HEX0 = 7'b0100100;//
                        4'b0011 : HEX0 = 7'b0110000;//
                        4'b0100 : HEX0 = 7'b0011001;//
                        4'b0101 : HEX0 = 7'b0010010;//
                        4'b0110 : HEX0 = 7'b0000010;
                        4'b0111 : HEX0 = 7'b1111000;
                        4'b1000 : HEX0 = 7'b0000000;
                        4'b1001 : HEX0 = 7'b0010000;
                        4'b1010 : HEX0 = 7'b0001000;
                        4'b1011 : HEX0 = 7'b0000011;
                        4'b1100 : HEX0 = 7'b1000110;
                        4'b1101 : HEX0 = 7'b0100001;
                        4'b1110 : HEX0 = 7'b0000110;
                        4'b1111 : HEX0 = 7'b0001110;
                        default : HEX0 = 7'b0111111;
endcase
case (Ytest_predict[k]) //case statement
                        4'b0000 : HEX4 = 7'b1000000;//    
                        4'b0001 : HEX4 = 7'b1111001;//
                        4'b0010 : HEX4 = 7'b0100100;//
                        4'b0011 : HEX4 = 7'b0110000;//
                        4'b0100 : HEX4 = 7'b0011001;//
                        4'b0101 : HEX4 = 7'b0010010;//
                        4'b0110 : HEX4 = 7'b0000010;
                        4'b0111 : HEX4 = 7'b1111000;
                        4'b1000 : HEX4 = 7'b0000000;
                        4'b1001 : HEX4 = 7'b0010000;
                        4'b1010 : HEX4 = 7'b0001000;
                        4'b1011 : HEX4 = 7'b0000011;
                        4'b1100 : HEX4 = 7'b1000110;
                        4'b1101 : HEX4 = 7'b0100001;
                        4'b1110 : HEX4 = 7'b0000110;
                        4'b1111 : HEX4 = 7'b0001110;
                        default : HEX4 = 7'b0111111;
endcase

LEDG[3:0] = success;
	if (k < 16)
		k =k+1; 
	else 
		k =0;
end
endmodule


/*---------------------------------------*/
