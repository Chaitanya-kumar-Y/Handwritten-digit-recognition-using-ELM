

module datapath(clk,rst,start,start_dload,in,dload_done,start_w10mul,w10mulpart_done,w10mul_done,store_hlout,start_w21mul,w21mul_done,store_out,start_onehot,hw_digit,output_valid,pstate);
    input clk,rst,start,start_dload,start_w10mul,start_w21mul,store_hlout,store_out,start_onehot;
    input in;
    input [2:0]pstate;
    output dload_done;
    output w10mulpart_done,w10mul_done,w21mul_done;
    output [3:0]hw_digit;
    output output_valid;

    wire dload_rst,W10ra_rst,W10loop_rst,w10gen_rst,seradd_w10_rst,w21ra_adv_rst,w21ra_rst;
    wire [7:0]dload_cnt,W10ra;
    wire [5:0]W10loop;
    wire [15:0]xt_w10_tmp[1:420],seed[1:42][1:10],W10_row[1:10],hl_w21_tmp[1:10],w21_sum_tmp[1:10];
    wire [23:0]w10_sum_tmp[1:10];
    wire [4:0]W21ra_adv;
    wire [8:0]W21ra;
    wire [159:0]W21_row;
    wire [3:0]max_cnt;

    reg in10,start_w10add,start_w10add_pipe,start_w21add;       
    reg [1:256]din_arr;
    reg [15:0]hl_out[1:420],in21,w21_sum[1:10],max_in;    
        
    assign dload_rst=rst|(!start_dload);
    din_load_counter dload_counter(clk,dload_rst,start_dload,dload_cnt);
    assign dload_done=(pstate!=7)?(dload_cnt==255):0;  
    always@(posedge clk)
        din_arr[dload_cnt+1]<=in;

    //<<<<<<<<<<<**************************************First layer multiplication*********************************************>>>>>>>>>>>//
    assign W10ra_rst=rst||(!start_w10mul)||((W10loop==43) && (W10ra==0));
    w10_counter w10racnt(clk,W10ra_rst,W10ra!=255,W10ra);
    assign w10mulpart_done = start_w10mul && (W10ra==255);

    assign W10loop_rst=rst|(!start_w10mul);
    w10loop_counter w10loopcnt(clk,W10loop_rst,W10ra==255,W10loop);
    assign w10mul_done=(W10loop==43) & (W10ra==0);            
    assign seed[1][1]=16'h0000, seed[1][2]=16'hf972, seed[1][3]=16'hf2a0, seed[1][4]=16'h00c8, seed[1][5]=16'hf9b3, seed[1][6]=16'ha546,seed[1][7]=16'hffca, seed[1][8]=16'h0d2d, seed[1][9]=16'h0da5, seed[1][10]=16'hc6b4, seed[2][1]=16'h36f3, seed[2][2]=16'h9ab3, seed[2][3]=16'hf03f, seed[2][4]=16'h154f, seed[2][5]=16'h3ab1, seed[2][6]=16'h814f, seed[2][7]=16'hf67a, seed[2][8]=16'h18d1, seed[2][9]=16'h9260, seed[2][10]=16'h7801, seed[3][1]=16'h585d, seed[3][2]=16'hb007, seed[3][3]=16'h59cc, seed[3][4]=16'hb185, seed[3][5]=16'hf600, seed[3][6]=16'h4f80, seed[3][7]=16'h1f3c, seed[3][8]=16'h1e47, seed[3][9]=16'h6dc0, seed[3][10]=16'h69fb, seed[4][1]=16'h43ec, seed[4][2]=16'h04ed, seed[4][3]=16'h0495, seed[4][4]=16'h44e8, seed[4][5]=16'he675, seed[4][6]=16'h8282, seed[4][7]=16'ha2b5, seed[4][8]=16'ha4dc, seed[4][9]=16'hbe43, seed[4][10]=16'h25c4, seed[5][1]=16'hfa8d, seed[5][2]=16'h665f, seed[5][3]=16'h293c, seed[5][4]=16'hea50, seed[5][5]=16'h05a4, seed[5][6]=16'hb722, seed[5][7]=16'hd52a, seed[5][8]=16'hf3a2, seed[5][9]=16'h38a4, seed[5][10]=16'h48f5, seed[6][1]=16'heafe, seed[6][2]=16'h9229, seed[6][3]=16'he4f6, seed[6][4]=16'h5718, seed[6][5]=16'he8d9, seed[6][6]=16'h9ba3, seed[6][7]=16'h6d8b, seed[6][8]=16'he220, seed[6][9]=16'h6368, seed[6][10]=16'h5e82, seed[7][1]=16'hd350, seed[7][2]=16'h4773, seed[7][3]=16'hf2ea, seed[7][4]=16'h8085, seed[7][5]=16'hced7, seed[7][6]=16'hfe71, seed[7][7]=16'h22da, seed[7][8]=16'he17c, seed[7][9]=16'h1965, seed[7][10]=16'hd3c4, seed[8][1]=16'h4c7f, seed[8][2]=16'h8bc3, seed[8][3]=16'h37b3, seed[8][4]=16'h7e23, seed[8][5]=16'hc919, seed[8][6]=16'h0b04, seed[8][7]=16'hdcea, seed[8][8]=16'hfa92, seed[8][9]=16'hbaf8, seed[8][10]=16'h9873, seed[9][1]=16'hf2cf, seed[9][2]=16'hc0a3, seed[9][3]=16'h5565, seed[9][4]=16'hd3ea, seed[9][5]=16'h4c52, seed[9][6]=16'h9754, seed[9][7]=16'h1305, seed[9][8]=16'h597c, seed[9][9]=16'hf139, seed[9][10]=16'h037b, seed[10][1]=16'hd475, seed[10][2]=16'hcb95, seed[10][3]=16'hb0cd, seed[10][4]=16'h4e21, seed[10][5]=16'hc9a2, seed[10][6]=16'h0bb3, seed[10][7]=16'haeb4, seed[10][8]=16'h684a, seed[10][9]=16'h2786, seed[10][10]=16'h78f1, seed[11][1]=16'hd331, seed[11][2]=16'he2dd, seed[11][3]=16'h917b, seed[11][4]=16'hfb3e, seed[11][5]=16'h1519, seed[11][6]=16'h7ae1, seed[11][7]=16'h3f45, seed[11][8]=16'hb63b, seed[11][9]=16'h1fb9, seed[11][10]=16'hac29, seed[12][1]=16'h6ae1, seed[12][2]=16'hcb45, seed[12][3]=16'h5e49, seed[12][4]=16'hcf2b, seed[12][5]=16'h28b4, seed[12][6]=16'h0e01, seed[12][7]=16'h6b64, seed[12][8]=16'h566b, seed[12][9]=16'hc7ef, seed[12][10]=16'h209c, seed[13][1]=16'h4d58, seed[13][2]=16'hf389, seed[13][3]=16'h1d47, seed[13][4]=16'h1c00, seed[13][5]=16'hca72, seed[13][6]=16'h94f7, seed[13][7]=16'h8c37, seed[13][8]=16'h5e47, seed[13][9]=16'haaee, seed[13][10]=16'he7f3, seed[14][1]=16'h0316, seed[14][2]=16'h0332, seed[14][3]=16'h4882, seed[14][4]=16'hc4d0, seed[14][5]=16'he813, seed[14][6]=16'h8c4e, seed[14][7]=16'h15ac, seed[14][8]=16'h1f93, seed[14][9]=16'h825c, seed[14][10]=16'h29f4, seed[15][1]=16'hea91, seed[15][2]=16'h5242, seed[15][3]=16'h4820, seed[15][4]=16'h21b4, seed[15][5]=16'h5b41, seed[15][6]=16'h01da, seed[15][7]=16'h732b, seed[15][8]=16'h7de8, seed[15][9]=16'ha4a2, seed[15][10]=16'hc74a, seed[16][1]=16'hf71a, seed[16][2]=16'h99a9, seed[16][3]=16'h7896, seed[16][4]=16'h4feb, seed[16][5]=16'hf10f, seed[16][6]=16'hed13, seed[16][7]=16'h1e0e, seed[16][8]=16'hf137, seed[16][9]=16'h66be, seed[16][10]=16'h1b32, seed[17][1]=16'hc682, seed[17][2]=16'hd89b, seed[17][3]=16'h50c8, seed[17][4]=16'hca9d, seed[17][5]=16'hc33c, seed[17][6]=16'h6fa2, seed[17][7]=16'h8e6f, seed[17][8]=16'h2552, seed[17][9]=16'he6ad, seed[17][10]=16'h30b7, seed[18][1]=16'h9cbb, seed[18][2]=16'h4f0e, seed[18][3]=16'hed59, seed[18][4]=16'h9e43, seed[18][5]=16'hc653, seed[18][6]=16'h3d89, seed[18][7]=16'hc622, seed[18][8]=16'h2ad3, seed[18][9]=16'hcc5b, seed[18][10]=16'h45b8, seed[19][1]=16'hb011, seed[19][2]=16'hd24c, seed[19][3]=16'ha82e, seed[19][4]=16'he503, seed[19][5]=16'hd6fa, seed[19][6]=16'h6ce6, seed[19][7]=16'h1a27, seed[19][8]=16'h7ef8, seed[19][9]=16'h6796, seed[19][10]=16'h0d2b, seed[20][1]=16'h34d1, seed[20][2]=16'hb6f7, seed[20][3]=16'h3120, seed[20][4]=16'ha44d, seed[20][5]=16'h9081, seed[20][6]=16'h148f, seed[20][7]=16'h4981, seed[20][8]=16'hf72a, seed[20][9]=16'h4eb5, seed[20][10]=16'hc2ae, seed[21][1]=16'h729a, seed[21][2]=16'h1982, seed[21][3]=16'hd8be, seed[21][4]=16'h10ee, seed[21][5]=16'h512f, seed[21][6]=16'heea7, seed[21][7]=16'h012a, seed[21][8]=16'hf847, seed[21][9]=16'h2f32, seed[21][10]=16'h6c15, seed[22][1]=16'h8df1, seed[22][2]=16'h1403, seed[22][3]=16'hacc8, seed[22][4]=16'h58ef, seed[22][5]=16'he797, seed[22][6]=16'h8376, seed[22][7]=16'h28c1, seed[22][8]=16'h3703, seed[22][9]=16'h3e9f, seed[22][10]=16'h3c62, seed[23][1]=16'h90f1, seed[23][2]=16'h0843, seed[23][3]=16'h5418, seed[23][4]=16'h9919, seed[23][5]=16'h382a, seed[23][6]=16'hba90, seed[23][7]=16'h6afa, seed[23][8]=16'h39ba, seed[23][9]=16'hb084, seed[23][10]=16'hd2d6, seed[24][1]=16'hc6e7, seed[24][2]=16'h536d, seed[24][3]=16'h6cdb, seed[24][4]=16'hb444, seed[24][5]=16'h33a6, seed[24][6]=16'h5419, seed[24][7]=16'h928f, seed[24][8]=16'h2fca, seed[24][9]=16'hbbc8, seed[24][10]=16'h602f, seed[25][1]=16'hd670, seed[25][2]=16'hb0db, seed[25][3]=16'hc5a1, seed[25][4]=16'hd009, seed[25][5]=16'h18b0, seed[25][6]=16'h37ce, seed[25][7]=16'h1b90, seed[25][8]=16'h23e6, seed[25][9]=16'h6bc9, seed[25][10]=16'hdd5c, seed[26][1]=16'hac1a, seed[26][2]=16'ha147, seed[26][3]=16'h495c, seed[26][4]=16'h60d1, seed[26][5]=16'h38d9, seed[26][6]=16'h2d46, seed[26][7]=16'h0001, seed[26][8]=16'hf2e4, seed[26][9]=16'he540, seed[26][10]=16'h0190, seed[27][1]=16'hf366, seed[27][2]=16'h4a8c, seed[27][3]=16'hff95, seed[27][4]=16'h1a5a, seed[27][5]=16'h1b4b, seed[27][6]=16'h8d69, seed[27][7]=16'h6de6, seed[27][8]=16'h3567, seed[27][9]=16'he07f, seed[27][10]=16'h2a9f, seed[28][1]=16'h7562, seed[28][2]=16'h029f, seed[28][3]=16'hecf5, seed[28][4]=16'h31a2, seed[28][5]=16'h24c1, seed[28][6]=16'hf003, seed[28][7]=16'hb0ba, seed[28][8]=16'h600f, seed[28][9]=16'hb398, seed[28][10]=16'h630b, seed[29][1]=16'hec00, seed[29][2]=16'h9f00, seed[29][3]=16'h3e79, seed[29][4]=16'h3c8e, seed[29][5]=16'hdb80, seed[29][6]=16'hd3f7, seed[29][7]=16'h87d9, seed[29][8]=16'h09da, seed[29][9]=16'h092b, seed[29][10]=16'h89d1, seed[30][1]=16'hcceb, seed[30][2]=16'h0504, seed[30][3]=16'h456a, seed[30][4]=16'h49b9, seed[30][5]=16'h7c87, seed[30][6]=16'h4b89, seed[30][7]=16'hf51b, seed[30][8]=16'hccbf, seed[30][9]=16'h5278, seed[30][10]=16'hd4a1, seed[31][1]=16'h0b49, seed[31][2]=16'h6e45, seed[31][3]=16'haa55, seed[31][4]=16'he744, seed[31][5]=16'h7148, seed[31][6]=16'h91ea, seed[31][7]=16'hd5fc, seed[31][8]=16'h2452, seed[31][9]=16'hc9ed, seed[31][10]=16'hae30, seed[32][1]=16'hd1b2, seed[32][2]=16'h3747, seed[32][3]=16'hdb17, seed[32][4]=16'hc441, seed[32][5]=16'hc6d1, seed[32][6]=16'hbd05, seed[32][7]=16'ha6a0, seed[32][8]=16'h8ee6, seed[32][9]=16'he5d5, seed[32][10]=16'h010a, seed[33][1]=16'h9daf, seed[33][2]=16'hfce2, seed[33][3]=16'h45b4, seed[33][4]=16'hc2f8, seed[33][5]=16'h32ca, seed[33][6]=16'ha788, seed[33][7]=16'h98ff, seed[33][8]=16'h1786, seed[33][9]=16'h6f66, seed[33][10]=16'hfc47, seed[34][1]=16'h9232, seed[34][2]=16'h1609, seed[34][3]=16'hb9d5, seed[34][4]=16'hf524, seed[34][5]=16'h75f0, seed[34][6]=16'h30e7, seed[34][7]=16'he59f, seed[34][8]=16'h8147, seed[34][9]=16'haacb, seed[34][10]=16'ha7d5, seed[35][1]=16'h98a4, seed[35][2]=16'h2ea9, seed[35][3]=16'h260a, seed[35][4]=16'hb2f8, seed[35][5]=16'he273, seed[35][6]=16'h06f6, seed[35][7]=16'ha8ea, seed[35][8]=16'h972b, seed[35][9]=16'h619a, seed[35][10]=16'h9c42, seed[36][1]=16'h9345, seed[36][2]=16'h1767, seed[36][3]=16'h5d68, seed[36][4]=16'hd095, seed[36][5]=16'h4f0d, seed[36][6]=16'hf1e3, seed[36][7]=16'ha662, seed[36][8]=16'hc5ba, seed[36][9]=16'h22f6, seed[36][10]=16'hf67d, seed[37][1]=16'h2a33, seed[37][2]=16'hf5c3, seed[37][3]=16'h7e8a, seed[37][4]=16'h6c76, seed[37][5]=16'h3f73, seed[37][6]=16'h5853, seed[37][7]=16'hd5c2, seed[37][8]=16'h968b, seed[37][9]=16'hbc92, seed[37][10]=16'h9e56, seed[38][1]=16'h5169, seed[38][2]=16'h1c03, seed[38][3]=16'hd6c8, seed[38][4]=16'hacd6, seed[38][5]=16'h8fde, seed[38][6]=16'h4138, seed[38][7]=16'h9ab1, seed[38][8]=16'he713, seed[38][9]=16'h3a8e, seed[38][10]=16'h3800, seed[39][1]=16'h94e5, seed[39][2]=16'h29ef, seed[39][3]=16'h186e, seed[39][4]=16'hbc8f, seed[39][5]=16'h55dd, seed[39][6]=16'hcfe7, seed[39][7]=16'h062d, seed[39][8]=16'h0665, seed[39][9]=16'h9104, seed[39][10]=16'h89a1, seed[40][1]=16'hd027, seed[40][2]=16'h189d, seed[40][3]=16'h2b59, seed[40][4]=16'h3f26, seed[40][5]=16'h04b9, seed[40][6]=16'h53e9, seed[40][7]=16'hd523, seed[40][8]=16'ha485, seed[40][9]=16'h9040, seed[40][10]=16'h4369, seed[41][1]=16'hb683, seed[41][2]=16'h03b4, seed[41][3]=16'he656, seed[41][4]=16'hfbd0, seed[41][5]=16'h4944, seed[41][6]=16'h8e94, seed[41][7]=16'hee35, seed[41][8]=16'h3352, seed[41][9]=16'hf12d, seed[41][10]=16'h9fd7, seed[42][1]=16'he21f, seed[42][2]=16'hda27, seed[42][3]=16'h3c1d, seed[42][4]=16'he26e, seed[42][5]=16'hcd7d, seed[42][6]=16'h3664, seed[42][7]=16'h8d05, seed[42][8]=16'hb137, seed[42][9]=16'ha190, seed[42][10]=16'h953a;
    assign w10gen_rst=start_dload|(W10ra==0);
    w10gen w10generator1(clk,w10gen_rst,start_w10mul,seed[W10loop][1],W10_row[1]);
    w10gen w10generator2(clk,w10gen_rst,start_w10mul,seed[W10loop][2],W10_row[2]);
    w10gen w10generator3(clk,w10gen_rst,start_w10mul,seed[W10loop][3],W10_row[3]);
    w10gen w10generator4(clk,w10gen_rst,start_w10mul,seed[W10loop][4],W10_row[4]);
    w10gen w10generator5(clk,w10gen_rst,start_w10mul,seed[W10loop][5],W10_row[5]);
    w10gen w10generator6(clk,w10gen_rst,start_w10mul,seed[W10loop][6],W10_row[6]);
    w10gen w10generator7(clk,w10gen_rst,start_w10mul,seed[W10loop][7],W10_row[7]);
    w10gen w10generator8(clk,w10gen_rst,start_w10mul,seed[W10loop][8],W10_row[8]);
    w10gen w10generator9(clk,w10gen_rst,start_w10mul,seed[W10loop][9],W10_row[9]);
    w10gen w10generator10(clk,w10gen_rst,start_w10mul,seed[W10loop][10],W10_row[10]);

    always@(posedge clk)
    if((start_w10mul)&&(W10ra!=0))
      in10<=din_arr[W10ra+1];
    else 
        in10<=0;

    w10_multiplier w10mul_1(clk,start_w10mul,in10,W10_row[1],xt_w10_tmp[1]);
    w10_multiplier w10mul_2(clk,start_w10mul,in10,W10_row[2],xt_w10_tmp[2]);
    w10_multiplier w10mul_3(clk,start_w10mul,in10,W10_row[3],xt_w10_tmp[3]);
    w10_multiplier w10mul_4(clk,start_w10mul,in10,W10_row[4],xt_w10_tmp[4]);
    w10_multiplier w10mul_5(clk,start_w10mul,in10,W10_row[5],xt_w10_tmp[5]);
    w10_multiplier w10mul_6(clk,start_w10mul,in10,W10_row[6],xt_w10_tmp[6]);
    w10_multiplier w10mul_7(clk,start_w10mul,in10,W10_row[7],xt_w10_tmp[7]);
    w10_multiplier w10mul_8(clk,start_w10mul,in10,W10_row[8],xt_w10_tmp[8]);
    w10_multiplier w10mul_9(clk,start_w10mul,in10,W10_row[9],xt_w10_tmp[9]);
    w10_multiplier w10mul_10(clk,start_w10mul,in10,W10_row[10],xt_w10_tmp[10]);

    always@(posedge clk)
        start_w10add<=(pstate!=4)?start_w10mul:0;
    always@(posedge clk)
        start_w10add_pipe<=start_w10add;         

    assign seradd_w10_rst=rst|(W10ra==255)|(start_w10add)&(!start_w10add_pipe);
    serial_adderw10  hlout_sum1(clk,seradd_w10_rst,start_w10add_pipe,W10ra,xt_w10_tmp[1],w10_sum_tmp[1]);
    serial_adderw10  hlout_sum2(clk,seradd_w10_rst,start_w10add_pipe,W10ra,xt_w10_tmp[2],w10_sum_tmp[2]);
    serial_adderw10  hlout_sum3(clk,seradd_w10_rst,start_w10add_pipe,W10ra,xt_w10_tmp[3],w10_sum_tmp[3]);
    serial_adderw10  hlout_sum4(clk,seradd_w10_rst,start_w10add_pipe,W10ra,xt_w10_tmp[4],w10_sum_tmp[4]);
    serial_adderw10  hlout_sum5(clk,seradd_w10_rst,start_w10add_pipe,W10ra,xt_w10_tmp[5],w10_sum_tmp[5]);
    serial_adderw10  hlout_sum6(clk,seradd_w10_rst,start_w10add_pipe,W10ra,xt_w10_tmp[6],w10_sum_tmp[6]);
    serial_adderw10  hlout_sum7(clk,seradd_w10_rst,start_w10add_pipe,W10ra,xt_w10_tmp[7],w10_sum_tmp[7]);
    serial_adderw10  hlout_sum8(clk,seradd_w10_rst,start_w10add_pipe,W10ra,xt_w10_tmp[8],w10_sum_tmp[8]);
    serial_adderw10  hlout_sum9(clk,seradd_w10_rst,start_w10add_pipe,W10ra,xt_w10_tmp[9],w10_sum_tmp[9]);
    serial_adderw10  hlout_sum10(clk,seradd_w10_rst,start_w10add_pipe,W10ra,xt_w10_tmp[10],w10_sum_tmp[10]);
    always@(posedge clk)
    if(W10loop!=1)begin
        hl_out[10*(W10loop-2)+1]<=store_hlout?(w10_sum_tmp[1][23]?0:w10_sum_tmp[1][23:8]):hl_out[10*(W10loop-2)+1];
        hl_out[10*(W10loop-2)+2]<=store_hlout?(w10_sum_tmp[2][23]?0:w10_sum_tmp[2][23:8]):hl_out[10*(W10loop-2)+2];
        hl_out[10*(W10loop-2)+3]<=store_hlout?(w10_sum_tmp[3][23]?0:w10_sum_tmp[3][23:8]):hl_out[10*(W10loop-2)+3];
        hl_out[10*(W10loop-2)+4]<=store_hlout?(w10_sum_tmp[4][23]?0:w10_sum_tmp[4][23:8]):hl_out[10*(W10loop-2)+4];
        hl_out[10*(W10loop-2)+5]<=store_hlout?(w10_sum_tmp[5][23]?0:w10_sum_tmp[5][23:8]):hl_out[10*(W10loop-2)+5];
        hl_out[10*(W10loop-2)+6]<=store_hlout?(w10_sum_tmp[6][23]?0:w10_sum_tmp[6][23:8]):hl_out[10*(W10loop-2)+6];
        hl_out[10*(W10loop-2)+7]<=store_hlout?(w10_sum_tmp[7][23]?0:w10_sum_tmp[7][23:8]):hl_out[10*(W10loop-2)+7];
        hl_out[10*(W10loop-2)+8]<=store_hlout?(w10_sum_tmp[8][23]?0:w10_sum_tmp[8][23:8]):hl_out[10*(W10loop-2)+8];
        hl_out[10*(W10loop-2)+9]<=store_hlout?(w10_sum_tmp[9][23]?0:w10_sum_tmp[9][23:8]):hl_out[10*(W10loop-2)+9];
        hl_out[10*(W10loop-1)]<=store_hlout?(w10_sum_tmp[10][23]?0:w10_sum_tmp[10][23:8]):hl_out[10*(W10loop-1)];
    end 
    
    //<<<<<<<<<<<**************************************Second layer multiplication*********************************************>>>>>>>>>>>//
    assign w21ra_adv_rst=rst||(!start_w21mul)||(W21ra_adv==17);    
    w21sa_counter sa_cnt(clk,w21ra_adv_rst,W21ra_adv);

    assign w21ra_rst = rst||(!start_w21mul);
    w21add_counter w21_cnt(clk,w21ra_rst,W21ra_adv==17,W21ra);    
    assign w21mul_done = (W21ra==420) && (W21ra_adv==17) && start_w21mul;

    w21rom rom_21(clk,W21ra,W21_row);
    always@(posedge clk)
    if(start_w21mul)
        in21<=hl_out[W21ra];
        
    shiftadd_mul w21mul_1(clk,rst||(W21ra_adv==17),start_w21mul,W21ra_adv,in21,W21_row[159:144],hl_w21_tmp[1]);
    shiftadd_mul w21mul_2(clk,rst||(W21ra_adv==17),start_w21mul,W21ra_adv,in21,W21_row[143:128],hl_w21_tmp[2]);
    shiftadd_mul w21mul_3(clk,rst||(W21ra_adv==17),start_w21mul,W21ra_adv,in21,W21_row[127:112],hl_w21_tmp[3]);
    shiftadd_mul w21mul_4(clk,rst||(W21ra_adv==17),start_w21mul,W21ra_adv,in21,W21_row[111:96],hl_w21_tmp[4]);
    shiftadd_mul w21mul_5(clk,rst||(W21ra_adv==17),start_w21mul,W21ra_adv,in21,W21_row[95:80],hl_w21_tmp[5]);
    shiftadd_mul w21mul_6(clk,rst||(W21ra_adv==17),start_w21mul,W21ra_adv,in21,W21_row[79:64],hl_w21_tmp[6]);
    shiftadd_mul w21mul_7(clk,rst||(W21ra_adv==17),start_w21mul,W21ra_adv,in21,W21_row[63:48],hl_w21_tmp[7]);
    shiftadd_mul w21mul_8(clk,rst||(W21ra_adv==17),start_w21mul,W21ra_adv,in21,W21_row[47:32],hl_w21_tmp[8]);
    shiftadd_mul w21mul_9(clk,rst||(W21ra_adv==17),start_w21mul,W21ra_adv,in21,W21_row[31:16],hl_w21_tmp[9]);
    shiftadd_mul w21mul_10(clk,rst||(W21ra_adv==17),start_w21mul,W21ra_adv,in21,W21_row[15:0],hl_w21_tmp[10]);
    
    always@(posedge clk)
        start_w21add<=(pstate!=5)?start_w21mul:0;     

    serial_adderw21  w21add_1(clk,start_dload,start_w21add,W21ra,W21ra_adv,hl_w21_tmp[1],w21_sum_tmp[1]);
    serial_adderw21  w21add_2(clk,start_dload,start_w21add,W21ra,W21ra_adv,hl_w21_tmp[2],w21_sum_tmp[2]);
    serial_adderw21  w21add_3(clk,start_dload,start_w21add,W21ra,W21ra_adv,hl_w21_tmp[3],w21_sum_tmp[3]);
    serial_adderw21  w21add_4(clk,start_dload,start_w21add,W21ra,W21ra_adv,hl_w21_tmp[4],w21_sum_tmp[4]);
    serial_adderw21  w21add_5(clk,start_dload,start_w21add,W21ra,W21ra_adv,hl_w21_tmp[5],w21_sum_tmp[5]);
    serial_adderw21  w21add_6(clk,start_dload,start_w21add,W21ra,W21ra_adv,hl_w21_tmp[6],w21_sum_tmp[6]);
    serial_adderw21  w21add_7(clk,start_dload,start_w21add,W21ra,W21ra_adv,hl_w21_tmp[7],w21_sum_tmp[7]);
    serial_adderw21  w21add_8(clk,start_dload,start_w21add,W21ra,W21ra_adv,hl_w21_tmp[8],w21_sum_tmp[8]);
    serial_adderw21  w21add_9(clk,start_dload,start_w21add,W21ra,W21ra_adv,hl_w21_tmp[9],w21_sum_tmp[9]);
    serial_adderw21  w21add_10(clk,start_dload,start_w21add,W21ra,W21ra_adv,hl_w21_tmp[10],w21_sum_tmp[10]);
    always@(posedge clk)begin
        w21_sum[1]<=store_out?w21_sum_tmp[1]:w21_sum[1];
        w21_sum[2]<=store_out?w21_sum_tmp[2]:w21_sum[2];
        w21_sum[3]<=store_out?w21_sum_tmp[3]:w21_sum[3];
        w21_sum[4]<=store_out?w21_sum_tmp[4]:w21_sum[4];
        w21_sum[5]<=store_out?w21_sum_tmp[5]:w21_sum[5];
        w21_sum[6]<=store_out?w21_sum_tmp[6]:w21_sum[6];
        w21_sum[7]<=store_out?w21_sum_tmp[7]:w21_sum[7];
        w21_sum[8]<=store_out?w21_sum_tmp[8]:w21_sum[8];
        w21_sum[9]<=store_out?w21_sum_tmp[9]:w21_sum[9];
        w21_sum[10]<=store_out?w21_sum_tmp[10]:w21_sum[10];
    end

    max_counter mx_cnt(clk,store_out,start_onehot,max_cnt);
    always@(posedge clk)
    if(start_onehot)
        max_in<=w21_sum[max_cnt+1];    
    onehot_encoder ohe(clk,start_w10mul,start_onehot,max_cnt,max_in,hw_digit);
    assign output_valid = (pstate==7) ? 0 :((max_cnt==12) ? 1 : 0);
endmodule