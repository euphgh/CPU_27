`include "defines.vh"
/*====================Ports Declaration====================*/
module  mult (
    input wire [31:0] scr0,scr1,
    input wire multop, //control:{0:unsigned,1:signed}
    output wire [63:0] mult_res
    );
/*====================Variable Declaration====================*/
// booth Inputs 
wire  [32:0]  x;
wire  [32:0]  y;

// booth Outputs
wire  [33:0]  pp0;
wire  [33:0]  pp1;
wire  [33:0]  pp2;
wire  [33:0]  pp3;
wire  [33:0]  pp4;
wire  [33:0]  pp5;
wire  [33:0]  pp6;
wire  [33:0]  pp7;
wire  [33:0]  pp8;
wire  [33:0]  pp9;
wire  [33:0]  pp10;
wire  [33:0]  pp11;
wire  [33:0]  pp12;
wire  [33:0]  pp13;
wire  [33:0]  pp14;
wire  [33:0]  pp15;
wire  [33:0]  pp16;
wire [32:0] xnum,ynum;
wire [33:0] pp [15:0] ;
/*====================Function Code====================*/
assign xnum = {multop&&scr0[31],scr0};
assign ynum = {multop&&scr1[31],scr1};
assign x = xnum;
assign y = ynum;
booth  u_booth (
    .x                       ( x      ),
    .y                       ( y      ),

    .pp0                     ( pp0    ),
    .pp1                     ( pp1    ),
    .pp2                     ( pp2    ),
    .pp3                     ( pp3    ),
    .pp4                     ( pp4    ),
    .pp5                     ( pp5    ),
    .pp6                     ( pp6    ),
    .pp7                     ( pp7    ),
    .pp8                     ( pp8    ),
    .pp9                     ( pp9    ),
    .pp10                    ( pp10   ),
    .pp11                    ( pp11   ),
    .pp12                    ( pp12   ),
    .pp13                    ( pp13   ),
    .pp14                    ( pp14   ),
    .pp15                    ( pp15   ),
    .pp16                    ( pp16   )
);
wire  [63:0]  pp0_1 = {{30{pp0[33]}},pp0};
wire  [63:0]  pp1_1 = {{30{pp1[33]}},pp1};
wire  [63:0]  pp2_1 = {{30{pp2[33]}},pp2};
wire  [63:0]  pp3_1 = {{30{pp3[33]}},pp3};
wire  [63:0]  pp4_1 = {{30{pp4[33]}},pp4};
wire  [63:0]  pp5_1 = {{30{pp5[33]}},pp5};
wire  [63:0]  pp6_1 = {{30{pp6[33]}},pp6};
wire  [63:0]  pp7_1 = {{30{pp7[33]}},pp7};
wire  [63:0]  pp8_1 = {{30{pp8[33]}},pp8};
wire  [63:0]  pp9_1 = {{30{pp9[33]}},pp9};
wire  [63:0]  pp10_1 = {{30{pp10[33]}},pp10};
wire  [63:0]  pp11_1 = {{30{pp11[33]}},pp11};
wire  [63:0]  pp12_1 = {{30{pp12[33]}},pp12};
wire  [63:0]  pp13_1 = {{30{pp13[33]}},pp13};
wire  [63:0]  pp14_1 = {{30{pp14[33]}},pp14};
wire  [63:0]  pp15_1 = {{30{pp15[33]}},pp15};
wire  [63:0]  pp16_1 = {{30{pp16[33]}},pp16};
//=========================level1 to level2=========================//
wire [32:0] pp0_2 = pp0[33:1];
wire [33:0] pp1_2 = pp1;
wire [38:0] pp2_2;
wire [38:0] pp3_2;
wire [38:0] pp4_2;
wire [38:0] pp5_2;
wire [38:0] pp6_2;
wire [38:0] pp7_2;
wire [38:0] pp8_2;
wire [38:0] pp9_2;
wire [36:0] pp10_2;
wire [36:0] pp11_2;

// ThreeToTwo Inputs -------------------------------------
wire  [37:0]  in0_1to2_1;
wire  [37:0]  in1_1to2_1;
wire  [37:0]  in2_1to2_1;

// ThreeToTwo Outputs
wire  [38:0]  out0_1to2_1;
wire  [38:0]  out1_1to2_1;
ThreeToTwo #(.BUSin(38)) u1_ThreeToTwo (
    .in0                     ( in0_1to2_1    ),
    .in1                     ( in1_1to2_1    ),
    .in2                     ( in2_1to2_1    ),

    .out0                    ( out0_1to2_1   ),
    .out1                    ( out1_1to2_1   ) 
);
assign in0_1to2_1 = {{4{pp2[33]}},pp2};
assign in1_1to2_1 = {{2{pp3[33]}},pp3,2'b0};
assign in2_1to2_1 = {pp4,4'b0};
assign pp2_2 = out0_1to2_1;
assign pp3_2 = out1_1to2_1;
//--------------------------------------------------------
// ThreeToTwo Inputs -------------------------------------
wire  [37:0]  in0_1to2_2;
wire  [37:0]  in1_1to2_2;
wire  [37:0]  in2_1to2_2;

// ThreeToTwo Outputs
wire  [38:0]  out0_1to2_2;
wire  [38:0]  out1_1to2_2;
ThreeToTwo #(.BUSin(38)) u2_ThreeToTwo (
    .in0                     ( in0_1to2_2    ),
    .in1                     ( in1_1to2_2    ),
    .in2                     ( in2_1to2_2    ),

    .out0                    ( out0_1to2_2   ),
    .out1                    ( out1_1to2_2   ) 
);
assign in0_1to2_2 = {{4{pp5[33]}},pp5};
assign in1_1to2_2 = {{2{pp6[33]}},pp6,2'b0};
assign in2_1to2_2 = {pp7,4'b0};
assign pp4_2 = out0_1to2_2;
assign pp5_2 = out1_1to2_2;
//--------------------------------------------------------
// ThreeToTwo Inputs -------------------------------------
wire  [37:0]  in0_1to2_3;
wire  [37:0]  in1_1to2_3;
wire  [37:0]  in2_1to2_3;

// ThreeToTwo Outputs
wire  [38:0]  out0_1to2_3;
wire  [38:0]  out1_1to2_3;
ThreeToTwo #(.BUSin(38)) u3_ThreeToTwo (
    .in0                     ( in0_1to2_3    ),
    .in1                     ( in1_1to2_3    ),
    .in2                     ( in2_1to2_3    ),

    .out0                    ( out0_1to2_3   ),
    .out1                    ( out1_1to2_3   ) 
);
assign in0_1to2_3 = {{4{pp8[33]}},pp8};
assign in1_1to2_3 = {{2{pp9[33]}},pp9,2'b0};
assign in2_1to2_3 = {pp10,4'b0};
assign pp6_2 = out0_1to2_3;
assign pp7_2 = out1_1to2_3;
//--------------------------------------------------------
// ThreeToTwo Inputs -------------------------------------
wire  [37:0]  in0_1to2_4;
wire  [37:0]  in1_1to2_4;
wire  [37:0]  in2_1to2_4;

// ThreeToTwo Outputs
wire  [38:0]  out0_1to2_4;
wire  [38:0]  out1_1to2_4;
ThreeToTwo #(.BUSin(38)) u_4ThreeToTwo (
    .in0                     ( in0_1to2_4    ),
    .in1                     ( in1_1to2_4    ),
    .in2                     ( in2_1to2_4    ),

    .out0                    ( out0_1to2_4   ),
    .out1                    ( out1_1to2_4   ) 
);
assign in0_1to2_4 = {{4{pp11[33]}},pp11};
assign in1_1to2_4 = {{2{pp12[33]}},pp12,2'b0};
assign in2_1to2_4 = {pp13,4'b0};
assign pp8_2 = out0_1to2_4;
assign pp9_2 = out1_1to2_4;
//--------------------------------------------------------
// ThreeToTwo Inputs -------------------------------------
wire  [36:0]  in0_1to2_5;
wire  [36:0]  in1_1to2_5;
wire  [36:0]  in2_1to2_5;

// ThreeToTwo Outputs
wire  [37:0]  out0_1to2_5;
wire  [37:0]  out1_1to2_5;
ThreeToTwo #(.BUSin(37)) u_5ThreeToTwo (
    .in0                     ( in0_1to2_5    ),
    .in1                     ( in1_1to2_5    ),
    .in2                     ( in2_1to2_5    ),

    .out0                    ( out0_1to2_5   ),
    .out1                    ( out1_1to2_5   ) 
);
assign in0_1to2_5 = {{3{pp14[33]}},pp14};
assign in1_1to2_5 = {pp15[33],pp15,2'b0};
assign in2_1to2_5 = {pp16[32:0],4'b0};
assign pp10_2 = out0_1to2_5[36:0];
assign pp11_2 = out1_1to2_5[36:0];
//--------------------------------------------------------
//==================================================================//
//=========================level2 to level3=========================//
wire [42:0] pp0_3;
wire [42:0] pp1_3;
wire [45:0] pp2_3;
wire [45:0] pp3_3;
wire [45:0] pp4_3;
wire [45:0] pp5_3;
wire [42:0] pp6_3;
wire [42:0] pp7_3;
// ThreeToTwo Inputs -------------------------------------
wire  [41:0]  in0_2to3_1;
wire  [41:0]  in1_2to3_1;
wire  [41:0]  in2_2to3_1;

// ThreeToTwo Outputs
wire  [42:0]  out0_2to3_1;
wire  [42:0]  out1_2to3_1;
ThreeToTwo #(.BUSin(42)) u_6ThreeToTwo (
    .in0                     ( in0_2to3_1    ),
    .in1                     ( in1_2to3_1    ),
    .in2                     ( in2_2to3_1    ),

    .out0                    ( out0_2to3_1   ),
    .out1                    ( out1_2to3_1   ) 
);
assign in0_2to3_1 = {{9{pp0_2[32]}},pp0_2};
assign in1_2to3_1 = {{7{pp1_2[33]}},pp1_2,1'b0};
assign in2_2to3_1 = {pp2_2,3'b0};
assign pp0_3 = out0_2to3_1;
assign pp1_3 = out1_2to3_1;
//--------------------------------------------------------
// ThreeToTwo Inputs -------------------------------------
wire  [44:0]  in0_2to3_2;
wire  [44:0]  in1_2to3_2;
wire  [44:0]  in2_2to3_2;

// ThreeToTwo Outputs
wire  [45:0]  out0_2to3_2;
wire  [45:0]  out1_2to3_2;
ThreeToTwo #(.BUSin(45)) u_7ThreeToTwo (
    .in0                     ( in0_2to3_2    ),
    .in1                     ( in1_2to3_2    ),
    .in2                     ( in2_2to3_2    ),

    .out0                    ( out0_2to3_2   ),
    .out1                    ( out1_2to3_2   ) 
);
assign in0_2to3_2 = {{6{pp3_2[38]}},pp3_2};
assign in1_2to3_2 = {pp4_2,6'b0};
assign in2_2to3_2 = {pp5_2,6'b0};
assign pp2_3 = out0_2to3_2;
assign pp3_3 = out1_2to3_2;
//--------------------------------------------------------
// ThreeToTwo Inputs -------------------------------------
wire  [44:0]  in0_2to3_3;
wire  [44:0]  in1_2to3_3;
wire  [44:0]  in2_2to3_3;

// ThreeToTwo Outputs
wire  [45:0]  out0_2to3_3;
wire  [45:0]  out1_2to3_3;
ThreeToTwo #(.BUSin(45)) u_8ThreeToTwo (
    .in0                     ( in0_2to3_3    ),
    .in1                     ( in1_2to3_3    ),
    .in2                     ( in2_2to3_3    ),

    .out0                    ( out0_2to3_3   ),
    .out1                    ( out1_2to3_3   ) 
);
assign in0_2to3_3 = {{6{pp6_2[38]}},pp6_2};
assign in1_2to3_3 = {{6{pp7_2[38]}},pp7_2};
assign in2_2to3_3 = {pp8_2,6'b0};
assign pp4_3 = out0_2to3_3;
assign pp5_3 = out1_2to3_3;
//--------------------------------------------------------
// ThreeToTwo Inputs -------------------------------------
wire  [42:0]  in0_2to3_4;
wire  [42:0]  in1_2to3_4;
wire  [42:0]  in2_2to3_4;

// ThreeToTwo Outputs
wire  [43:0]  out0_2to3_4;
wire  [43:0]  out1_2to3_4;
ThreeToTwo #(.BUSin(43)) u_9ThreeToTwo (
    .in0                     ( in0_2to3_4    ),
    .in1                     ( in1_2to3_4    ),
    .in2                     ( in2_2to3_4    ),

    .out0                    ( out0_2to3_4   ),
    .out1                    ( out1_2to3_4   ) 
);
assign in0_2to3_4 = {{4{pp9_2[38]}},pp9_2};
assign in1_2to3_4 = {pp10_2[36:0],6'b0};
assign in2_2to3_4 = {pp11_2[36:0],6'b0};
assign pp6_3 = out0_2to3_4[42:0];
assign pp7_3 = out1_2to3_4[42:0];
//--------------------------------------------------------
//==================================================================//
//=========================level3 to level4=========================//
wire [49:0] pp0_4;
wire [49:0] pp1_4;
wire [45:0] pp2_4 = pp3_3;
wire [45:0] pp3_4 = pp4_3;
wire [48:0] pp4_4;
wire [48:0] pp5_4;
// ThreeToTwo Inputs -------------------------------------
wire  [48:0]  in0_3to4_1;
wire  [48:0]  in1_3to4_1;
wire  [48:0]  in2_3to4_1;

// ThreeToTwo Outputs
wire  [49:0]  out0_3to4_1;
wire  [49:0]  out1_3to4_1;
ThreeToTwo #(.BUSin(49)) u_10ThreeToTwo (
    .in0                     ( in0_3to4_1    ),
    .in1                     ( in1_3to4_1    ),
    .in2                     ( in2_3to4_1    ),

    .out0                    ( out0_3to4_1   ),
    .out1                    ( out1_3to4_1   ) 
);
assign in0_3to4_1 = {{6{pp0_3[42]}},pp0_3};
assign in1_3to4_1 = {{6{pp1_3[42]}},pp1_3};
assign in2_3to4_1 = {pp2_3,3'b0};
assign pp0_4 = out0_3to4_1;
assign pp1_4 = out1_3to4_1;
//--------------------------------------------------------
// ThreeToTwo Inputs -------------------------------------
wire  [48:0]  in0_3to4_2;
wire  [48:0]  in1_3to4_2;
wire  [48:0]  in2_3to4_2;

// ThreeToTwo Outputs
wire  [49:0]  out0_3to4_2;
wire  [49:0]  out1_3to4_2;
ThreeToTwo #(.BUSin(49)) u_11ThreeToTwo (
    .in0                     ( in0_3to4_2    ),
    .in1                     ( in1_3to4_2    ),
    .in2                     ( in2_3to4_2    ),

    .out0                    ( out0_3to4_2   ),
    .out1                    ( out1_3to4_2   ) 
);
assign in0_3to4_2 = {{3{pp5_3[45]}},pp5_3};
assign in1_3to4_2 = {pp6_3[42:0],6'b0};
assign in2_3to4_2 = {pp7_3[42:0],6'b0};
assign pp4_4 = out0_3to4_2[48:0];
assign pp5_4 = out1_3to4_2[48:0];
//--------------------------------------------------------
//==================================================================//
//=========================level4 to level5=========================//
wire [50:0] pp0_5;
wire [50:0] pp1_5;
wire [48:0] pp2_5;
wire [48:0] pp3_5;
// ThreeToTwo Inputs -------------------------------------
wire  [49:0]  in0_4to5_1;
wire  [49:0]  in1_4to5_1;
wire  [49:0]  in2_4to5_1;

// ThreeToTwo Outputs
wire  [50:0]  out0_4to5_1;
wire  [50:0]  out1_4to5_1;
ThreeToTwo #(.BUSin(50)) u_12ThreeToTwo (
    .in0                     ( in0_4to5_1    ),
    .in1                     ( in1_4to5_1    ),
    .in2                     ( in2_4to5_1    ),

    .out0                    ( out0_4to5_1   ),
    .out1                    ( out1_4to5_1   ) 
);
assign in0_4to5_1 = pp0_4;
assign in1_4to5_1 = pp1_4;
assign in2_4to5_1 = {pp2_4[45],pp2_4,3'b0};
assign pp0_5 = out0_4to5_1;
assign pp1_5 = out1_4to5_1;
//--------------------------------------------------------
// ThreeToTwo Inputs -------------------------------------
wire  [48:0]  in0_4to5_2;
wire  [48:0]  in1_4to5_2;
wire  [48:0]  in2_4to5_2;

// ThreeToTwo Outputs
wire  [49:0]  out0_4to5_2;
wire  [49:0]  out1_4to5_2;
ThreeToTwo #(.BUSin(49)) u_13ThreeToTwo (
    .in0                     ( in0_4to5_2    ),
    .in1                     ( in1_4to5_2    ),
    .in2                     ( in2_4to5_2    ),

    .out0                    ( out0_4to5_2   ),
    .out1                    ( out1_4to5_2   ) 
);
assign in0_4to5_2 = {{3{pp3_4[45]}},pp3_4};
assign in1_4to5_2 = pp4_4;
assign in2_4to5_2 = pp5_4;
assign pp2_5 = out0_4to5_2[48:0];
assign pp3_5 = out1_4to5_2[48:0];
//--------------------------------------------------------

//==================================================================//

//=========================level5 to level6=========================//
wire [63:0] pp0_6;
wire [63:0] pp1_6;
wire [48:0] pp2_6 = pp3_5;
// ThreeToTwo Inputs -------------------------------------
wire  [63:0]  in0_5to6_1;
wire  [63:0]  in1_5to6_1;
wire  [63:0]  in2_5to6_1;

// ThreeToTwo Outputs
wire  [64:0]  out0_5to6_1;
wire  [64:0]  out1_5to6_1;
ThreeToTwo #(.BUSin(64)) u_14ThreeToTwo (
    .in0                     ( in0_5to6_1    ),
    .in1                     ( in1_5to6_1    ),
    .in2                     ( in2_5to6_1    ),

    .out0                    ( out0_5to6_1   ),
    .out1                    ( out1_5to6_1   ) 
);
assign in0_5to6_1 = {{13{pp0_5[50]}},pp0_5};
assign in1_5to6_1 = {{13{pp1_5[50]}},pp1_5};
assign in2_5to6_1 = {pp2_5,15'b0};
assign pp0_6 = out0_5to6_1[63:0];
assign pp1_6 = out1_5to6_1[63:0];
//--------------------------------------------------------
//==================================================================//

//=========================level6 to level7=========================//
wire [63:0] pp0_7;
wire [63:0] pp1_7;
// ThreeToTwo Inputs -------------------------------------
wire  [63:0]  in0_6to7_1;
wire  [63:0]  in1_6to7_1;
wire  [63:0]  in2_6to7_1;

// ThreeToTwo Outputs
wire  [64:0]  out0_6to7_1;
wire  [64:0]  out1_6to7_1;
ThreeToTwo #(.BUSin(64)) u_15ThreeToTwo (
    .in0                     ( in0_6to7_1    ),
    .in1                     ( in1_6to7_1    ),
    .in2                     ( in2_6to7_1    ),

    .out0                    ( out0_6to7_1   ),
    .out1                    ( out1_6to7_1   ) 
);
assign in0_6to7_1 = pp0_6;
assign in1_6to7_1 = pp1_6;
assign in2_6to7_1 = {pp2_6,15'b0};
assign pp0_7 = out0_6to7_1[63:0];
assign pp1_7 = out1_6to7_1[63:0];
//--------------------------------------------------------
//==================================================================//
assign mult_res = pp0_7 + pp1_7;
wire signed [63:0] tb_pp0 = pp0_1;
wire signed [63:0] tb_pp1 = pp1_1;
wire signed [63:0] tb_pp2 = pp2_1;
wire signed [63:0] tb_pp3 = pp3_1;
wire signed [63:0] tb_pp4 = pp4_1;
wire signed [63:0] tb_pp5 = pp5_1;
wire signed [63:0] tb_pp6 = pp6_1;
wire signed [63:0] tb_pp7 = pp7_1;
wire signed [63:0] tb_pp8 = pp8_1;
wire signed [63:0] tb_pp9 = pp9_1;
wire signed [63:0] tb_pp10 = pp10_1;
wire signed [63:0] tb_pp11 = pp11_1;
wire signed [63:0] tb_pp12 = pp12_1;
wire signed [63:0] tb_pp13 = pp13_1;
wire signed [63:0] tb_pp14 = pp14_1;
wire signed [63:0] tb_pp15 = pp15_1;
wire signed [63:0] tb_pp16 = pp16_1;

wire signed [63:0] tb_pp0_2 = $signed(pp0_2);
wire signed [63:0] tb_pp1_2 = $signed(pp1_2);
wire signed [63:0] tb_pp2_2 = $signed(pp2_2);
wire signed [63:0] tb_pp3_2 = $signed(pp3_2);
wire signed [63:0] tb_pp4_2 = $signed(pp4_2);
wire signed [63:0] tb_pp5_2 = $signed(pp5_2);
wire signed [63:0] tb_pp6_2 = $signed(pp6_2);
wire signed [63:0] tb_pp7_2 = $signed(pp7_2);
wire signed [63:0] tb_pp8_2 = $signed(pp8_2);
wire signed [63:0] tb_pp9_2 = $signed(pp9_2);
wire signed [63:0] tb_pp10_2 = $signed(pp10_2);
wire signed [63:0] tb_pp11_2 = $signed(pp11_2);

wire signed [63:0] tb_pp0_3 = $signed(pp0_3);
wire signed [63:0] tb_pp1_3 = $signed(pp1_3);
wire signed [63:0] tb_pp2_3 = $signed(pp2_3);
wire signed [63:0] tb_pp3_3 = $signed(pp3_3);
wire signed [63:0] tb_pp4_3 = $signed(pp4_3);
wire signed [63:0] tb_pp5_3 = $signed(pp5_3);
wire signed [63:0] tb_pp6_3 = $signed(pp6_3);
wire signed [63:0] tb_pp7_3 = $signed(pp7_3);

wire signed [63:0] tb_pp0_4 = $signed(pp0_4);
wire signed [63:0] tb_pp1_4 = $signed(pp1_4);
wire signed [63:0] tb_pp2_4 = $signed(pp2_4);
wire signed [63:0] tb_pp3_4 = $signed(pp3_4);
wire signed [63:0] tb_pp4_4 = $signed(pp4_4);
wire signed [63:0] tb_pp5_4 = $signed(pp5_4);

wire signed [63:0] tb_pp0_5 = $signed(pp0_5);
wire signed [63:0] tb_pp1_5 = $signed(pp1_5);
wire signed [63:0] tb_pp2_5 = $signed(pp2_5);
wire signed [63:0] tb_pp3_5 = $signed(pp3_5);

wire signed [63:0] tb_pp0_6 = $signed(pp0_6);
wire signed [63:0] tb_pp1_6 = $signed(pp1_6);
wire signed [63:0] tb_pp2_6 = $signed(pp2_6);
wire [63:0] level1_check = ({tb_pp0[63],tb_pp0[63:1]})+(tb_pp1<<1  )+(tb_pp2<<3   )+(tb_pp3<<5   )+(tb_pp4<<7   )+(tb_pp5<<9   )+(tb_pp6<<11  )+(tb_pp7<<13  )+(tb_pp8<<15  )+(tb_pp9<<17)    +(tb_pp10<<19)     +(tb_pp11<<21)+(tb_pp12<<23)+(tb_pp13<<25)+(tb_pp14<<27)+(tb_pp15<<29)+(tb_pp16<<31);
wire [63:0] level2_check = (tb_pp0_2   )+(tb_pp1_2<<1)+(tb_pp2_2<<3 )+(tb_pp3_2<<3 )+(tb_pp4_2<<9 )+(tb_pp5_2<<9 )+(tb_pp6_2<<15)+(tb_pp7_2<<15)+(tb_pp8_2<<21)+(tb_pp9_2<<21)  +(tb_pp10_2<<27)   +(tb_pp11_2<<27);
wire [63:0] level3_check = (tb_pp0_3   )+(tb_pp1_3   )+(tb_pp2_3<<3 )+(tb_pp3_3<<3 )+(tb_pp4_3<<15)+(tb_pp5_3<<15)+(tb_pp6_3<<21)+(tb_pp7_3<<21);
wire [63:0] level4_check = (tb_pp0_4   )+(tb_pp1_4   )+(tb_pp2_4<<3 )+(tb_pp3_4<<15)+(tb_pp4_4<<15)+(tb_pp5_4<<15);
wire [63:0] level5_check = (tb_pp0_5   )+(tb_pp1_5   )+(tb_pp2_5<<15)+(tb_pp3_5<<15);
wire [63:0] level6_check = (tb_pp0_6   )+(tb_pp1_6   )+(tb_pp2_6<<15);
endmodule