`include "defines.vh"
/*====================Ports Declaration====================*/
module datapath (
    input wire clk,rst_n,
    // 
    output  wire  inst_sram_en,  //ram 使能信号，高电平有效
    output  wire [3:0] inst_sram_wen,  //ram 字节写使能信号，高电平有效
    output  wire [31:0] inst_sram_addr,  //ram 读写地址，字节寻址
    output  wire [31:0] inst_sram_wdata,  //ram 写数据
    input  wire [31:0] inst_sram_rdata, //ram 读数据

    output wire data_sram_en, //ram 使能信号，高电平有效
    output wire [3 :0] data_sram_wen, //ram 字节写使能信号，高电平有效
    output wire [31:0] data_sram_addr,  //ram 读写地址，字节寻址
    output wire [31:0] data_sram_wdata,  //ram 写数据
    input wire [31:0] data_sram_rdata,  //ram 读数据
    input wire [5:0] ext_int,

    //debug 信号， 供验证平台使用
    output reg [31:0] debug_wb_pc,   //写回级（多周期最后一级） 的 PC， 因而需要 mycpu 里将 PC 一路带到写回级
    output reg [3:0] debug_wb_rf_wen,   //写回级写寄存器堆(regfiles)的写使能，为字节写使能，如果 mycpu 写 regfiles为单字节写使能，则将写使能扩展成 4 位即可。
    output reg [4:0] debug_wb_rf_wnum,   //写回级写 regfiles 的目的寄存器号
    output reg [31:0] debug_wb_rf_wdata   //写回级写 regfiles 的写数据

    );
/*====================Variable Declaration====================*/

//写回写寄存器
// IF Inputs--------------------------------------------
// wire  clk;[port]
// wire  rst_n;[port]
wire  brcal_out;
wire  go_if;
wire allowin_if;
wire  [31:0]  bjpc_out;       
// wire  [31:0]  inst_sram_rdata;[port]

// IF Outputs
wire  [31:0]  Instruct_reg;
wire  [31:0]  NPC_reg;
wire  [31:0]  NNPC_reg;
wire  [31:0]  PC_if_reg;//nc    
// wire  [31:0]  inst_sram_wdata;[port]
// -----------------------------------------------------

// ID Inputs--------------------------------------------
// wire  clk;[port]
// wire  rst_n;[port]
wire  go_id;
wire  allowin_id;       
wire  [31:0]  Instruct; 
wire  [31:0]  NPC;      
wire  [31:0]  NNPC;     
wire  [31:0]  wbdata;   
wire  [3:0]  reg_we_mem;
wire  [31:0]  PC_ifget; 
wire  [31:0]  PC_memget;
wire  [4:0]  regnum_mem;

// ID Outputs
wire  [3:0]  sel_wbdata_id_reg;
wire  [1:0]  sel_dm_id_reg;    
wire  [31:0]  RD2_reg;
wire  [11:0]  aluop_reg;       
wire  [31:0]  aludata1_reg;    
wire  [31:0]  aludata2_reg;    
wire  [2:0]  sbhw_con_reg;     
wire  [4:0]  regnum_id_reg;    
wire  [31:0]  NNPC_id_reg;     
wire  [31:0]  PC_id_reg;
wire  [3:0]  addrexc_con_reg;
wire  [1:0]  lr_con_reg;
wire  [4:0]  lubhw_con_id_reg;
// wire  [31:0]  bjpc_out;[if]
// wire  brcal_out;[if]
wire  [31:0]  debug_wb_pc_wire;
wire  [3:0]  debug_wb_rf_wen_wire;
wire  [4:0]  debug_wb_rf_wnum_wire;
wire  [31:0]  debug_wb_rf_wdata_wire;
wire [4:0] RR1,RR2;
wire [2:0] idstop_idcon;//nc decoder
wire idstop_con_w;
wire idstop_con_tetmo;//nc
// -----------------------------------------------------

// EXE Inputs-------------------------------------------
// wire  clk;[port]
// wire  rst_n;[port]
wire  go_exe;
wire  allowin_exe;
wire  [2:0] sbhw_con;
wire  [3:0]  addrexc_con;
wire  [3:0]  sel_wbdata_exe_wire;
wire  [11:0]  aluop;
wire  [31:0]  RD2;
wire  [31:0]  aludata1;
wire  [31:0]  aludata2;
wire  [1:0]  sel_dm_con;
wire  [1:0]  lr_con;
wire  [4:0]  lubhw_con_exe_wire; 
wire  [31:0]  PC_exe_wire;//nc    
wire  [31:0]  NNPC_exe_wire;    
wire  [4:0]  regnum_exe_wire;    

// EXE Outputs
wire  [31:0]  aluout_exe_reg;
wire  [3:0]  sel_wbdata_exe_reg;
wire  [4:0]  lubhw_con_exe_reg;
wire  [7:0]  onehot_reg;
wire  [31:0]  dm_data_exe;
wire  [3:0]  dm_we_exe;
wire  [31:0]  dm_addr;
wire  [31:0]  PC_exe_reg;//nc    
wire  [31:0]  NNPC_exe_reg;
wire  [4:0]  regnum_exe_reg;    

wire idstop_con_ei;
wire idstop_con_tmi;
wire idstop_con_tmo;
wire [4:0] regnum_eo;
wire idstop_con_eo;

// -----------------------------------------------------
// MEM Inputs-------------------------------------------
// wire  clk;[port]
// wire  rst_n;[port]
wire  go_mem;
wire  allowin_mem;      
wire  [3:0]  sel_wbdata;
wire  [31:0]  aluout;   
wire  [7:0]  onehot;    
wire  [4:0]  lubhw_con; 
wire  [31:0]  dm_data;  
wire  [3:0]  dm_we; 
wire  [31:0]  PC_mem_wire;//nc    
wire  [31:0]  NNPC_mem_wire;
wire  [4:0]  regnum_mem_wire;    
wire  [31:0] VAddr;

// MEM Outputs
// wire  [31:0]  wbdata;[id]
// wire  [3:0]  reg_we_mem;[id]
wire [31:0] PC_mem;
// wire  [4:0]  regnum_mem[id];   
wire  idstop_con_mi;
wire [4:0] regnum_mo;
wire idstop_con_mo;
// -----------------------------------------------------

// idstop Inputs----------------------------------------
wire  [4:0]  wr_exe;      
wire  [4:0]  wr_mem;      
// wire  [3:0]  idstop_idcon;[id]
wire  idstop_execon;      
wire  idstop_memcon;      
// wire  [4:0]  RR1;[id]
// wire  [4:0]  RR2;[id]

// idstop Outputs
wire  idstop_out;
// -----------------------------------------------------

/*====================Function Code====================*/
IF  u_IF (
    .clk                     ( clk               ),
    .rst_n                   ( rst_n             ),
    .brcal_out               ( brcal_out         ),
    .go_if                   ( go_if             ),//nc
    .bjpc_out                ( bjpc_out          ),
    .inst_sram_rdata         ( inst_sram_rdata   ),

    .allowin_if              ( allowin_if        ),//nc
    .Instruct_reg            ( Instruct_reg      ),
    .PC_if_reg               ( PC_if_reg         ),
    .NPC_reg                 ( NPC_reg           ),
    .NNPC_reg                ( NNPC_reg          ),
    .inst_sram_wdata         ( inst_sram_wdata   ),
    .inst_sram_en            ( inst_sram_en      ),
    .inst_sram_wen           ( inst_sram_wen     ),
    .inst_sram_addr          ( inst_sram_addr    )
);
ID  u_ID (
    .clk                     ( clk                      ),
    .rst_n                   ( rst_n                    ),
    .go_id                   ( go_id                    ),
    .Instruct                ( Instruct                 ),
    .NPC                     ( NPC                      ),
    .NNPC                    ( NNPC                     ),
    .wbdata                  ( wbdata                   ),
    .reg_we_mem              ( reg_we_mem               ),
    .PC_ifget                ( PC_ifget                 ),
    .PC_memget               ( PC_memget                ),
    .regnum_mem              ( regnum_mem               ),
    .idstop_out              ( idstop_out               ),

    .sel_wbdata_id_reg       ( sel_wbdata_id_reg        ),
    .sel_dm_id_reg           ( sel_dm_id_reg            ),
    .RD2_reg                 ( RD2_reg                  ),
    .aluop_reg               ( aluop_reg                ),
    .aludata1_reg            ( aludata1_reg             ),
    .aludata2_reg            ( aludata2_reg             ),
    .sbhw_con_reg            ( sbhw_con_reg             ),
    .regnum_id_reg           ( regnum_id_reg            ),
    .NNPC_id_reg             ( NNPC_id_reg              ),
    .PC_id_reg               ( PC_id_reg                ),
    .addrexc_con_reg         ( addrexc_con_reg          ),
    .lr_con_reg              ( lr_con_reg               ),
    .lubhw_con_id_reg        ( lubhw_con_id_reg         ),
    .allowin_id              ( allowin_id               ),
    .RR1                     ( RR1                      ),
    .RR2                     ( RR2                      ),
    .idstop_idcon            ( idstop_idcon             ),
    .idstop_con_w_reg        ( idstop_con_w_reg         ),
    .bjpc_out                ( bjpc_out                 ),
    .brcal_out               ( brcal_out                ),
    .debug_wb_pc_wire        ( debug_wb_pc_wire         ),
    .debug_wb_rf_wen_wire    ( debug_wb_rf_wen_wire     ),
    .debug_wb_rf_wnum_wire   ( debug_wb_rf_wnum_wire    ),
    .debug_wb_rf_wdata_wire  ( debug_wb_rf_wdata_wire   )
);
assign Instruct = Instruct_reg;
assign NPC = NPC_reg;
assign PC_ifget = PC_if_reg;
assign NNPC = NNPC_reg;
assign NNPC_exe_wire = NNPC_id_reg;
always @(posedge clk ) begin
    if (!rst_n)begin
        debug_wb_pc <= `debug_wb_pc;
        debug_wb_rf_wen <= `debug_wb_rf_wen;
        debug_wb_rf_wnum <= `debug_wb_rf_wnum;
        debug_wb_rf_wdata <= `debug_wb_rf_wdata;
    end
    else begin
        debug_wb_pc <= debug_wb_pc_wire;
        debug_wb_rf_wen <= debug_wb_rf_wen_wire;
        debug_wb_rf_wnum <= debug_wb_rf_wnum_wire;
        debug_wb_rf_wdata <= debug_wb_rf_wdata_wire;
    end
end
EXE  u_EXE (
    .clk                     ( clk                   ),
    .rst_n                   ( rst_n                 ),
    .go_exe                  ( go_exe                ),
    .sbhw_con                ( sbhw_con              ),
    .addrexc_con             ( addrexc_con           ),
    .sel_wbdata_exe_wire     ( sel_wbdata_exe_wire   ),
    .aluop                   ( aluop                 ),
    .RD2                     ( RD2                   ),
    .aludata1                ( aludata1              ),
    .aludata2                ( aludata2              ),
    .sel_dm_con              ( sel_dm_con            ),
    .lr_con                  ( lr_con                ),
    .lubhw_con_exe_wire      ( lubhw_con_exe_wire    ),
    .PC_exe_wire             ( PC_exe_wire           ),
    .NNPC_exe_wire           ( NNPC_exe_wire         ),
    .regnum_exe_wire         ( regnum_exe_wire       ),

    .allowin_exe             ( allowin_exe           ),
    .aluout_exe_reg          ( aluout_exe_reg        ),
    .sel_wbdata_exe_reg      ( sel_wbdata_exe_reg    ),
    .lubhw_con_exe_reg       ( lubhw_con_exe_reg     ),
    .onehot_reg              ( onehot_reg            ),
    .PC_exe_reg              ( PC_exe_reg            ),
    .NNPC_exe_reg            ( NNPC_exe_reg          ),
    .regnum_exe_reg          ( regnum_exe_reg        ),
    .dm_data_exe             ( dm_data_exe           ),
    .dm_we_exe               ( dm_we_exe             ),
    .dm_addr                 ( dm_addr               ),

    .idstop_con_w_ei         ( idstop_con_w_ei       ),
    .idstop_con_w_tmo        ( idstop_con_w_tmo      ),
    .regnum_eo               ( regnum_eo             ),
    .idstop_con_w_eo         ( idstop_con_w_eo       )
);
assign regnum_exe_wire = regnum_id_reg;
assign sbhw_con = sbhw_con_reg;
assign addrexc_con = addrexc_con_reg;
assign sel_wbdata_exe_wire = sel_wbdata_id_reg;
assign aluop = aluop_reg;
assign RD2 = RD2_reg;
assign aludata1 = aludata1_reg;
assign aludata2 = aludata2_reg;
assign sel_dm_con = sel_dm_id_reg;
assign lr_con = lr_con_reg;              
assign lubhw_con_exe_wire = lubhw_con_id_reg;  
assign PC_exe_wire = PC_id_reg;
assign NNPC_exe_wire = NNPC_id_reg;
assign idstop_con_w_ei = idstop_con_w_reg;
MEM  u_MEM (
    .clk                     ( clk               ),
    .rst_n                   ( rst_n             ),
    .go_mem                  ( go_mem            ),
    .sel_wbdata              ( sel_wbdata        ),
    .aluout                  ( aluout            ),
    .onehot                  ( onehot            ),
    .lubhw_con               ( lubhw_con         ),
    .dm_data                 ( dm_data           ),
    .dm_we                   ( dm_we             ),
    .VAddr                   ( VAddr             ),
    .PC_mem_wire             ( PC_mem_wire       ),
    .NNPC_mem_wire           ( NNPC_mem_wire     ),
    .data_sram_rdata         ( data_sram_rdata   ),
    .regnum_mem_wire         ( regnum_mem_wire   ),

    .allowin_mem             ( allowin_mem       ),
    .wbdata                  ( wbdata            ),
    .reg_we_mem              ( reg_we_mem        ),
    .PC_mem                  ( PC_mem            ),
    .regnum_mem              ( regnum_mem        ),
    .data_sram_en            ( data_sram_en      ),
    .data_sram_wen           ( data_sram_wen     ),
    .data_sram_addr          ( data_sram_addr    ),
    .data_sram_wdata         ( data_sram_wdata   ),

    .idstop_con_w_mi         ( idstop_con_w_mi   ),
    .regnum_mo               ( regnum_mo         ),
    .idstop_con_w_mo         ( idstop_con_w_mo   ) 

);
assign regnum_mem_wire = regnum_exe_reg;
assign sel_wbdata = sel_wbdata_exe_reg ;
assign aluout = aluout_exe_reg ;
assign onehot = onehot_reg ;
assign lubhw_con = lubhw_con_exe_reg ;
assign dm_data = dm_data_exe;
assign dm_we = dm_we_exe;
assign VAddr = dm_addr ;
assign PC_mem_wire = PC_exe_reg;
assign NNPC_mem_wire = NNPC_exe_reg;
assign PC_memget = PC_mem;
assign idstop_con_w_mi = idstop_con_w_tmo;
idstop  u_idstop (
    .wr_exe                  ( wr_exe          ),
    .wr_mem                  ( wr_mem          ),
    .idstop_idcon            ( idstop_idcon    ),
    .idstop_execon           ( idstop_execon   ),
    .idstop_memcon           ( idstop_memcon   ),
    .RR1                     ( RR1             ),
    .RR2                     ( RR2             ),

    .idstop_out              ( idstop_out      )
);
assign idstop_execon = idstop_con_w_eo;
assign idstop_memcon = idstop_con_w_mo;
assign wr_exe = regnum_eo;
assign wr_mem = regnum_mo;
assign go_if = allowin_id && allowin_exe && allowin_mem ;
assign go_id = allowin_exe && allowin_mem && !idstop_out;
assign go_exe = allowin_mem ;
assign go_mem = 1'b1;
endmodule