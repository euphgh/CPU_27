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
	input  wire [4:0]  exe_sel_wbdata_in, //datar:{0:aluout,1:lubw,2:llr,3:NNPC,4:mf}
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
    //dataout
    output wire [31:0] mem_PC_out,
    output wire [31:0] mem_dm_data_out,
    output wire [4:0]  mem_wnum_out,
    output wire [2:0]  mem_sel_wbdata_out,
    output wire [7:0]  mem_onehot_out,
    output wire [4:0]  mem_lubhw_con_out,
    output wire [31:0] mem_adrl_out,
    output wire [2:0]  mem_write_type_out,
    output wire [31:0] mem_wbdata_out,
    output wire [3:0]  mem_llr_we_out,
    output wire mem_read_request_out,

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
wire [31:0] MEM_PC = mem_PC_out;
wire [31:0] mult_div_res_w;
wire  mult_div_to_mem_accessible_w;
// ---------------------------------------------
/*====================Function Code====================*/
assign ready = (exe_to_mem_sel_wbdata_r[4]&&mult_div_to_mem_accessible_w)||(!exe_to_mem_sel_wbdata_r[4]);
assign allowin =  (!valid_r) || (ready && wb_allowin_in) ;
assign mem_allowin_out = allowin;
assign mem_valid_out = ready && valid_r;
always @(posedge clk ) begin
    if (!rst_n) begin
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
    if (!rst_n||(allowin&&(!exe_valid_in))) begin
        exe_to_mem_sel_wbdata_r <= `ini_exe_sel_wbdata_in;
        exe_to_mem_aluout_r <= `ini_exe_aluout_in;
        exe_to_mem_onehot_r <= `ini_exe_onehot_in;
        exe_to_mem_lubhw_con_r <= `ini_exe_lubhw_con_in;
        exe_to_mem_PC_r <= `ini_exe_PC_in;
        exe_to_mem_NNPC_r <= `ini_exe_NNPC_in;
        exe_to_mem_regnum_r <= `ini_exe_regnum_in;
        exe_to_mem_write_type_r <= `ini_exe_write_type_in;
        exe_to_mem_read_request_r <= 1'b0;
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
assign mem_adrl_out = VAddr[1:0];
assign mem_dm_data_out = data_sram_rdata;
assign mem_lubhw_con_out = exe_to_mem_lubhw_con_r;
assign mem_dm_data_out = exe_to_mem_sel_wbdata_r[0] ? exe_to_mem_aluout_r :
                        exe_to_mem_sel_wbdata_r[3] ? exe_to_mem_NNPC_r : mult_div_res_w;
assign mem_sel_wbdata_out = {{exe_to_mem_sel_wbdata_r[1]||(|exe_to_mem_sel_wbdata_r[4:3])}, exe_to_mem_lubhw_con_r[2:1]};
assign mem_onehot_out = exe_to_mem_onehot_r;
assign mem_llr_we_out = llr_we;
assign data_sram_en = rst_n;
assign data_sram_wen =  exe_to_mem_dm_we_w;
assign data_sram_addr = PAddr;
assign data_sram_wdata = exe_to_mem_dm_data_w;
assign mem_wnum_out = exe_to_mem_regnum_r;
assign mem_write_type_out = exe_to_mem_write_type_r;
assign mem_read_request_out = exe_to_mem_read_request_r;
endmodule