function weights=LFSR(input_nodes,hidden_neurons)
%-->LFSR(Linear Feedback Shift Register) function gives the random weights generated using LFSR algorigthm
%-->Here 16 bit LFSR is used and 10 bits are dedicated to Fraction width
%-->In LFSR XNOR logic is used and is initialized with "zero" and and feedback
%the xnor of (4,13,15,16) bits  
%-->It follows poisson distribution in randomness

    lfsr_vec=zeros(1,input_nodes*hidden_neurons);
    lfsr_vec(1) = 0;
    for i=2:1:input_nodes*hidden_neurons
        r_XOR = bitxor(bitxor(bitget(lfsr_vec(i-1),16),bitget(lfsr_vec(i-1),15)),bitxor(bitget(lfsr_vec(i-1),13),bitget(lfsr_vec(i-1),4)));
        lfsr_vec(i) = bitshift(lfsr_vec(i-1),1,'uint16');
        if(r_XOR==0)
            lfsr_vec(i)=bitset(lfsr_vec(i),1);
        end
    end
    %Normalization
    norm_LFSR=bitshift((lfsr_vec-65534/2),-5,'int16')/1024;    
    %fixed point conversion and fraction bit allocation
    fix_LFSR=fi(norm_LFSR,1,16,10).data;    
    %reshape the vector into matrix
    weights=reshape(fix_LFSR,[input_nodes,hidden_neurons]);
end