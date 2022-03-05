`include "defines.vh"
/*====================Ports Declaration====================*/
module datapath (
    input wire clk,rst_n,
    // 
    output  wire  inst_sram_en,  //!ram 使能信号，高电平有效
    output  wire [3:0] inst_sram_wen,  //!ram 字节写使能信号，高电平有效
    output  wire [31:0] inst_sram_addr,  //!ram 读写地址，字节寻址
    output  wire [31:0] inst_sram_wdata,  //ram 写数据
    input  wire [31:0] inst_sram_rdata, //ram 读数据

    output wire data_sram_en, //ram 使能信号，高电平有效
    output wire [3 :0] data_sram_wen, //ram 字节写使能信号，高电平有效
    output wire [31:0] data_sram_addr,  //ram 读写地址，字节寻址
    output wire [31:0] data_sram_wdata,  //ram 写数据
    input wire [31:0] data_sram_rdata,  //ram 读数据
    input wire [5:0] ext_int,

    //debug 信号， 供验证平台使用
    output wire [31:0] debug_wb_pc,   //写回级（多周期最后一级） 的 PC， 因而需要 mycpu 里将 PC 一路带到写回级
    output wire [3:0] debug_wb_rf_wen,   //写回级写寄存器堆(regfiles)的写使能，为字节写使能，如果 mycpu 写 regfiles为单字节写使能，则将写使能扩展成 4 位即可。
    output wire [4:0] debug_wb_rf_wnum,   //写回级写 regfiles 的目的寄存器号
    output wire [31:0] debug_wb_rf_wdata   //写回级写 regfiles 的写数据

    );
/*====================Variable Declaration====================*/
// IF Inputs ------------------------------------
// wire  clk;[port]
// wire  rst_n;[port]
wire  id_allowin_in;
wire  id_brcal_res_in;        
wire  [31:0]  id_bjpc_res_in;    
// wire  [31:0]  inst_sram_rdata;[port]

// IF Outputs
wire  if_valid_out;
wire  [31:0]  if_PC_out;
wire  [31:0]  if_NPC_out;
wire  [31:0]  if_NNPC_out;
wire  [31:0]  if_Instruct_out;
// wire  [31:0]  inst_sram_wdata;[port]
// wire  [3:0]  inst_sram_wen;[port]
// wire  [31:0]  inst_sram_addr;[port]
//----------------------------------------------

// ID Inputs -----------------------------------
// wire  clk;[port]
// wire  rst_n;[port]
wire  exe_allowin_in;        
wire  if_valid_in;
wire  [31:0]  if_PC_in;      
wire  [31:0]  if_NPC_in;     
wire  [31:0]  if_NNPC_in;    
wire  [31:0]  if_Instruct_in;
wire  [31:0]  wb_wdata_in;   
wire  [3:0]  wb_wen_in;      
wire  [4:0]  wb_wnum_in;     
wire  [2:0]  exe_write_type; 
wire  [2:0]  mem_write_type; 
wire  [2:0]  wb_write_type;  
wire  [4:0]  exe_wnum;
wire  [4:0]  mem_wnum;
wire  [4:0]  wb_wnum;

// ID Outputs
wire  id_allowin_out;
wire  id_valid_out;
wire  [4:0]  id_sel_wbdata_out;
wire  [1:0]  id_sel_dm_out;
wire  [31:0]  id_RD2_out;
wire  [11:0]  id_aluop_out;
wire  [31:0]  id_aludata1_out;
wire  [31:0]  id_aludata2_out;
wire  [2:0]  id_sbhw_con_out;
wire  [4:0]  id_regnum_out;
wire  [31:0]  id_NNPC_out;
wire  [31:0]  id_PC_out;
wire  [3:0]  id_addrexc_con_out;
wire  [1:0]  id_lr_con_out;
wire  [4:0]  id_lubhw_con_out;
wire  id_brcal_res_out;
wire  [31:0]  id_bjpc_res_out;
wire  [2:0]  id_write_type_out;
wire  [7:0]  id_mult_div_op;
//----------------------------------------------

// EXE Inputs ----------------------------------
// wire  clk;   [port]
// wire  rst_n;[port]
wire  mem_allowin_in;
wire  id_valid_in;
wire  [2:0]  id_sbhw_con_in;
wire  [3:0]  id_addrexc_con_in;
wire  [4:0]  id_sel_wbdata_in;
wire  [11:0]  id_aluop_in;
wire  [31:0]  id_RD2_in;
wire  [31:0]  id_aludata1_in;
wire  [31:0]  id_aludata2_in;
wire  [1:0]  id_sel_dm_con_in;
wire  [1:0]  id_lr_con_in;
wire  [4:0]  id_lubhw_con_in;
wire  [31:0]  id_PC_in;
wire  [31:0]  id_NNPC_in;
wire  [4:0]  id_regnum_in;
wire  [2:0]  id_write_type_in;
wire  [7:0]  id_mult_div_op_in;
// EXE Outputs
wire  exe_allowin_out;
wire  exe_valid_out;
wire  [31:0]  exe_alures_out;
wire  [4:0]  exe_sel_wbdata_out;
wire  [4:0]  exe_lubhw_con_out;
wire  [31:0]  exe_PC_out;
wire  [31:0]  exe_NNPC_out;
wire  [4:0]  exe_regnum_out;
wire  [7:0]  exe_onehot_out;
wire  [31:0]  exe_dm_data_out;
wire  [3:0]  exe_dm_we_out;
wire  [31:0]  exe_dm_addr_out;
wire  [4:0]  exe_wnum_out;
wire  [2:0]  exe_write_type_out;
wire  [5:0]  exe_mult_div_op_out;
wire  [31:0]  exe_in0_out;        
wire  [31:0]  exe_in1_out;        
wire  exe_read_request_out;
//----------------------------------------------

// MEM Inputs ----------------------------------
// wire  clk;[port]
// wire  rst_n;[port]
wire  exe_valid_in;
wire  [4:0]  exe_sel_wbdata_in;
wire  [31:0]  exe_aluout_in;   
wire  [7:0]  exe_onehot_in;    
wire  [4:0]  exe_lubhw_con_in; 
wire  [31:0]  exe_dm_data_in;  
wire  [3:0]  exe_dm_we_in;     
wire  [31:0]  exe_VAddr_in;    
wire  [31:0]  exe_PC_in;       
wire  [31:0]  exe_NNPC_in;     
wire  [4:0]  exe_regnum_in;    
wire  wb_allowin_in;
wire  [2:0]  exe_write_type_in;
wire  exe_read_request_in;
// wire  [31:0]  data_sram_rdata; [port]

// MEM Outputs
// wire  data_sram_en;[port]
// wire  [3:0]  data_sram_wen;[port]
// wire  [31:0]  data_sram_addr;[port]
// wire  [31:0]  data_sram_wdata;[port]
wire  mem_allowin_out;
wire  mem_valid_out;
wire  [31:0]  mem_wbdata_out;
wire  [3:0]  mem_reg_we_out;
wire  [31:0]  mem_PC_out;
wire  [4:0]  mem_wnum_out;
wire  [2:0]  mem_write_type_out;
wire  mult_div_accessible_in;
wire  [31:0]  mult_div_res_in;
wire  mem_read_request_out;
//----------------------------------------------

// WB Inputs -----------------------------------
// wire  clk;[port]
// wire  rst_n;[port]
wire  mem_valid_in;
wire  [31:0]  mem_wbdata_in;   
wire  [3:0]  mem_reg_we_in;    
wire  [31:0]  mem_PC_in;       
wire  [4:0]  mem_wnum_in;      
wire  [2:0]  mem_write_type_in;

// WB Outputs
wire  wb_allowin_out;
wire  wb_valid_out;
wire  [31:0]  wb_wbdata_out;
wire  [3:0]  wb_reg_we_out;
wire  [4:0]  wb_wnum_out;
wire  [2:0]  wb_write_type_out;
// wire  [31:0]  debug_wb_pc;[port]
// wire  [3:0]  debug_wb_rf_wen;[port]
// wire  [4:0]  debug_wb_rf_wnum;[port]
// wire  [31:0]  debug_wb_rf_wdata;[port]
wire [4:0] wb_wnum_reg_out;
//----------------------------------------------
// mult_div Inputs -----------------------------
// wire  clk;[port]
// wire  rst_n;[port]
wire  [5:0]  mult_div_op;
wire  [31:0]  in0;       
wire  [31:0]  in1;       

// mult_div Outputs
wire  [31:0]  mult_div_res;
wire  accessible;
//-----------------------------------------------
wire [31:0] PC_IF,PC_ID,PC_EXE,PC_MEM,PC_WB,Instruct;
assign PC_IF = if_PC_out;
assign PC_ID = id_PC_out;
assign PC_EXE = exe_PC_out;
assign PC_MEM = mem_PC_out;
assign PC_WB = debug_wb_pc;
assign Instruct = if_Instruct_out;
/*====================Function Code====================*/
IF  u_IF (
    .clk                     ( clk               ),
    .rst_n                   ( rst_n             ),
    .id_allowin_in           ( id_allowin_in     ),
    .id_brcal_res_in         ( id_brcal_res_in   ),
    .id_bjpc_res_in          ( id_bjpc_res_in    ),
    .inst_sram_rdata         ( inst_sram_rdata   ),

    .if_valid_out            ( if_valid_out      ),
    .if_PC_out               ( if_PC_out         ),
    .if_NPC_out              ( if_NPC_out        ),
    .if_NNPC_out             ( if_NNPC_out       ),
    .if_Instruct_out         ( if_Instruct_out   ),
    .inst_sram_wdata         ( inst_sram_wdata   ),
    .inst_sram_wen           ( inst_sram_wen     ),
    .inst_sram_addr          ( inst_sram_addr    ),
    .inst_sram_en            ( inst_sram_en      )
);
assign if_PC_in       = if_PC_out;
assign if_NNPC_in     = if_NNPC_out;
assign if_Instruct_in = if_Instruct_out;
assign if_valid_in    = if_valid_out;
assign if_NPC_in      = if_NPC_out;
ID  u_ID (
    .clk                     ( clk                  ),
    .rst_n                   ( rst_n                ),
    .exe_allowin_in          ( exe_allowin_in       ),
    .if_valid_in             ( if_valid_in          ),
    .if_PC_in                ( if_PC_in             ),
    .if_NPC_in               ( if_NPC_in            ),
    .if_NNPC_in              ( if_NNPC_in           ),
    .if_Instruct_in          ( if_Instruct_in       ),
    .wb_wdata_in             ( wb_wdata_in          ),
    .wb_wen_in               ( wb_wen_in            ),
    .wb_wnum_in              ( wb_wnum_in           ),
    .exe_write_type          ( exe_write_type       ),
    .mem_write_type          ( mem_write_type       ),
    .wb_write_type           ( wb_write_type        ),
    .exe_wnum                ( exe_wnum             ),
    .mem_wnum                ( mem_wnum             ),
    .wb_wnum                 ( wb_wnum              ),

    .id_allowin_out          ( id_allowin_out       ),
    .id_valid_out            ( id_valid_out         ),
    .id_sel_wbdata_out       ( id_sel_wbdata_out    ),
    .id_sel_dm_out           ( id_sel_dm_out        ),
    .id_RD2_out              ( id_RD2_out           ),
    .id_aluop_out            ( id_aluop_out         ),
    .id_aludata1_out         ( id_aludata1_out      ),
    .id_aludata2_out         ( id_aludata2_out      ),
    .id_sbhw_con_out         ( id_sbhw_con_out      ),
    .id_regnum_out           ( id_regnum_out        ),
    .id_NNPC_out             ( id_NNPC_out          ),
    .id_PC_out               ( id_PC_out            ),
    .id_addrexc_con_out      ( id_addrexc_con_out   ),
    .id_lr_con_out           ( id_lr_con_out        ),
    .id_lubhw_con_out        ( id_lubhw_con_out     ),
    .id_brcal_res_out        ( id_brcal_res_out     ),
    .id_bjpc_res_out         ( id_bjpc_res_out      ),
    .id_write_type_out       ( id_write_type_out    ),
    .id_mult_div_op          ( id_mult_div_op       )
);
assign exe_wnum          = exe_wnum_out      ;
assign mem_wnum          = mem_wnum_out      ;
assign wb_wnum           = wb_wnum_reg_out   ;
assign mem_write_type    = mem_write_type_out;
assign wb_write_type     = wb_write_type_out ;
assign exe_write_type    = exe_write_type_out;
assign id_allowin_in     = id_allowin_out    ;
assign id_valid_in       = id_valid_out      ;
assign if_NPC_in         = if_NPC_out        ;
assign id_sel_wbdata_in  = id_sel_wbdata_out ;
assign id_sel_dm_con_in  = id_sel_dm_out     ;
assign id_RD2_in         = id_RD2_out        ;
assign id_aluop_in       = id_aluop_out      ;
assign id_aludata1_in    = id_aludata1_out   ;
assign id_aludata2_in    = id_aludata2_out   ;
assign id_sbhw_con_in    = id_sbhw_con_out   ;
assign id_regnum_in      = id_regnum_out     ;
assign id_NNPC_in        = id_NNPC_out       ;
assign id_PC_in          = id_PC_out         ;
assign id_addrexc_con_in = id_addrexc_con_out;
assign id_lr_con_in      = id_lr_con_out     ;
assign id_lubhw_con_in   = id_lubhw_con_out  ;
assign id_brcal_res_in   = id_brcal_res_out  ;
assign id_bjpc_res_in    = id_bjpc_res_out   ;
assign id_write_type_in  = id_write_type_out ;
EXE  u_EXE (
    .clk                     ( clk                  ),
    .rst_n                   ( rst_n                ),
    .mem_allowin_in          ( mem_allowin_in       ),
    .id_valid_in             ( id_valid_in          ),
    .id_sbhw_con_in          ( id_sbhw_con_in       ),
    .id_addrexc_con_in       ( id_addrexc_con_in    ),
    .id_sel_wbdata_in        ( id_sel_wbdata_in     ),
    .id_aluop_in             ( id_aluop_in          ),
    .id_RD2_in               ( id_RD2_in            ),
    .id_aludata1_in          ( id_aludata1_in       ),
    .id_aludata2_in          ( id_aludata2_in       ),
    .id_sel_dm_con_in        ( id_sel_dm_con_in     ),
    .id_lr_con_in            ( id_lr_con_in         ),
    .id_lubhw_con_in         ( id_lubhw_con_in      ),
    .id_PC_in                ( id_PC_in             ),
    .id_NNPC_in              ( id_NNPC_in           ),
    .id_regnum_in            ( id_regnum_in         ),
    .id_write_type_in        ( id_write_type_in     ),
    .id_mult_div_op_in       ( id_mult_div_op_in    ),

    .exe_allowin_out         ( exe_allowin_out      ),
    .exe_valid_out           ( exe_valid_out        ),
    .exe_alures_out          ( exe_alures_out       ),
    .exe_sel_wbdata_out      ( exe_sel_wbdata_out   ),
    .exe_lubhw_con_out       ( exe_lubhw_con_out    ),
    .exe_PC_out              ( exe_PC_out           ),
    .exe_NNPC_out            ( exe_NNPC_out         ),
    .exe_onehot_out          ( exe_onehot_out       ),
    .exe_dm_data_out         ( exe_dm_data_out      ),
    .exe_dm_we_out           ( exe_dm_we_out        ),
    .exe_dm_addr_out         ( exe_dm_addr_out      ),
    .exe_wnum_out            ( exe_wnum_out         ),
    .exe_write_type_out      ( exe_write_type_out   ),
    .exe_in0_out             ( exe_in0_out          ),
    .exe_in1_out             ( exe_in1_out          ),
    .exe_mult_div_op_out     ( exe_mult_div_op_out  ),
    .exe_read_request_out    ( exe_read_request_out )
);
assign id_mult_div_op_in  = id_mult_div_op     ;
assign mem_allowin_in     = mem_allowin_out    ;
assign exe_allowin_in     = exe_allowin_out    ;
assign exe_valid_in       = exe_valid_out      ;
assign exe_aluout_in      = exe_alures_out     ;
assign exe_sel_wbdata_in  = exe_sel_wbdata_out ;
assign exe_lubhw_con_in   = exe_lubhw_con_out  ;
assign exe_PC_in          = exe_PC_out         ;
assign exe_NNPC_in        = exe_NNPC_out       ;
assign exe_onehot_in      = exe_onehot_out     ;
assign exe_dm_data_in     = exe_dm_data_out    ;
assign exe_dm_we_in       = exe_dm_we_out      ;
assign exe_VAddr_in       = exe_dm_addr_out    ;
assign exe_regnum_in      = exe_wnum_out       ;
assign exe_write_type_in  = exe_write_type_out ;
MEM  u_MEM (
    .clk                     ( clk                  ),
    .rst_n                   ( rst_n                ),
    .wb_allowin_in           ( wb_allowin_in        ),
    .exe_valid_in            ( exe_valid_in         ),
    .exe_sel_wbdata_in       ( exe_sel_wbdata_in    ),
    .exe_aluout_in           ( exe_aluout_in        ),
    .exe_onehot_in           ( exe_onehot_in        ),
    .exe_lubhw_con_in        ( exe_lubhw_con_in     ),
    .exe_dm_data_in          ( exe_dm_data_in       ),
    .exe_dm_we_in            ( exe_dm_we_in         ),
    .exe_VAddr_in            ( exe_VAddr_in         ),
    .exe_PC_in               ( exe_PC_in            ),
    .exe_NNPC_in             ( exe_NNPC_in          ),
    .exe_regnum_in           ( exe_regnum_in        ),
    .exe_write_type_in       ( exe_write_type_in    ),
    .data_sram_rdata         ( data_sram_rdata      ),
    .mult_div_accessible_in  ( mult_div_accessible_in),
    .mult_div_res_in         ( mult_div_res_in      ),
    .exe_read_request_in     ( exe_read_request_in  ),

    .mem_allowin_out         ( mem_allowin_out      ),
    .mem_valid_out           ( mem_valid_out        ),
    .mem_wbdata_out          ( mem_wbdata_out       ),
    .mem_reg_we_out          ( mem_reg_we_out       ),
    .mem_PC_out              ( mem_PC_out           ),
    .mem_wnum_out            ( mem_wnum_out         ),
    .mem_write_type_out      ( mem_write_type_out   ),
    .data_sram_en            ( data_sram_en         ),
    .data_sram_wen           ( data_sram_wen        ),
    .data_sram_addr          ( data_sram_addr       ),
    .data_sram_wdata         ( data_sram_wdata      ),
    .mem_read_request_out    ( mem_read_request_out )
);

WB  u_WB (
    .clk                     ( clk                 ),
    .rst_n                   ( rst_n               ),
    .mem_valid_in            ( mem_valid_in        ),
    .mem_wbdata_in           ( mem_wbdata_in       ),
    .mem_reg_we_in           ( mem_reg_we_in       ),
    .mem_PC_in               ( mem_PC_in           ),
    .mem_wnum_in             ( mem_wnum_in         ),
    .mem_write_type_in       ( mem_write_type_in   ),

    .wb_allowin_out          ( wb_allowin_out      ),
    .wb_valid_out            ( wb_valid_out        ),
    .wb_wbdata_out           ( wb_wbdata_out       ),
    .wb_reg_we_out           ( wb_reg_we_out       ),
    .wb_wnum_out             ( wb_wnum_out         ),
    .wb_wnum_reg_out         ( wb_wnum_reg_out     ),
    .wb_write_type_out       ( wb_write_type_out   ),
    .debug_wb_pc             ( debug_wb_pc         ),
    .debug_wb_rf_wen         ( debug_wb_rf_wen     ),
    .debug_wb_rf_wnum        ( debug_wb_rf_wnum    ),
    .debug_wb_rf_wdata       ( debug_wb_rf_wdata   )
);
assign mem_valid_in      = mem_valid_out;     
assign mem_wbdata_in     = mem_wbdata_out;    
assign mem_reg_we_in     = mem_reg_we_out;    
assign mem_PC_in         = mem_PC_out;        
assign mem_wnum_in       = mem_wnum_out;
assign mem_write_type_in = mem_write_type_out;

assign wb_allowin_in     = wb_allowin_out   ;
assign wb_wdata_in       = wb_wbdata_out    ;
assign wb_wen_in         = wb_reg_we_out    ;
assign wb_wnum_in        = wb_wnum_out      ;
assign wb_write_type_in  = wb_write_type_out;

mult_div  u_mult_div (
    .clk                     ( clk           ),
    .rst_n                   ( rst_n         ),
    .mult_div_op             ( mult_div_op   ),
    .in0                     ( in0           ),
    .in1                     ( in1           ),
    .read_request            ( read_request  ),

    .mult_div_res            ( mult_div_res  ),
    .accessible              ( accessible    ) 
);
assign mult_div_op = exe_mult_div_op_out;
assign in0 = exe_in0_out;
assign in1 = exe_in1_out;
assign read_request = mem_read_request_out;
assign mult_div_accessible_in = accessible;
assign mult_div_res_in = mult_div_res;
endmodule