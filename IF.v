`include "defines.vh"
module IF(
    input wire clk,rst_n,//sys
    input wire id_allowin_in,
    output wire if_valid_out,
    //data in
    input wire [31:0] if_NPC_in,
    input wire [31:0] id_RD1_in,
    input wire [31:0] id_RD2_in,
    input wire [31:0] id_extend_res_in,
    input wire [25:0] id_instr_index_in,
    input wire [2:0]  id_bjpc_con_in,
    input wire [6:0]  id_brcal_con_in,
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
reg  [31:0] if_to_if_NPC_r;
reg  [31:0] id_to_if_RD1_r;
reg  [31:0] id_to_if_RD2_r;
reg  [31:0] id_to_if_extend_res_r;
reg  [25:0] id_to_if_instr_index_r;
reg  [2:0] id_to_if_bjpc_con_r;
reg  [6:0] id_to_if_brcal_con_r;
//------------------------------------------------------
/*====================Function Code====================*/
assign ready = 1'b1; //以后根据IM来判断
assign valid_r = ready;
assign if_valid_out = valid_r;
assign allowin = ready&&id_allowin_in;
always @(posedge clk) begin
    if (!rst_n) begin
        if_to_if_NPC_r <= `ini_if_NPC_in;
        id_to_if_RD1_r <= `ini_id_RD1_in;
        id_to_if_RD2_r <= `ini_id_RD2_in;
        id_to_if_extend_res_r <= `ini_id_extend_res_in;
        id_to_if_instr_index_r <= `ini_id_instr_index_in;
        id_to_if_bjpc_con_r <= `ini_id_bjpc_con_in;
        id_to_if_brcal_con_r <= `ini_id_brcal_con_in;
        
    end
    else if (allowin && valid_r) begin
        if_to_if_NPC_r <= if_NPC_in;
        id_to_if_RD1_r <= id_RD1_in;
        id_to_if_RD2_r <= id_RD2_in;
        id_to_if_extend_res_r <= id_extend_res_in;
        id_to_if_instr_index_r <= id_instr_index_in;
        id_to_if_bjpc_con_r <= id_bjpc_con_in;
        id_to_if_brcal_con_r <= id_brcal_con_in;
    end
end

// brcal Inputs        
wire  [31:0]  RD1;     
wire  [31:0]  RD2;     
wire  [6:0]  brcal_con;

// brcal Outputs
wire  brcal_out;

brcal  u_brcal (
    .RD1                     ( RD1         ),
    .RD2                     ( RD2         ),
    .brcal_con               ( brcal_con   ),

    .brcal_out               ( brcal_out   )
);
assign RD1 = id_to_if_RD1_r;
assign RD2 = id_to_if_RD2_r;
assign brcal_con = id_to_if_brcal_con_r;
// bjpc Inputs
wire  [31:0]  NPC;
// wire  [31:0]  RD1;[brcal]
wire  [31:0]  extend_out;
wire  [25:0]  instr_index;
wire  [2:0]  bjpc_con;

// bjpc Outputs
wire  [31:0]  bjpc_out;

bjpc  u_bjpc (
    .NPC                     ( NPC           ),
    .RD1                     ( RD1           ),
    .extend_out              ( extend_out    ),
    .instr_index             ( instr_index   ),
    .bjpc_con                ( bjpc_con      ),

    .bjpc_out                ( bjpc_out      )
);
assign extend_out = id_to_if_extend_res_r;
assign instr_index = id_to_if_instr_index_r;
assign NPC = if_to_if_NPC_r;
assign bjpc_con = id_to_if_bjpc_con_r;

assign if_PC_out = brcal_out ? bjpc_out : if_to_if_NPC_r;
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