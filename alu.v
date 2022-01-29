`timescale 1ns / 1ps
module ALU(
    input wire [31:0] scr0,scr1,
    input wire [11:0] aluop,
    output wire overflow,
    output wire [31:0] aluso
    );
    
//所有操作符的处理
wire add_op,sub_op,and_op,or_op,nor_op,xor_op,slt_op,sltu_op,sll_op,srl_op,sra_op,lui_op;
assign {add_op,sub_op,and_op,or_op,nor_op,xor_op,slt_op,sltu_op,sll_op,srl_op,sra_op,lui_op} = aluop;

//与、或、或非、异或、逻辑左移右移、算数右移、高位置数
wire and_res,or_res,nor_res,xor_res,sll_res,srl_res,sra_res,lui_res;
assign and_res = scr0 & scr1;
assign or_res = scr0 | scr1;
assign nor_res = !(scr0 | scr1);
assign xor_res = scr0 ^ scr1;
assign sll_res = scr1 << scr0[4:0] ;
assign srl_res = scr1 >> scr0[4:0] ;
assign sra_res = ($signed(scr1)) >> scr0[4:0] ;
assign lui_res = {scr1[15:0],16'b0};

//加、减、无符号比较、有符号比较
wire cin,cout;
wire [31:0] add_a,add_b,add_sub_res;
adder #(.BUS(32)) u_adder (
    .add_a                   ( scr0      ),
    .add_b                   ( scr1      ),
    .adder_op                ( {add_op,sub_op,slt_op,sltu_op}   ),

    .add_res                 ( add_sub_res    ),
    .overflow                ( overflow   )
);

//整理计算结果
assign aluso  = ({32{add_op|sub_op|slt_op|sltu_op}} & add_sub_res)|
                ({32{and_op}} & and_res)|
                ({32{or_op}} & or_res)|
                ({32{nor_op}} & nor_res)|
                ({32{xor_op}} & xor_res)|
                ({32{sll_op}} & sll_res)|
                ({32{srl_op}} & srl_res)|
                ({32{sra_op}} & sra_res)|
                ({32{lui_op}} & lui_res);      
endmodule
