`include "defines.vh"
/*====================Ports Declaration====================*/
module MEM(
	input clk,rst_n,go_mem,allowin_mem,
	input wire [3:0] sel_wbdata, //control:{0:aluout,1:lubw,2:llr,3:NNPC}
	input wire [31:0] aluout, //data:地址或者回写数据
	input wire [7:0] onehot, //control:控制llr
	input wire [4:0] lubhw_con, //control:控制lubhw
	input wire [31:0] dm_data, //data:
	input wire [3:0] dm_we, //control:
    input wire [31:0] VAddr,
    input wire [31:0] PC_mem_wire,NNPC_mem_wire,
    input wire [4:0] regnum_mem_wire,

    output wire [4:0]  regnum_mem,
	output wire [31:0] wbdata, //data:回写数据
	output wire [3:0] reg_we_mem, //control:回写使能
    output wire [31:0] PC_mem,

    output data_sram_en, //ram 使能信号，高电平有效
    output [3 :0] data_sram_wen, //ram 字节写使能信号，高电平有效
    output [31:0] data_sram_addr,  //ram 读写地址，字节寻址
    output [31:0] data_sram_wdata,  //ram 写数据
    input [31:0] data_sram_rdata  //ram 读数据
);
/*====================Variable Declaration====================*/
// FixedMapping Inputs--------------------------
// wire  [31:0]  VAddr;[port]
// FixedMapping Outputs       
wire  [31:0]  PAddr;
// ---------------------------------------------



// llr Inputs-----------------------------------       
wire  [31:0]  word_llr; 
// wire  [7:0]  onehot;[port]
// llr Outputs
wire  [31:0]  llr_data;
wire  [3:0]  llr_we;   
// ---------------------------------------------

// lubhw Inputs---------------------------------
wire  [31:0]  word_lubhw;     
wire  [1:0]  adrl_lubhw;
// wire  [4:0]  lubhw_con;[port] 

// lubhw Outputs        
wire  [31:0]  lubhw_out;
//----------------------------------------------

// other----------------------------------------
wire [31:0] DMin;
wire [3:0] DMW;
wire [31:0] DMout;
// ---------------------------------------------
/*====================Function Code====================*/
assign DMin = dm_data;
assign DMW = dm_we;
FixedMapping  u_FixedMapping (
    .VAddr                   ( VAddr   ),

    .PAddr                   ( PAddr   )
);


lubhw  u_lubhw (
    .word                    ( word_lubhw   ),
    .adrl_lubhw              ( adrl_lubhw   ),
    .lubhw_con               ( lubhw_con    ),

    .lubhw_out               ( lubhw_out    )
);
assign word_lubhw = DMout;
assign adrl_lubhw = VAddr[1:0];

llr  u_llr (
    .word                    ( word_llr   ),
    .onehot                  ( onehot     ),

    .llr_data                ( llr_data   ),
    .llr_we                  ( llr_we     )
);
assign word_llr = DMout;
assign wbdata = sel_wbdata[0] ? aluout : 
				sel_wbdata[1] ? lubhw_out :
                sel_wbdata[2] ? llr_data:NNPC_mem_wire;

assign reg_we_mem = (sel_wbdata[0]||sel_wbdata[1]||sel_wbdata[3]) ? 4'b1111 :
					      sel_wbdata[2] ? llr_we : 4'b0;
assign PC_mem = PC_mem_wire;

assign data_sram_en = rst_n;
assign data_sram_wen = dm_we;
assign data_sram_addr = PAddr;
assign data_sram_wdata = dm_data;
assign DMout = data_sram_rdata;
assign regnum_mem = regnum_mem_wire;
endmodule