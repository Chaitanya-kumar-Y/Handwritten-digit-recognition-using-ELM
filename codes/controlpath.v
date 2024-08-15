
module controlpath(clk,rst,start,xtest_in_valid,dload_done,start_dload,start_w10mul,w10mulpart_done,w10mul_done,store_hlout,start_w21mul,w21mul_done,store_out,start_onehot,output_valid,pstate);
    input clk,rst,start,xtest_in_valid,dload_done,w10mulpart_done,w10mul_done,w21mul_done,output_valid;
    output reg start_dload,start_w10mul,store_hlout,start_w21mul,store_out,start_onehot;
    parameter S0=0,S1=1,S2=2,S3=3,S4=4,S5=5,S6=6,S7=7;
    
    output [2:0]pstate;
    reg [2:0]pstate,nstate;
    
    always @(posedge clk)begin
        if (rst|(!start))
            pstate<=S0;
        else 
            pstate<=nstate;
    end
    
    always @(pstate or start or dload_done or w10mulpart_done or w10mul_done or w21mul_done or output_valid or xtest_in_valid)begin
        case(pstate)
            S0:begin //Reset state
                    if(!start)
                        nstate=S0;
                    else 
                        nstate=S1;
               end
            S1: begin // Input data Loading
                    if(dload_done)
                        nstate=S2;
                    else
                        nstate=S1;
                end
            S2: begin //first stage multiplication and serial addition
                    if(w10mulpart_done)
                        nstate=S3;
                    else
                        nstate=S2;
                end
            S3:begin//Store the hidden layer outputs (ReLu function output)
                    if(w10mul_done)
                        nstate=S4;
                    else 
                        nstate=S2;
                end  
            S4: begin //Second stage multiplication and serial addition
                    if(w21mul_done)
                        nstate=S5;
                    else
                        nstate=S4;
                end
            S5:begin//Store the final outputs (Ytest_hat)
                    nstate=S6;
                end
            S6: begin//one hot encoding of Ytest_hat
                    if(output_valid)
                        nstate=S7;
                    else
                        nstate=S6;
                end
            S7: begin //Idle state : Checks whether input is available or not and decides the future state
                    if(xtest_in_valid)
                        nstate=S1;
                    else if(!start)
                        nstate=S0;
                    else
                        nstate=S7;
                end
        endcase
    end
    
    always @(pstate)begin
        case(pstate)
            S0: begin//reset state
                    start_dload=0;
                    start_w10mul=0;
                    store_hlout=0;
                    start_w21mul=0;
                    store_out=0;
                    start_onehot=0;
                end
            S1: begin//Input loading state
                    start_dload=1;
                    start_w10mul=0;
                    store_hlout=0;
                    start_w21mul=0;
                    store_out=0;
                    start_onehot=0;
                end
            S2: begin //First layer multiplication and serial addtion
                    start_dload=0;
                    start_w10mul=1;
                    store_hlout=0;
                    start_w21mul=0;
                    store_out=0;
                    start_onehot=0;
                end
            S3: begin //Storing hl_out (hidden layer outputs)
                    start_dload=0;
                    start_w10mul=1;
                    store_hlout=1;
                    start_w21mul=0;
                    store_out=0;
                    start_onehot=0;
                end
            S4: begin //Second layer multiplication and serial addition
                    start_dload=0;
                    start_w10mul=0;
                    store_hlout=0;
                    start_w21mul=1;
                    store_out=0;
                    start_onehot=0;
                end
            S5: begin //Storing Ytest_hat (outputs)
                    start_dload=0;
                    start_w10mul=0;
                    store_hlout=0;
                    start_w21mul=0;
                    store_out=1;
                    start_onehot=0;
                end
            S6: begin //(One-hot encode the Ytest_hat)
                    start_dload=0;
                    start_w10mul=0;
                    store_hlout=0;
                    start_w21mul=0;
                    store_out=0;
                    start_onehot=1;
                end
            S7:begin//Idle state
                    start_dload=0;
                    start_w10mul=0;
                    store_hlout=0;
                    start_w21mul=0;
                    store_out=0;
                    start_onehot=0;
                end 
        endcase
    end
endmodule