`include "defines.vh"
module IF(
    input wire clk,rst_n,//sys
    input wire id_allowin_in,
    output wire if_valid_out,
    //data in
    input wire [31:0] id_nextPC_in,
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
reg switch;
reg id_to_if_brcal_res_r ;
reg [31:0] id_to_if_nextPC_r,if_to_if_NPC_r,VAddr_r;
//------------------------------------------------------
/*====================Function Code====================*/
assign ready = 1'b1; //以后根据IM来判断
assign valid_r = ready;
assign if_valid_out = valid_r;
assign allowin = ready&&id_allowin_in;
always @(posedge clk) begin
    if (!rst_n) begin
        id_to_if_nextPC_r <= `ini_if_NPC_in;
        VAddr_r <= `ini_if_NPC_in;
    end
    else if (allowin && valid_r) begin
        id_to_if_nextPC_r <= id_nextPC_in;
        VAddr_r <= VAddr;
    end

    if (!rst_n) begin
        switch <= 1'b0;
    end
    else if (!ready) begin
        switch <= 1'b1;
    end
end
assign inst_sram_addr = PAddr;
assign VAddr =  switch ? id_to_if_nextPC_r : id_nextPC_in;
assign if_PC_out = VAddr_r;
FixedMapping  u_FixedMapping (
    .VAddr                   ( VAddr   ),

    .PAddr                   ( PAddr   ) 
);
assign inst_sram_addr = PAddr;
addrexc  u_addrexc (
    .address                 ( address       ),
    .addrexc_con             ( addrexc_con   ),

    .ExceptSet               ( ExceptSet     ),
    .ExcCode                 ( ExcCode       ) 
);

assign address = VAddr_r;
assign if_NPC_out = VAddr_r + 3'd4;
assign if_NNPC_out = VAddr_r + 4'd8;
assign addrexc_con = 4'b1;//表示一直开启开启读4检查
assign if_Instruct_out = inst_sram_rdata;
assign inst_sram_wen = 4'b0;
assign inst_sram_wdata = 32'b0;
assign inst_sram_en = rst_n;
endmodule