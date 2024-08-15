

/*
Number of test input vectors : Given by the user (test bench)--> 10 test vectors for project submission

Input Layer nodes =256
Hidden layer nodes =420
Output layer nodes = 10
size(w10) = 256*420 : 16 bit wide
size(w21) = 420*10 : 16 bit wide


S0:reset state
S1:Load the input vector : 1 bit at a time (to reduce the number of input pins (So input data will be loaded in 256 clock cycles)
S2:First stage multiplication,serial addiotion and ReLU function passing
S3:store the 10 hidden layer outputs.go to state-4 if all the 420 hidden node outputs are available.
S4: start multiplication of second stage (hl_out*W21). Use 10 multpliers: produce the partial products of hidden node-1 and all the 10 output nodes.
    For each hidden it took 17 clock cyles. Use 10 serial addders to add these outputs for every 17th clock cycle and get the overall output at the
    end of 420*17 clock cycles.
S5: Final weighted sum (Ytest_hat) storing
S6: Fining maximum value among the 10 Ytest_hat outputs. Inputs are given one after the other and compares current one with the previous input. 
    By doing so,the final predicted decimal output will be available after 10 clock cycles.
S7:Idle state
*/



module ELM_inference_engine(clk ,rst,start,din,din_valid,give_input,hw_digit,output_valid);
    input clk,rst,start;//rst-->resets the system; start--> starts the inference
    input din;//Test input vector part (32 bits)--> overall input will be given in 8 clock cycles : to rdecrease the number of input pins
    input din_valid;//If din_valid = 1 : Test Data which is to fed is still available ; else : Test_data = 0 : No test data to process (System remains idle) : state7
    output give_input;// Input is fed into the ELM inference engine if give_input=1
    output [3:0]hw_digit;//Decimal output corresponding to the one-hot encoded output
    output output_valid;//Output is valid if output_valid = 1
    
    wire dload_done,start_w10mul,w10mulpart_done,w10mul_done,store_hlout,start_w21mul,w21mul_done,store_out,start_onehot;
    wire [2:0]pstate;
    datapath d1(clk,rst,start,give_input,din,dload_done,start_w10mul,w10mulpart_done,w10mul_done,store_hlout,start_w21mul,w21mul_done,store_out,start_onehot,hw_digit,output_valid,pstate);
    controlpath c1(clk,rst,start,din_valid,dload_done,give_input,start_w10mul,w10mulpart_done,w10mul_done,store_hlout,start_w21mul,w21mul_done,store_out,start_onehot,output_valid,pstate);
endmodule