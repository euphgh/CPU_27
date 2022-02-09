`include "defines.vh"
/*====================Ports Declaration====================*/
module IF(
	input wire clk,rst_n,brcal_out,go_if,
    output wire allowin_if,
 	input wire [31:0] bjpc_out, //address:
	output reg [31:0] Instruct_reg, //data:
	output reg [31:0] PC_if_reg,NPC_reg,NNPC_reg,//address:
    //sram
    input wire [31:0] inst_sram_rdata,
    output wire [31:0] inst_sram_wdata,
    output wire inst_sram_en,
    output wire [3:0] inst_sram_wen,
    output wire [31:0] inst_sram_addr
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

// PC Outputs-------------------------------------------
wire  [31:0]  pc_in;
wire  [31:0]  NPC,NNPC; 
wire  [31:0]  PC; 
wire  [31:0]  Instruct_wire;
//------------------------------------------------------
/*====================Function Code====================*/
initial begin
    Instruct_reg <= `ini_Instruct ;
    NPC_reg <= `ini_NPC_reg ;
    PC_if_reg <= `ini_PC_reg ;
end
always @(posedge clk ) begin
    if (!rst_n) begin
        Instruct_reg <= `ini_Instruct ;
        NPC_reg <= `ini_NPC_reg ;
        PC_if_reg <= `ini_PC_reg ;
    end else begin
        if (go_if) begin
            Instruct_reg <= Instruct_wire;//等指令存储器模块
            NPC_reg <= NPC;
            NNPC_reg <= NNPC;
            PC_if_reg <= PC ;
        end
    end
end
PC  u_PC (
    .clk                     ( clk     ),
    .rst_n                   ( rst_n   ),
    .pc_in                   ( pc_in   ),
    .go_if                   ( go_if   ),

    .PC                      ( PC      ),
    .NPC                     ( NPC     ), 
    .NNPC                    ( NNPC    )
);
assign VAddr = brcal_out ? bjpc_out : NPC;
assign Instruct_wire = inst_sram_rdata ;
assign pc_in = VAddr ;
FixedMapping  u_FixedMapping (
    .VAddr                   ( VAddr   ),

    .PAddr                   ( PAddr   ) 
);

addrexc  u_addrexc (
    .address                 ( address       ),
    .addrexc_con             ( addrexc_con   ),

    .ExceptSet               ( ExceptSet     ),
    .ExcCode                 ( ExcCode       ) 
);
assign address = pc_in;
assign addrexc_con = 4'b1;//表示一直开启开启读4检查
assign inst_sram_en = go_if&&rst_n;
assign inst_sram_addr = PAddr;
assign inst_sram_wen = 4'b0;
assign inst_sram_wdata = 32'b0;
assign allowin_if = go_if;
endmodule