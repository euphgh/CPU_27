`include "defines.vh"
/*====================Ports Declaration====================*/
module WB(
    //sys
	input  wire clk,rst_n,
    output wire wb_allowin_out,
    input  wire mem_valid_in,
    output wire wb_valid_out,
    //mem segment in
    input  wire [31:0] mem_PC_in, //datar:
    input  wire [31:0] mem_dm_data_in,
    input  wire [4:0]  mem_wnum_in,
    input  wire [2:0]  mem_sel_wbdata_in, //datar:{0:mem_wbdata_out,1:lubw,2:llr}
    input  wire [7:0]  mem_onehot_in, //datar:控制llr
    input  wire [4:0]  mem_lubhw_con_in, //datar:控制lubhw
    input  wire [1:0] mem_adrl_in, //dataw:
    input  wire [2:0]  mem_write_type_in,
    input  wire [31:0] mem_wbdata_in,
    input  wire [3:0]  mem_llr_we_in,
    input  wire  mem_exception_in,
    input  wire  mem_bd_in,
    input  wire  [4:0]  mem_ExcCode_in,
    input  wire  [7:0]  mem_cp0_addr_in,
    input  wire  [31:0]  mem_mtc0_data_in,
    input  wire  [31:0]  mem_error_VAddr_in,
    input  wire  mem_eret_in,
    input  wire  [1:0] mem_mftc0_op_in,//{0:mfc0,1:mtc0}
    //dataout
	output wire [31:0] wb_wbdata_out, //data:回写数据
	output wire [3:0]  wb_reg_we_out, //control:回写使能
    output wire [4:0]  wb_wnum_out,
    output wire [2:0]  wb_write_type_out,
    output wire  [31:0]  wb_cp0_res_out,
    output wire  wb_ClrStpJmp_out,
    //debug 信号， 供验证平台使用效
    output reg [31:0] debug_wb_pc,   //写回级（多周期最后一级） 的 PC， 因而需要 mycpu信号，高电平有效
    output reg [3:0]  debug_wb_rf_wen,   //写回级写寄存器堆(regfiles)的写使能，为字节写，字节寻址
    output reg [4:0]  debug_wb_rf_wnum,   //写回级写 regfiles 的目的寄存器号
    output reg [31:0] debug_wb_rf_wdata,   //写回级写 regfiles 的写数据
    input wire [5:0] ext_int
);
/*====================Variable Declaration====================*/

// other----------------------------------------
wire [31:0] WB_PC;
assign WB_PC = debug_wb_pc;
wire allowin,ready;
reg  valid_r;
reg [31:0] mem_to_wb_PC_r;
reg [31:0] mem_to_wb_dm_data_r;
reg [4:0]  mem_to_wb_wnum_r;
reg [2:0]  mem_to_wb_sel_wbdata_r;
reg [7:0]  mem_to_wb_onehot_r;
reg [4:0]  mem_to_wb_lubhw_con_r;
reg [1:0]  mem_to_wb_adrl_r;
reg [2:0]  mem_to_wb_write_type_r;
reg [31:0] mem_to_wb_wbdata_r;
reg [3:0]  mem_to_wb_llr_we_r;

reg  mem_to_wb_exception_r;
reg  mem_to_wb_bd_r;
reg  [4:0]  mem_to_wb_ExcCode_r;
reg  [7:0]  mem_to_wb_cp0_addr_r;
reg  [31:0]  mem_to_wb_mtc0_data_r;
reg  [31:0]  mem_to_wb_error_VAddr_r;
reg  mem_to_wb_eret_r;
reg  [1:0] mem_to_wb_mftc0_op_r;
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
wire [31:0] word; 
//----------------------------------------------
wire  [31:0]  cp0_res;
wire  ClrStpJmp;
/*====================Function Code====================*/
assign ready = 1'b1; 
assign allowin = (!valid_r) || ready || ClrStpJmp ;
assign wb_allowin_out = allowin;
assign wb_valid_out = ready && valid_r;
always @(posedge clk ) begin
    if (!rst_n) begin
        valid_r <= 1'b0;
    end 
    else if (allowin) begin
        valid_r <= mem_valid_in;
    end
end
always @(posedge clk) begin
    if (!rst_n||(allowin&&(!mem_valid_in))) begin
        mem_to_wb_PC_r <= `ini_mem_PC_in; 
        mem_to_wb_dm_data_r <= `ini_mem_dm_data_in;
        mem_to_wb_wnum_r <= `ini_mem_wnum_in; 
        mem_to_wb_sel_wbdata_r <= `ini_mem_sel_wbdata_in;  
        mem_to_wb_onehot_r <= `ini_mem_onehot_in;  
        mem_to_wb_lubhw_con_r <= `ini_mem_lubhw_con_in; 
        mem_to_wb_adrl_r <= `ini_mem_adrl_in;
        mem_to_wb_write_type_r <= `ini_mem_write_type_in; 
        mem_to_wb_wbdata_r <= `ini_mem_wbdata_in;
        mem_to_wb_llr_we_r <= `ini_mem_llr_we_in;
        mem_to_wb_exception_r <= `ini_mem_exception_in;
        mem_to_wb_bd_r <= `ini_mem_bd_in;
        mem_to_wb_ExcCode_r <= `ini_mem_ExcCode_in;
        mem_to_wb_cp0_addr_r <= `ini_mem_cp0_addr_in;
        mem_to_wb_mtc0_data_r <= `ini_mem_mtc0_data_in;
        mem_to_wb_error_VAddr_r <= `ini_mem_error_VAddr_in;
        mem_to_wb_eret_r <= `ini_mem_eret_in;
        mem_to_wb_mftc0_op_r <= `ini_mem_mftc0_op_in;
    end
    else if (allowin && mem_valid_in) begin
        mem_to_wb_PC_r <= mem_PC_in; 
        mem_to_wb_dm_data_r <= mem_dm_data_in;
        mem_to_wb_wnum_r <= mem_wnum_in; 
        mem_to_wb_sel_wbdata_r <= mem_sel_wbdata_in;  
        mem_to_wb_onehot_r <= mem_onehot_in;  
        mem_to_wb_lubhw_con_r <= mem_lubhw_con_in; 
        mem_to_wb_write_type_r <= mem_write_type_in; 
        mem_to_wb_adrl_r <= mem_adrl_in;
        mem_to_wb_wbdata_r <= mem_wbdata_in;
        mem_to_wb_llr_we_r <= mem_llr_we_in;
        mem_to_wb_exception_r <= mem_exception_in;
        mem_to_wb_bd_r <= mem_bd_in;
        mem_to_wb_ExcCode_r <= mem_ExcCode_in;
        mem_to_wb_cp0_addr_r <= mem_cp0_addr_in;
        mem_to_wb_mtc0_data_r <= mem_mtc0_data_in;
        mem_to_wb_error_VAddr_r <= mem_error_VAddr_in;
        mem_to_wb_eret_r <= mem_eret_in;
        mem_to_wb_mftc0_op_r <= mem_mftc0_op_in;
    end
end
assign word = mem_to_wb_dm_data_r;
assign onehot = mem_to_wb_onehot_r;
assign llr_data =   (onehot[2]||onehot[7]) ? {word[23:16],word[15:8],word[7:0],word[31:24]} :
                    (onehot[1]||onehot[6]) ? {word[15:0],word[31:16]} : 
                    (onehot[0]||onehot[5]) ? {word[7:0],word[31:24],word[23:16],word[15:8]} : word;
lubhw  u_lubhw (
    .word                    ( word_lubhw   ),
    .adrl_lubhw              ( adrl_lubhw   ),
    .lubhw_con               ( lubhw_con    ),

    .lubhw_out               ( lubhw_out    )
);
assign word_lubhw = mem_to_wb_dm_data_r;
assign adrl_lubhw = mem_to_wb_adrl_r;
assign lubhw_con = mem_to_wb_lubhw_con_r;
assign wb_wbdata_out = mem_to_wb_mftc0_op_r[0] ? cp0_res :
                        mem_to_wb_sel_wbdata_r[0] ? mem_to_wb_wbdata_r :
                        mem_to_wb_sel_wbdata_r[1] ? lubhw_out : llr_data;
assign wb_reg_we_out = (|mem_to_wb_sel_wbdata_r[1:0]||mem_to_wb_mftc0_op_r[0]) ? 4'b1111:
                        mem_to_wb_sel_wbdata_r[2] ?  mem_to_wb_llr_we_r : 4'b0;
assign wb_wnum_out = mem_to_wb_wnum_r;
assign wb_write_type_out = mem_to_wb_write_type_r;
always @(posedge clk ) begin
    if(!rst_n) begin
        debug_wb_pc <= `debug_wb_pc;
        debug_wb_rf_wen <=  `debug_wb_rf_wen;
        debug_wb_rf_wnum <= `debug_wb_rf_wnum;
        debug_wb_rf_wdata <= `debug_wb_rf_wdata;
    end
    else begin
        debug_wb_pc <= mem_to_wb_PC_r;
        debug_wb_rf_wen <=  wb_reg_we_out;
        debug_wb_rf_wnum <= wb_wnum_out;
        debug_wb_rf_wdata <= wb_wbdata_out;
    end
end
// CP0 Inputs
// wire  clk;[port]
// wire  rst_n;[port]
// wire  mem_to_wb_exception_r;[pileline]
// wire  mem_to_wb_bd_r;[pileline]
// wire  [4:0]  mem_to_wb_ExcCode_r;[pileline]
// wire  [5:0]  mem_to_wb_cp0_addr_r;[pileline]
// wire  [31:0]  mem_to_wb_mtc0_data_r;[pileline]
// wire  [31:0]  mem_to_wb_error_VAddr_r;[pileline]
// wire  mem_to_wb_eret_r;[pileline]
// wire  mem_to_wb_mftc0_op_r;[pileline]
// wire  [31:0]  mem_to_wb_PC_r;[pileline]
// wire  valid_r;[pileline]

// CP0 Outputs        

CP0  u_CP0 (
    .clk                      ( clk                       ),
    .rst_n                    ( rst_n                     ),
    .mem_to_wb_exception_r    ( mem_to_wb_exception_r     ),
    .mem_to_wb_bd_r           ( mem_to_wb_bd_r            ),
    .mem_to_wb_ExcCode_r      ( mem_to_wb_ExcCode_r       ),
    .mem_to_wb_cp0_addr_r     ( mem_to_wb_cp0_addr_r      ),
    .mem_to_wb_mtc0_data_r    ( mem_to_wb_mtc0_data_r     ),
    .mem_to_wb_PC_r           ( mem_to_wb_PC_r            ),
    .mem_to_wb_error_VAddr_r  ( mem_to_wb_error_VAddr_r   ),
    .mem_to_wb_eret_r         ( mem_to_wb_eret_r          ),
    .mem_to_wb_mftc0_op_r     ( mem_to_wb_mftc0_op_r      ),
    .valid_r                  ( valid_r                   ),
    .ext_int                  ( ext_int                   ),

    .cp0_res                  ( cp0_res                   ),
    .ClrStpJmp                ( ClrStpJmp                 )
);
assign wb_ClrStpJmp_out = ClrStpJmp;
assign wb_cp0_res_out = cp0_res;
endmodule