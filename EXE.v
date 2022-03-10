`include "defines.vh"
/*====================Ports Declaration====================*/
module EXE(
    //sys
	input wire  clk,rst_n,
    input wire  mem_allowin_in,
    output wire exe_allowin_out,
    input wire  id_valid_in,
    output wire exe_valid_out,
    //datain
 	input wire [2:0]  id_sbhw_con_in, //datar:sbhw模块选择子
	input wire [3:0]  id_addrexc_con_in, //datar:地址例外选择子
	input wire [4:0]  id_sel_wbdata_in, //datar:与ID段sel_wbdata_id_reg相连，直接输出sel_wbdata_exe_reg
	input wire [11:0] id_aluop_in, //datar:
	input wire [31:0] id_RD2_in, //datar:传送给swbh模块的数据
	input wire [31:0] id_aludata1_in, //datar:
	input wire [31:0] id_aludata2_in, //datar:
	input wire [1:0]  id_sel_dm_con_in, //datar:选择使用slr还是sbhw模块的数据写入存储器--{0:sbhw,1:slr}
	input wire [1:0]  id_lr_con_in, //datar:onehot模块选择子
	input wire [4:0]  id_lubhw_con_in, //datar:与ID段lubhw_con_id_reg相连，直接输出lubhw_con_exe_reg
    input wire [31:0] id_PC_in, //datar:
    input wire [31:0] id_NNPC_in, //datar:
    input wire [4:0]  id_regnum_in, //datar:
    input wire [2:0]  id_write_type_in, //datar:
    input wire [7:0]  id_mult_div_op_in,
    input wire  id_exception_in,
    input wire  id_bd_in,
    input wire  [4:0]  id_ExcCode_in,
    input wire  [5:0]  id_cp0_addr_in,
    input wire  [31:0]  id_error_VAddr_in,
    input wire  id_eret_in,
    input wire  [1:0] id_mftc0_op_in,
    input wire  wb_ClrStpJmp_in,
	//dataout
	output wire [31:0] exe_alures_out, //data:传送给sel_wb
	output wire [4:0]  exe_sel_wbdata_out, //contrl: sel_wbdata选择子
	output wire [4:0]  exe_lubhw_con_out, //control:lubw模块的选择子,由上一段接下来
    output wire [31:0] exe_PC_out,
    output wire [31:0] exe_NNPC_out,
	output wire [7:0]  exe_onehot_out, //control:llr模块选择子
	output wire [31:0] exe_dm_data_out, //data:直接在EXE进行选择，并且不停止，直接传输DIN
	output wire [3:0]  exe_dm_we_out, //control:直接在EXE进行选择，并且不停止，直接传输DMW
	output wire [31:0] exe_dm_addr_out, //address:不停止，直接传输DA
    output wire [4:0]  exe_wnum_out,
    output wire [2:0]  exe_write_type_out,
    output wire [31:0] exe_in0_out,
    output wire [31:0] exe_in1_out,
    output wire [5:0]  exe_mult_div_op_out,
    output wire exe_read_request_out,
    output wire  exe_exception_out,
    output wire  exe_bd_out,
    output wire  [4:0]  exe_ExcCode_out,
    output wire  [5:0]  exe_cp0_addr_out,
    output wire  [31:0]  exe_mtc0_data_out,
    output wire  [31:0]  exe_error_VAddr_out,
    output wire  exe_eret_out,
    output wire  [1:0] exe_mftc0_op_out
	);
/*====================Variable Declaration====================*/
// ALU Inputs------------------------------------      
wire [31:0]  scr0; 
wire [31:0]  scr1; 
wire [11:0]  aluop; 

// ALU Outputs
wire  overflow;
wire  [31:0]  aluso;
//----------------------------------------------

// sbhw Inputs----------------------------------        
// wire [31:0]  RD2;[slr]    
wire [2:0]  sbhw_con; 

// sbhw Outputs
wire  [31:0]  sbhw_data;
wire  [3:0]  sbhw_we;
//----------------------------------------------

// lr_onehot Inputs----------------------------- 
wire  [1:0]  adlr;  
wire  [1:0]  lr_con;

// lr_onehot Outputs
wire  [7:0]  onehot;
//----------------------------------------------

// slr Inputs ----------------------------------    
wire  [31:0]  RD2;
// wire  [7:0]  onehot;[lr_onehot]

// slr Outputs
wire  [31:0]  slr_data;
wire  [3:0]  slr_we;
// ---------------------------------------------

// addrexc Inputs ------------------------------       
wire  [31:0]  address;  
wire  [3:0]  addrexc_con;

// addrexc Outputs
wire  ExceptSet;
wire  [4:0]  ExcCode;
// ---------------------------------------------

// other----------------------------------------
wire allowin;
reg valid_r;
wire ready;
wire [31:0] aluout_exe_wire;
reg  [2:0] id_to_exe_sbhw_con_r ;
reg  [3:0] id_to_exe_addrexc_con_r ;
reg  [4:0] id_to_exe_sel_wbdata_r ;
reg  [11:0] id_to_exe_aluop_r ;
reg  [31:0] id_to_exe_RD2_r ;
reg  [31:0] id_to_exe_aludata1_r ;
reg  [31:0] id_to_exe_aludata2_r ;
reg  [1:0] id_to_exe_sel_dm_con_r ;
reg  [1:0] id_to_exe_lr_con_r ;
reg  [4:0] id_to_exe_lubhw_con_r ;
reg  [31:0] id_to_exe_PC_r ;
reg  [31:0] id_to_exe_NNPC_r ;
reg  [4:0] id_to_exe_regnum_r ;
reg  [2:0] id_to_exe_write_type_r ;
reg  [7:0] id_to_exe_mult_div_op_r;
wire [31:0] EXE_PC = exe_PC_out;
reg  id_to_exe_exception_r;
reg  id_to_exe_bd_r;
reg  [4:0]  id_to_exe_ExcCode_r;
reg  [5:0]  id_to_exe_cp0_addr_r;
reg  [31:0]  id_to_exe_error_VAddr_r;
reg  id_to_exe_eret_r;
reg  [1:0] id_to_exe_mftc0_op_r;
//----------------------------------------------

/*====================Function Code====================*/
always @(posedge clk ) begin
    if (!rst_n||wb_ClrStpJmp_in) begin
        valid_r <= 1'b0;
    end else if (allowin) begin
        valid_r <= id_valid_in;
    end
end
assign ready = 1'b1;//之后由乘除法决定
assign allowin = !valid_r || (ready && mem_allowin_in);
assign exe_allowin_out = allowin;
assign exe_valid_out = valid_r && ready;

always @(posedge clk) begin
    if (!rst_n ||(allowin&&(!id_valid_in))||wb_ClrStpJmp_in) begin
        id_to_exe_sbhw_con_r <= `ini_id_sbhw_con_in;
        id_to_exe_addrexc_con_r <= `ini_id_addrexc_con_in;
        id_to_exe_sel_wbdata_r <= `ini_id_sel_wbdata_in;
        id_to_exe_aluop_r <= `ini_id_aluop_in;
        id_to_exe_RD2_r <= `ini_id_RD2_in;
        id_to_exe_aludata1_r <= `ini_id_aludata1_in;
        id_to_exe_aludata2_r <= `ini_id_aludata2_in;
        id_to_exe_sel_dm_con_r <= `ini_id_sel_dm_con_in;
        id_to_exe_lr_con_r <= `ini_id_lr_con_in;
        id_to_exe_lubhw_con_r <= `ini_id_lubhw_con_in;
        id_to_exe_PC_r <= `ini_id_PC_in;
        id_to_exe_NNPC_r <= `ini_id_NNPC_in;
        id_to_exe_regnum_r <= `ini_id_regnum_in;
        id_to_exe_write_type_r <= `ini_id_write_type_in;
        id_to_exe_mult_div_op_r <= `ini_id_mul_div_op;
        id_to_exe_exception_r <= `ini_id_exception_in;
        id_to_exe_bd_r <= `ini_id_bd_in;
        id_to_exe_ExcCode_r <= `ini_id_ExcCode_in;
        id_to_exe_cp0_addr_r <= `ini_id_cp0_addr_in;
        id_to_exe_error_VAddr_r <= `ini_id_error_VAddr_in;
        id_to_exe_eret_r <= `ini_id_eret_in;
        id_to_exe_mftc0_op_r <= `ini_id_mftc0_op_in;
    end
    else if (allowin && id_valid_in) begin
        id_to_exe_sbhw_con_r <= id_sbhw_con_in;
        id_to_exe_addrexc_con_r <= id_addrexc_con_in;
        id_to_exe_sel_wbdata_r <= id_sel_wbdata_in;
        id_to_exe_aluop_r <= id_aluop_in;
        id_to_exe_RD2_r <= id_RD2_in;
        id_to_exe_aludata1_r <= id_aludata1_in;
        id_to_exe_aludata2_r <= id_aludata2_in;
        id_to_exe_sel_dm_con_r <= id_sel_dm_con_in;
        id_to_exe_lr_con_r <= id_lr_con_in;
        id_to_exe_lubhw_con_r <= id_lubhw_con_in;
        id_to_exe_PC_r <= id_PC_in;
        id_to_exe_NNPC_r <= id_NNPC_in;
        id_to_exe_regnum_r <= id_regnum_in;
        id_to_exe_write_type_r <= id_write_type_in;
        id_to_exe_mult_div_op_r <= id_mult_div_op_in;
        id_to_exe_exception_r <= id_exception_in;
        id_to_exe_bd_r <= id_bd_in;
        id_to_exe_ExcCode_r <= id_ExcCode_in;
        id_to_exe_cp0_addr_r <= id_cp0_addr_in;
        id_to_exe_error_VAddr_r <= id_error_VAddr_in;
        id_to_exe_eret_r <= id_eret_in;
        id_to_exe_mftc0_op_r <= id_mftc0_op_in;
    end 
end

ALU  u_ALU (
    .scr0                    ( scr0       ),
    .scr1                    ( scr1       ),
    .aluop                   ( aluop      ),

    .overflow                ( overflow   ),
    .aluso                   ( aluso      ) 
);
assign scr0 = id_to_exe_aludata1_r;
assign scr1 = id_to_exe_aludata2_r;
assign exe_alures_out = aluso;
sbhw  u_sbhw (
    .RD2                     ( RD2         ),
    .sbhw_con                ( sbhw_con    ),
    .adlr                    ( adlr        ),

    .sbhw_data               ( sbhw_data   ),
    .sbhw_we                 ( sbhw_we     ) 
);
assign RD2 = id_to_exe_RD2_r;
assign sbhw_con = id_to_exe_sbhw_con_r;
lr_onehot  u_lr_onehot (
    .adlr                    ( adlr     ),
    .lr_con                  ( lr_con   ),

    .onehot                  ( onehot   ) 
);
assign aluop = id_to_exe_aluop_r;
assign adlr = aluso[1:0];
assign lr_con = id_to_exe_lr_con_r;
slr  u_slr (
    .RD2                     ( RD2        ),
    .onehot                  ( onehot     ),

    .slr_data                ( slr_data   ),
    .slr_we                  ( slr_we     ) 
);
addrexc  u_addrexc (
    .address                 ( address      ),
    .addrexc_con             ( addrexc_con  ),

    .ExceptSet               ( ExceptSet    ),
    .ExcCode                 ( ExcCode      ) 
);
assign address = aluso;
assign addrexc_con = id_to_exe_addrexc_con_r;
assign exe_dm_data_out = id_to_exe_sel_dm_con_r[0] ? sbhw_data : slr_data;

assign exe_dm_we_out = (id_to_exe_sel_dm_con_r[0] ? sbhw_we : 
				        id_to_exe_sel_dm_con_r[1] ? slr_we : 4'b0000)&{4{exe_valid_out}};//从发射的角度来看

assign exe_dm_addr_out = aluso;
assign exe_PC_out = id_to_exe_PC_r;
assign exe_NNPC_out = id_to_exe_NNPC_r;
assign exe_lubhw_con_out = id_to_exe_lubhw_con_r;
assign exe_sel_wbdata_out = id_to_exe_sel_wbdata_r;
assign exe_onehot_out = onehot;
assign exe_wnum_out = id_to_exe_regnum_r ;
assign exe_write_type_out = id_to_exe_write_type_r;
assign exe_in0_out = id_to_exe_aludata1_r;
assign exe_in1_out = id_to_exe_aludata2_r;
assign exe_mult_div_op_out = {id_to_exe_mult_div_op_r[7:6],id_to_exe_mult_div_op_r[3:0]};
assign exe_read_request_out = id_to_exe_mult_div_op_r[4];
assign exe_exception_out = overflow||ExceptSet||id_to_exe_exception_r;
assign exe_bd_out = id_to_exe_bd_r;
assign exe_ExcCode_out = id_to_exe_exception_r ? id_to_exe_ExcCode_r : (overflow ? `Ov : ExcCode);
assign exe_cp0_addr_out = id_to_exe_cp0_addr_r;
assign exe_mtc0_data_out = id_to_exe_aludata2_r;
assign exe_error_VAddr_out = id_to_exe_exception_r ? id_to_exe_error_VAddr_r : aluso ;
assign exe_eret_out = id_to_exe_eret_r ;
assign exe_mftc0_op_out = id_to_exe_mftc0_op_r;
endmodule