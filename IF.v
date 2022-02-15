`include "defines.vh"
/*====================Ports Declaration====================*/
module IF(
    //sys
	input wire clk,rst_n,
    input wire id_allowin_in,
    output wire if_valid_out,
    //data in
    input wire id_brcal_res_in, //datar:
 	input wire [31:0] id_bjpc_res_in, //datar:
    //data out
	output wire [31:0] if_PC_out,if_NPC_out,if_NNPC_out,if_Instruct_out,
    //sram
    output wire [31:0] inst_sram_wdata,
    output wire [3:0] inst_sram_wen,
    output wire [31:0] inst_sram_addr,
    input  wire [31:0] inst_sram_rdata,
    output wire inst_sram_en
	);
/*====================Variable Declaration====================*/

// addrexc Inputs---------------------------------------
wire  [31:0]  address;   
wire  [3:0]  addrexc_con;

// addrexc Outputs
wire  ExceptSet;
wire  [7:0]  ExcCode;
//-------------------------------------------------------
// FixedMapping Inputs-----------------------------------
wire  [31:0]  VAddr;  

// FixedMapping Outputs
wire  [31:0]  PAddr;
//------------------------------------------------------

//other-------------------------------------------------
wire ready ;
wire allowin ;
wire valid_r;
reg  id_to_if_brcal_res_r ;
reg  [31:0] id_to_if_bjpc_res_r;
reg  [31:0] id_to_if_NPC_r;
//------------------------------------------------------
/*====================Function Code====================*/
assign ready = 1'b1; //以后根据IM来判断
assign valid_r = ready;
assign if_valid_out = valid_r;
assign allowin = ready&&id_allowin_in;
always @(posedge clk) begin
    if (!rst_n) begin
        id_to_if_brcal_res_r <= `ini_id_brcal_res_in;
        id_to_if_bjpc_res_r <= `ini_id_bjpc_res_in;
        id_to_if_NPC_r <= `ini_id_NPC_in;
    end
    else if (allowin && valid_r) begin
        id_to_if_brcal_res_r <= id_brcal_res_in;
        id_to_if_bjpc_res_r <= id_bjpc_res_in;
        id_to_if_NPC_r <= if_NPC_out;
    end
end
assign if_PC_out = id_to_if_brcal_res_r ? id_to_if_bjpc_res_r : id_to_if_NPC_r;
assign inst_sram_addr = PAddr;
FixedMapping  u_FixedMapping (
    .VAddr                   ( VAddr   ),

    .PAddr                   ( PAddr   ) 
);
assign VAddr = if_PC_out;
assign inst_sram_addr = PAddr;
addrexc  u_addrexc (
    .address                 ( address       ),
    .addrexc_con             ( addrexc_con   ),

    .ExceptSet               ( ExceptSet     ),
    .ExcCode                 ( ExcCode       ) 
);

assign address = if_PC_out;
assign if_NPC_out = if_PC_out + 3'd4;
assign if_NNPC_out = if_PC_out + 4'd8;
assign addrexc_con = 4'b1;//表示一直开启开启读4检查
assign if_Instruct_out = inst_sram_rdata;
assign inst_sram_wen = 4'b0;
assign inst_sram_wdata = 32'b0;
assign inst_sram_en = id_allowin_in&&rst_n;
endmodule