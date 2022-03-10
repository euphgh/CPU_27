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
	input  wire [4:0]  exe_sel_wbdata_in, //datar:{0:aluout,1:lubw,2:llr,3:NNPC,4:mfhiol}
	input  wire [31:0] exe_aluout_in, //datar:地址或者回写数据
	input  wire [7:0]  exe_onehot_in, //datar:控制llr
	input  wire [4:0]  exe_lubhw_con_in, //datar:控制lubhw
	input  wire [31:0] exe_dm_data_in, //dataw:
	input  wire [3:0]  exe_dm_we_in, //dataw:
    input  wire [31:0] exe_VAddr_in, //dataw:
    input  wire [31:0] exe_PC_in, //datar:
    input  wire [4:0]  exe_regnum_in, //datar:
    input  wire [31:0] exe_NNPC_in, //datar:
    input  wire [2:0]  exe_write_type_in,
    input  wire [31:0] mult_div_res_in, //dataw:
    input  wire mult_div_accessible_in, //dataw:表示此时hilo的数据是否有效
    input  wire exe_read_request_in,
    input  wire  exe_exception_in,
    input  wire  exe_bd_in,
    input  wire  [4:0]  exe_ExcCode_in,
    input  wire  [5:0]  exe_cp0_addr_in,
    input  wire  [31:0]  exe_mtc0_data_in,
    input  wire  [31:0]  exe_error_VAddr_in,
    input  wire  exe_eret_in,
    input  wire  [1:0] exe_mftc0_op_in,
    input wire  wb_ClrStpJmp_in,
    //dataout
    output wire [31:0] mem_PC_out,
    output wire [31:0] mem_dm_data_out,
    output wire [4:0]  mem_wnum_out,
    output wire [2:0]  mem_sel_wbdata_out,
    output wire [7:0]  mem_onehot_out,
    output wire [4:0]  mem_lubhw_con_out,
    output wire [1:0] mem_adrl_out,
    output wire [2:0]  mem_write_type_out,
    output wire [31:0] mem_wbdata_out,
    output wire [3:0]  mem_llr_we_out,
    output wire mem_read_request_out,
    output wire  mem_exception_out,
    output wire  mem_bd_out,
    output wire  [4:0]  mem_ExcCode_out,
    output wire  [5:0]  mem_cp0_addr_out,
    output wire  [31:0]  mem_mtc0_data_out,
    output wire  [31:0]  mem_error_VAddr_out,
    output wire  mem_eret_out,
    output wire  [1:0] mem_mftc0_op_out,

    output wire data_sram_en, //ram 使能信号,高电平有效
    output wire [3:0]  data_sram_wen, //ram 字节写使能信号,高电平有效
    output wire [31:0] data_sram_addr,  //ram 读写地址,字节寻址
    output wire [31:0] data_sram_wdata,  //ram 写数据
    input  wire [31:0] data_sram_rdata  //ram 读数据
);
/*====================Variable Declaration====================*/
// FixedMapping Inputs--------------------------
wire  [31:0]  VAddr;
// FixedMapping Outputs       
wire  [31:0]  PAddr;
// ---------------------------------------------      
wire  [7:0]  onehot;
wire  [3:0]  llr_we;   
// other----------------------------------------
wire allowin,ready;
wire [3:0]  exe_to_mem_dm_we_w ;
wire [31:0] exe_to_mem_VAddr_w ;
wire [31:0] exe_to_mem_dm_data_w;
reg  valid_r;

reg  [4:0] exe_to_mem_sel_wbdata_r ;
reg  [31:0] exe_to_mem_aluout_r ;
reg  [7:0] exe_to_mem_onehot_r ;
reg  [4:0] exe_to_mem_lubhw_con_r ;
reg  [31:0] exe_to_mem_PC_r ;
reg  [31:0] exe_to_mem_NNPC_r ;
reg  [4:0] exe_to_mem_regnum_r ;
reg  [2:0]  exe_to_mem_write_type_r;
reg  exe_to_mem_read_request_r;
reg  exe_to_mem_exception_r;
reg  exe_to_mem_bd_r;
reg  [4:0]  exe_to_mem_ExcCode_r;
reg  [5:0]  exe_to_mem_cp0_addr_r;
reg  [31:0]  exe_to_mem_mtc0_data_r;
reg  [31:0]  exe_to_mem_error_VAddr_r;
reg  exe_to_mem_eret_r;
reg  [1:0] exe_to_mem_mftc0_op_r;
wire [31:0] MEM_PC = mem_PC_out;
wire [31:0] mult_div_res_w;
wire  mult_div_to_mem_accessible_w;
wire mem_ClrStpJmp_w,mem_ClrStpJmp_r;
// ---------------------------------------------
/*====================Function Code====================*/
assign ready = (exe_to_mem_sel_wbdata_r[4]&&mult_div_to_mem_accessible_w)||(!exe_to_mem_sel_wbdata_r[4]);
assign allowin =  (!valid_r) || (ready && wb_allowin_in) ;
assign mem_allowin_out = allowin;
assign mem_valid_out = ready && valid_r;
always @(posedge clk ) begin
    if (!rst_n||wb_ClrStpJmp_in) begin
        valid_r <= 1'b0;
    end else if (allowin) begin
        valid_r <= exe_valid_in;
    end
end
assign exe_to_mem_dm_data_w = exe_dm_data_in ;
assign exe_to_mem_dm_we_w = exe_dm_we_in ;
assign exe_to_mem_VAddr_w = exe_VAddr_in ;

assign mult_div_res_w = mult_div_res_in;
assign mult_div_to_mem_accessible_w = mult_div_accessible_in;
always @(posedge clk) begin
    if (!rst_n||(allowin&&(!exe_valid_in))||wb_ClrStpJmp_in) begin
        exe_to_mem_sel_wbdata_r <= `ini_exe_sel_wbdata_in;
        exe_to_mem_aluout_r <= `ini_exe_aluout_in;
        exe_to_mem_onehot_r <= `ini_exe_onehot_in;
        exe_to_mem_lubhw_con_r <= `ini_exe_lubhw_con_in;
        exe_to_mem_PC_r <= `ini_exe_PC_in;
        exe_to_mem_NNPC_r <= `ini_exe_NNPC_in;
        exe_to_mem_regnum_r <= `ini_exe_regnum_in;
        exe_to_mem_write_type_r <= `ini_exe_write_type_in;
        exe_to_mem_read_request_r <= 1'b0;
        exe_to_mem_exception_r <= `ini_exe_exception_in;
        exe_to_mem_bd_r <= `ini_exe_bd_in;
        exe_to_mem_ExcCode_r <= `ini_exe_ExcCode_in;
        exe_to_mem_cp0_addr_r <= `ini_exe_cp0_addr_in;
        exe_to_mem_mtc0_data_r <= `ini_exe_mtc0_data_in;
        exe_to_mem_error_VAddr_r <= `ini_exe_error_VAddr_in;
        exe_to_mem_eret_r <= `ini_exe_eret_in;
        exe_to_mem_mftc0_op_r <= `ini_exe_mftc0_op_in;
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
        exe_to_mem_read_request_r <= exe_read_request_in;
        exe_to_mem_exception_r <= exe_exception_in;
        exe_to_mem_bd_r <= exe_bd_in;
        exe_to_mem_ExcCode_r <= exe_ExcCode_in;
        exe_to_mem_cp0_addr_r <= exe_cp0_addr_in;
        exe_to_mem_mtc0_data_r <= exe_mtc0_data_in;
        exe_to_mem_error_VAddr_r <= exe_error_VAddr_in;
        exe_to_mem_eret_r <= exe_eret_in;
        exe_to_mem_mftc0_op_r <= exe_mftc0_op_in;
    end
end
FixedMapping  u_FixedMapping (
    .VAddr                   ( VAddr   ),

    .PAddr                   ( PAddr   )
);
assign VAddr = exe_to_mem_VAddr_w;
assign onehot = exe_to_mem_onehot_r;
assign llr_we = onehot[7] ? 4'b0001 :
                onehot[6] ? 4'b0011 :
                onehot[5] ? 4'b0111 :
                (onehot[3]||onehot[4]) ? 4'b1111 :
                onehot[2] ? 4'b1110 :
                onehot[1] ? 4'b1100 :
                onehot[0] ? 4'b1000 : 4'b0;  
assign mem_PC_out = exe_to_mem_PC_r;
assign mem_adrl_out = exe_to_mem_aluout_r[1:0];
assign mem_dm_data_out = data_sram_rdata;
assign mem_lubhw_con_out = exe_to_mem_lubhw_con_r;
assign mem_wbdata_out = exe_to_mem_sel_wbdata_r[0] ? exe_to_mem_aluout_r :
                        exe_to_mem_sel_wbdata_r[3] ? exe_to_mem_NNPC_r : mult_div_res_w;
assign mem_sel_wbdata_out = {exe_to_mem_sel_wbdata_r[2:1],{exe_to_mem_sel_wbdata_r[0]||(|exe_to_mem_sel_wbdata_r[4:3])}};
assign mem_onehot_out = exe_to_mem_onehot_r;
assign mem_llr_we_out = llr_we;
assign data_sram_en = rst_n;
assign mem_ClrStpJmp_w = exe_eret_in||exe_exception_in;
assign mem_ClrStpJmp_r = exe_to_mem_eret_r||exe_to_mem_exception_r;
assign data_sram_wen =  exe_to_mem_dm_we_w & {4{!(mem_ClrStpJmp_w||mem_ClrStpJmp_r)}};
assign data_sram_addr = PAddr;
assign data_sram_wdata = exe_to_mem_dm_data_w;
assign mem_wnum_out = exe_to_mem_regnum_r;
assign mem_write_type_out = exe_to_mem_write_type_r;
assign mem_read_request_out = exe_to_mem_read_request_r;
assign mem_exception_out = exe_to_mem_exception_r;
assign mem_bd_out = exe_to_mem_bd_r;
assign mem_ExcCode_out = exe_to_mem_ExcCode_r;
assign mem_cp0_addr_out = exe_to_mem_cp0_addr_r;
assign mem_mtc0_data_out = exe_to_mem_mtc0_data_r;
assign mem_error_VAddr_out = exe_to_mem_error_VAddr_r;
assign mem_eret_out = exe_to_mem_eret_r;
assign mem_mftc0_op_out = exe_to_mem_mftc0_op_r;
endmodule