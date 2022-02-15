`include "defines.vh"
/*====================Ports Declaration====================*/
module MEM(
    //sys
	input  wire clk,rst_n,
    input wire wb_allowin_in,
    output wire mem_allowin_out,
    input  wire exe_valid_in,
    output wire mem_valid_out,
    //datain
	input  wire [3:0]  exe_sel_wbdata_in, //datar:{0:aluout,1:lubw,2:llr,3:NNPC}
	input  wire [31:0] exe_aluout_in, //datar:地址或者回写数据
	input  wire [7:0]  exe_onehot_in, //datar:控制llr
	input  wire [4:0]  exe_lubhw_con_in, //datar:控制lubhw
	input  wire [31:0] exe_dm_data_in, //dataw:
	input  wire [3:0]  exe_dm_we_in, //dataw:
    input  wire [31:0] exe_VAddr_in, //dataw:
    input  wire [31:0] exe_PC_in, //datar:
    input  wire [31:0] exe_NNPC_in, //datar:
    input  wire [4:0]  exe_regnum_in, //datar:
    input  wire [2:0]  exe_write_type_in,
    //dataout
	output wire [31:0] mem_wbdata_out, //data:回写数据
	output wire [3:0]  mem_reg_we_out, //control:回写使能
    output wire [31:0] mem_PC_out,
    output wire [4:0]  mem_wnum_out,
    output wire [2:0]  mem_write_type_out,

    output wire data_sram_en, //ram 使能信号，高电平有效
    output wire [3:0]  data_sram_wen, //ram 字节写使能信号，高电平有效
    output wire [31:0] data_sram_addr,  //ram 读写地址，字节寻址
    output wire [31:0] data_sram_wdata,  //ram 写数据
    input  wire [31:0] data_sram_rdata  //ram 读数据
);
/*====================Variable Declaration====================*/
// FixedMapping Inputs--------------------------
wire  [31:0]  VAddr;
// FixedMapping Outputs       
wire  [31:0]  PAddr;
// ---------------------------------------------



// llr Inputs-----------------------------------       
wire  [31:0]  word_llr; 
wire  [7:0]  onehot;
// llr Outputs
wire  [31:0]  llr_data;
wire  [3:0]  llr_we;   
// ---------------------------------------------

// lubhw Inputs---------------------------------
wire  [31:0]  word_lubhw;     
wire  [1:0]  adrl_lubhw;
wire  [4:0]  lubhw_con;

// lubhw Outputs        
wire  [31:0]  lubhw_out;
//----------------------------------------------

// other----------------------------------------
wire allowin,ready;
reg  valid_r;
wire [31:0] DMout;
wire [3:0]  exe_to_mem_dm_we_r ;
wire [31:0] exe_to_mem_VAddr_r ;
wire [31:0] exe_to_mem_dm_data_r;

reg  [3:0] exe_to_mem_sel_wbdata_r ;
reg  [31:0] exe_to_mem_aluout_r ;
reg  [7:0] exe_to_mem_onehot_r ;
reg  [4:0] exe_to_mem_lubhw_con_r ;
reg  [31:0] exe_to_mem_PC_r ;
reg  [31:0] exe_to_mem_NNPC_r ;
reg  [4:0] exe_to_mem_regnum_r ;
reg  [2:0]  exe_to_mem_write_type_r;
wire [31:0] MEM_PC = mem_PC_out;
// ---------------------------------------------
/*====================Function Code====================*/
assign ready = 1'b1; 
assign allowin = (!valid_r) || (ready && wb_allowin_in) ;
assign mem_allowin_out = allowin;
assign mem_valid_out = ready && valid_r;
always @(posedge clk ) begin
    if (!rst_n) begin
        valid_r <= 1'b0;
    end else begin
        valid_r <= exe_valid_in;
    end
end

assign exe_to_mem_dm_data_r = exe_dm_data_in ;
assign exe_to_mem_dm_we_r = exe_dm_we_in ;
assign exe_to_mem_VAddr_r = exe_VAddr_in ;

always @(posedge clk) begin
    if (!rst_n) begin
        exe_to_mem_sel_wbdata_r <= `ini_exe_sel_wbdata_in;
        exe_to_mem_aluout_r <= `ini_exe_aluout_in;
        exe_to_mem_onehot_r <= `ini_exe_onehot_in;
        exe_to_mem_lubhw_con_r <= `ini_exe_lubhw_con_in;
        exe_to_mem_PC_r <= `ini_exe_PC_in;
        exe_to_mem_NNPC_r <= `ini_exe_NNPC_in;
        exe_to_mem_regnum_r <= `ini_exe_regnum_in;
        exe_to_mem_write_type_r <= `ini_exe_write_type_in;
    end
    else if (allowin && exe_valid_in) begin
        exe_to_mem_sel_wbdata_r <= exe_sel_wbdata_in;
        exe_to_mem_aluout_r <= exe_aluout_in;
        exe_to_mem_onehot_r <= exe_onehot_in;
        exe_to_mem_lubhw_con_r <= exe_lubhw_con_in;
        exe_to_mem_PC_r <= exe_PC_in;
        exe_to_mem_NNPC_r <= exe_NNPC_in;
        exe_to_mem_regnum_r <= exe_regnum_in;
        exe_to_mem_write_type_r <= exe_write_type_in;
    end
    else if (!exe_valid_in) begin
        exe_to_mem_sel_wbdata_r <= `ini_exe_sel_wbdata_in;
        exe_to_mem_aluout_r <= `ini_exe_aluout_in;
        exe_to_mem_onehot_r <= `ini_exe_onehot_in;
        exe_to_mem_lubhw_con_r <= `ini_exe_lubhw_con_in;
        exe_to_mem_NNPC_r <= `ini_exe_NNPC_in;
        exe_to_mem_regnum_r <= `ini_exe_regnum_in;
        exe_to_mem_write_type_r <= `ini_exe_write_type_in;
    end
end
FixedMapping  u_FixedMapping (
    .VAddr                   ( VAddr   ),

    .PAddr                   ( PAddr   )
);
assign VAddr = exe_to_mem_VAddr_r;
lubhw  u_lubhw (
    .word                    ( word_lubhw   ),
    .adrl_lubhw              ( adrl_lubhw   ),
    .lubhw_con               ( lubhw_con    ),

    .lubhw_out               ( lubhw_out    )
);
assign word_lubhw = DMout;
assign adrl_lubhw = VAddr[1:0];
assign lubhw_con = exe_to_mem_lubhw_con_r;
llr  u_llr (
    .word                    ( word_llr   ),
    .onehot                  ( onehot     ),

    .llr_data                ( llr_data   ),
    .llr_we                  ( llr_we     )
);
assign onehot = exe_to_mem_onehot_r;
assign word_llr = DMout;
assign mem_wbdata_out = exe_to_mem_sel_wbdata_r[0] ? exe_to_mem_aluout_r : 
				        exe_to_mem_sel_wbdata_r[1] ? lubhw_out :
                        exe_to_mem_sel_wbdata_r[2] ? llr_data:
                        exe_to_mem_sel_wbdata_r[3] ? exe_to_mem_NNPC_r :32'b0; 

assign mem_reg_we_out = {4{|exe_to_mem_regnum_r}} & ((exe_to_mem_sel_wbdata_r[0]||exe_to_mem_sel_wbdata_r[1]||exe_to_mem_sel_wbdata_r[3]) ? 4'b1111 :
					    exe_to_mem_sel_wbdata_r[2] ? llr_we : 4'b0);

assign mem_PC_out = exe_to_mem_PC_r;
assign data_sram_en = rst_n;
assign data_sram_wen = exe_to_mem_dm_we_r;
assign data_sram_addr = PAddr;
assign data_sram_wdata = exe_to_mem_dm_data_r;
assign DMout = data_sram_rdata;
assign mem_wnum_out = exe_to_mem_regnum_r;
assign mem_write_type_out = exe_to_mem_write_type_r;
endmodule