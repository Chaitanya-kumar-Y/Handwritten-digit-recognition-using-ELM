

module shiftadd_mul(clk,rst,start,count,mlr,mld,prod);
    input clk,rst,start;
    input [4:0]count;
    input signed[15:0]mlr,mld;
    output signed[15:0]prod;

    wire ld_A,ld_B,write,add,shiftr,shiftl,z,b0,done;
    dpath dp1(clk,rst,mld,ld_A,mlr,ld_B,prod,write,add,shiftr,shiftl,z,b0,done);
    cpath cp1(clk,rst,count,start,ld_A,ld_B,write,add,shiftr,shiftl,z,b0,done);
endmodule

module dpath(clk,rst,A,ld_A,B,ld_B,prod,write,add,shiftr,shiftl,z,b0,done);
    input clk,rst,add,write,shiftr,shiftl,ld_A,ld_B,done;
    input signed[15:0]A,B;
    output signed[15:0]prod;
    output z,b0;    
    
    wire signed[15:0]Aout,Pin,Bout,Pout;
    register A_reg(clk,rst,A,ld_A,shiftl,1'b0,Aout);
    add ad1(Aout,prod,add,Pin);
    register P_reg(clk,rst,Pin,write,1'b0,1'b0,prod);
    register B_reg(clk,rst,B,ld_B,1'b0,shiftr,Bout);
    assign z=~|Bout;
    assign b0=Bout[0];
endmodule

module add(in1,in2,add,out);
    input signed[15:0]in1,in2;
    input add;
    output reg signed[15:0]out;
    always@(in1 or in2 or add)
        if(add)
            out=in1+in2;
        else
            out=0;
endmodule

module register(clk,rst,in,load,shiftl,shiftr,out);
    input clk,rst,load,shiftl,shiftr;
    input signed[15:0]in;
    output reg signed[15:0]out;
    always@(posedge clk) begin
        if(rst)
            out<=0;
        else if (load)
            out<=in;
        else if(shiftl)
            out<=out<<1;
        else if(shiftr)
            out<=out>>1;
        else
            out<=out;
    end
endmodule


module cpath(clk,rst,count,start,ld_A,ld_B,write,add,shiftr,shiftl,z,b0,done);
    input clk,rst,start,z,b0;
    input [4:0]count;
    output reg ld_A,ld_B,write,add,shiftr,shiftl,done;
    parameter S0=0,S1=1,S2=2,S3=3;   
    reg [1:0]cstate,nstate;
    always@(posedge clk)begin
        if(rst)
            cstate<=S0;
        else
            cstate<=nstate;
    end
    always@(cstate or start or z or count)begin
       case(cstate)
            S0:begin
                if(!start) 
                    nstate=S0;
                else
                    nstate=S1;       
               end
            S1: nstate=S2;
            S2:begin
                if(z)
                    nstate=S3;
                else
                    nstate=S2;
            end
            S3:begin
                if(count==17)
                    nstate=S1;
                else
                    nstate=S3;
            end
        default:cstate=S0;
        endcase 
    end
    always@(cstate or b0 or count)begin
       case(cstate)
         S0:begin
               ld_A=0;ld_B=0;write=0;
               add=0;shiftr=0;shiftl=0;done=0;
            end
        S1:begin
               ld_A=1;ld_B=1;write=0;
               add=0;shiftr=0;shiftl=0;done=0;
           end
        S2:begin
              ld_A=0;ld_B=0;shiftr=1;shiftl=1;done=0;
              if(b0)begin
                 add=1;write=1;end
              else begin 
                 add=0;write=0;end
           end
        S3:begin 
               ld_A=0;ld_B=0;write=0;
               add=0;shiftr=0;shiftl=0;           
               if(count==17) done=1;
               else done=0;
           end   
        default:cstate=S0;
        endcase        
    end
endmodule
