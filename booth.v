/*====================Ports Declaration====================*/
module booth (
    input  wire [32:0] x,y,
    output wire [33:0] pp0,
    output wire [33:0] pp1,
    output wire [33:0] pp2,
    output wire [33:0] pp3,
    output wire [33:0] pp4,
    output wire [33:0] pp5,
    output wire [33:0] pp6,
    output wire [33:0] pp7,
    output wire [33:0] pp8,
    output wire [33:0] pp9,
    output wire [33:0] pp10,
    output wire [33:0] pp11,
    output wire [33:0] pp12,
    output wire [33:0] pp13,
    output wire [33:0] pp14,
    output wire [33:0] pp15,
    output wire [33:0] pp16
    );
/*====================Variable Declaration====================*/
wire [33:0] x_minum_2,x_plus,x_plus_2,x_minus;
wire [2:0] code0;
wire [2:0] code1;
wire [2:0] code2;
wire [2:0] code3;
wire [2:0] code4;
wire [2:0] code5;
wire [2:0] code6;
wire [2:0] code7;
wire [2:0] code8;
wire [2:0] code9;
wire [2:0] code10;
wire [2:0] code11;
wire [2:0] code12;
wire [2:0] code13;
wire [2:0] code14;
wire [2:0] code15;
wire [2:0] code16;
/*====================Function Code====================*/
assign x_plus_2 = {x,1'b0};
assign x_minus = ~x+1'b1;
assign x_minum_2 = ~x_plus_2+1'b1;
assign x_plus = x;
assign code0 = {y[0],2'b0};
assign code1 = y[2:0];
assign code2 = y[4:2];
assign code3 = y[6:4];
assign code4 = y[8:6];
assign code5 = y[10:8];
assign code6 = y[12:10];
assign code7 = y[14:12];
assign code8 = y[16:14];
assign code9 = y[18:16];
assign code10 = y[20:18];
assign code11 = y[22:20];
assign code12 = y[24:22];
assign code13 = y[26:24];
assign code14 = y[28:26];
assign code15 = y[30:28];
assign code16 = y[32:30];
assign pp0 =  ({34{(code0==3'd0)||(code0==3'd7)}} & 34'b0) |
            ({34{(code0==3'd1)||(code0==3'd2)}} & x_plus)|  
            ({34{(code0==3'd3)}} & x_plus_2)|
            ({34{(code0==3'd4)}} & x_minum_2)|
            ({34{(code0==3'd5)||(code0==3'd6)}} & x_plus);  
assign pp1 =  ({34{(code1==3'd0)||(code1==3'd7)}} & 34'b0) |
            ({34{(code1==3'd1)||(code1==3'd2)}} & x_plus)|  
            ({34{(code1==3'd3)}} & x_plus_2)|
            ({34{(code1==3'd4)}} & x_minum_2)|
            ({34{(code1==3'd5)||(code1==3'd6)}} & x_plus);  
assign pp2 =  ({34{(code2==3'd0)||(code2==3'd7)}} & 34'b0) |
            ({34{(code2==3'd1)||(code2==3'd2)}} & x_plus)|  
            ({34{(code2==3'd3)}} & x_plus_2)|
            ({34{(code2==3'd4)}} & x_minum_2)|
            ({34{(code2==3'd5)||(code2==3'd6)}} & x_plus);  
assign pp3 =  ({34{(code3==3'd0)||(code3==3'd7)}} & 34'b0) |
            ({34{(code3==3'd1)||(code3==3'd2)}} & x_plus)|  
            ({34{(code3==3'd3)}} & x_plus_2)|
            ({34{(code3==3'd4)}} & x_minum_2)|
            ({34{(code3==3'd5)||(code3==3'd6)}} & x_plus);  
assign pp4 =  ({34{(code4==3'd0)||(code4==3'd7)}} & 34'b0) |
            ({34{(code4==3'd1)||(code4==3'd2)}} & x_plus)|  
            ({34{(code4==3'd3)}} & x_plus_2)|
            ({34{(code4==3'd4)}} & x_minum_2)|
            ({34{(code4==3'd5)||(code4==3'd6)}} & x_plus);  
assign pp5 =  ({34{(code5==3'd0)||(code5==3'd7)}} & 34'b0) |
            ({34{(code5==3'd1)||(code5==3'd2)}} & x_plus)|  
            ({34{(code5==3'd3)}} & x_plus_2)|
            ({34{(code5==3'd4)}} & x_minum_2)|
            ({34{(code5==3'd5)||(code5==3'd6)}} & x_plus);  
assign pp6 =  ({34{(code6==3'd0)||(code6==3'd7)}} & 34'b0) |
            ({34{(code6==3'd1)||(code6==3'd2)}} & x_plus)|  
            ({34{(code6==3'd3)}} & x_plus_2)|
            ({34{(code6==3'd4)}} & x_minum_2)|
            ({34{(code6==3'd5)||(code6==3'd6)}} & x_plus);  
assign pp7 =  ({34{(code7==3'd0)||(code7==3'd7)}} & 34'b0) |
            ({34{(code7==3'd1)||(code7==3'd2)}} & x_plus)|  
            ({34{(code7==3'd3)}} & x_plus_2)|
            ({34{(code7==3'd4)}} & x_minum_2)|
            ({34{(code7==3'd5)||(code7==3'd6)}} & x_plus);
assign pp8 =  ({34{(code8==3'd0)||(code8==3'd7)}} & 34'b0) |
            ({34{(code8==3'd1)||(code8==3'd2)}} & x_plus)|
            ({34{(code8==3'd3)}} & x_plus_2)|
            ({34{(code8==3'd4)}} & x_minum_2)|
            ({34{(code8==3'd5)||(code8==3'd6)}} & x_plus);
assign pp9 =  ({34{(code9==3'd0)||(code9==3'd7)}} & 34'b0) |
            ({34{(code9==3'd1)||(code9==3'd2)}} & x_plus)|
            ({34{(code9==3'd3)}} & x_plus_2)|
            ({34{(code9==3'd4)}} & x_minum_2)|
            ({34{(code9==3'd5)||(code9==3'd6)}} & x_plus);
assign pp10 =  ({34{(code10==3'd0)||(code10==3'd7)}} & 34'b0) |
            ({34{(code10==3'd1)||(code10==3'd2)}} & x_plus)|
            ({34{(code10==3'd3)}} & x_plus_2)|
            ({34{(code10==3'd4)}} & x_minum_2)|
            ({34{(code10==3'd5)||(code10==3'd6)}} & x_plus);
assign pp11 =  ({34{(code11==3'd0)||(code11==3'd7)}} & 34'b0) |
            ({34{(code11==3'd1)||(code11==3'd2)}} & x_plus)|
            ({34{(code11==3'd3)}} & x_plus_2)|
            ({34{(code11==3'd4)}} & x_minum_2)|
            ({34{(code11==3'd5)||(code11==3'd6)}} & x_plus);
assign pp12 =  ({34{(code12==3'd0)||(code12==3'd7)}} & 34'b0) |
            ({34{(code12==3'd1)||(code12==3'd2)}} & x_plus)|
            ({34{(code12==3'd3)}} & x_plus_2)|
            ({34{(code12==3'd4)}} & x_minum_2)|
            ({34{(code12==3'd5)||(code12==3'd6)}} & x_plus);
assign pp13 =  ({34{(code13==3'd0)||(code13==3'd7)}} & 34'b0) |
            ({34{(code13==3'd1)||(code13==3'd2)}} & x_plus)|
            ({34{(code13==3'd3)}} & x_plus_2)|
            ({34{(code13==3'd4)}} & x_minum_2)|
            ({34{(code13==3'd5)||(code13==3'd6)}} & x_plus);
assign pp14 =  ({34{(code14==3'd0)||(code14==3'd7)}} & 34'b0) |
            ({34{(code14==3'd1)||(code14==3'd2)}} & x_plus)|
            ({34{(code14==3'd3)}} & x_plus_2)|
            ({34{(code14==3'd4)}} & x_minum_2)|
            ({34{(code14==3'd5)||(code14==3'd6)}} & x_plus);
assign pp15 =  ({34{(code15==3'd0)||(code15==3'd7)}} & 34'b0) |
            ({34{(code15==3'd1)||(code15==3'd2)}} & x_plus)|
            ({34{(code15==3'd3)}} & x_plus_2)|
            ({34{(code15==3'd4)}} & x_minum_2)|
            ({34{(code15==3'd5)||(code15==3'd6)}} & x_plus);
assign pp16 =  ({34{(code16==3'd0)||(code16==3'd7)}} & 34'b0) |
            ({34{(code16==3'd1)||(code16==3'd2)}} & x_plus)|
            ({34{(code16==3'd3)}} & x_plus_2)|
            ({34{(code16==3'd4)}} & x_minum_2)|
            ({34{(code16==3'd5)||(code16==3'd6)}} & x_plus);
endmodule
