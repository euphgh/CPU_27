`include "defines.vh"
/*====================Ports Declaration====================*/
module EXE(
	input wire clk,rst_n,go_exe,allowin_exe,
 	input wire sbhw_con, //control:sbhw模块选择子
	input wire [4:0] addrexc_con, //control:地址例外选择子
	input wire [3:0] sel_wbdata_exe_wire, //control:与ID段sel_wbdata_id_reg相连，直接输出sel_wbdata_exe_reg
	input wire [11:0] aluop, //control:
	input wire [31:0] RD2, //data:传送给swbh模块的数据
	input wire [31:0] aludata1, //data:
	input wire [31:0] aludata2, //data:
	input wire [1:0] sel_dm_con, //control:选择使用slr还是sbhw模块的数据写入存储器--{0:sbhw,1:slr}
	input wire [1:0]  lr_con, //control:onehot模块选择子
	input wire [4:0] lubhw_con_exe_wire, //control:与ID段lubhw_con_id_reg相连，直接输出lubhw_con_exe_reg
    input wire [31:0] PC_exe_wire,NNPC_exe_wire,
    input wire [4:0] regnum_exe_wire,
	
	output reg [31:0] aluout_exe_reg, //data:传送给sel_wb
	output reg [3:0] sel_wbdata_exe_reg, //contrl: sel_wbdata选择子
	output reg [4:0] lubhw_con_exe_reg, //control:lubw模块的选择子,由上一段接下来
	output reg [7:0] onehot_reg, //control:llr模块选择子
    output reg [31:0] PC_exe_reg,NNPC_exe_reg,
    output reg [4:0] regnum_exe_reg,

	output wire [31:0] dm_data, //data:直接在EXE进行选择，并且不停止，直接传输DIN
	output wire [3:0] dm_we, //control:直接在EXE进行选择，并且不停止，直接传输DMW
	output wire [31:0] dm_addr //address:不停止，直接传输DA
	);

/*====================Variable Declaration====================*/
// ALU Inputs------------------------------------      
wire [31:0]  scr0; 
wire [31:0]  scr1; 
// wire [11:0]  aluop; [port]

// ALU Outputs
wire  overflow;
wire  [31:0]  aluso;
//----------------------------------------------

// sbhw Inputs----------------------------------        
// wire [31:0]  RD2;[port]    
// wire [2:0]  sbhw_con; [port]

// sbhw Outputs
wire  [31:0]  sbhw_data;
wire  [3:0]  sbhw_we;
//----------------------------------------------

// lr_onehot Inputs----------------------------- 
wire  [1:0]  adlr;  
// wire  [1:0]  lr_con;[port]

// lr_onehot Outputs
wire  [7:0]  onehot;
//----------------------------------------------

// slr Inputs ----------------------------------    
// wire  [31:0]  RD2;[port]  
// wire  [7:0]  onehot;[lr_onehot]

// slr Outputs
wire  [31:0]  slr_data;
wire  [3:0]  slr_we;
// ---------------------------------------------

// addrexc Inputs ------------------------------       
wire  [31:0]  address;  
// wire  [4:0]  addrexc_con;[port]

// addrexc Outputs
wire  ExceptSet;
wire  [7:0]  ExcCode;
// ---------------------------------------------

// other----------------------------------------
wire [31:0] aluout_exe_wire;
//----------------------------------------------

/*====================Function Code====================*/
always @(posedge clk ) begin
    if (!rst_n) begin
		aluout_exe_reg <= `ini_aluout_exe;
        sel_wbdata_exe_reg <= `ini_sel_wbdata_exe;
        lubhw_con_exe_reg <= `ini_lubhw_con_exe;
        onehot_reg <= `ini_onehot;
        regnum_exe_reg <= `ini_regnum_exe;
        PC_exe_reg <= `ini_exe_reg;//决定debugPC初值
    end else begin
        if (go_exe) begin
            aluout_exe_reg <= aluso;
            sel_wbdata_exe_reg <= sel_wbdata_exe_wire;
            lubhw_con_exe_reg <= lubhw_con_exe_wire;
            onehot_reg <= onehot;
            PC_exe_reg <= PC_exe_wire ;
            NNPC_exe_reg <= NNPC_exe_wire ;
            regnum_exe_reg <= regnum_exe_wire; 
        end
    end
end
ALU  u_ALU (
    .scr0                    ( scr0       ),
    .scr1                    ( scr1       ),
    .aluop                   ( aluop      ),

    .overflow                ( overflow   ),
    .aluso                   ( aluso      ) 
);
assign scr0 = aludata1;
assign scr1 = aludata2;

sbhw  u_sbhw (
    .RD2                     ( RD2         ),
    .sbhw_con                ( sbhw_con    ),

    .sbhw_data               ( sbhw_data   ),
    .sbhw_we                 ( sbhw_we     ) 
);

lr_onehot  u_lr_onehot (
    .adlr                    ( adlr     ),
    .lr_con                  ( lr_con   ),

    .onehot                  ( onehot   ) 
);
assign adlr = aluso[1:0];

slr  u_slr (
    .RD2                     ( RD2        ),
    .onehot                  ( onehot     ),

    .slr_data                ( slr_data   ),
    .slr_we                  ( slr_we     ) 
);


addrexc  u_addrexc (
    .address                 ( address      ),
    .addrexc_con             ( addrexc_con   ),

    .ExceptSet               ( ExceptSet    ),
    .ExcCode                 ( ExcCode      ) 
);
assign address = aluso;

assign dm_data = sel_dm_con[0] ? sbhw_data : slr_data;
assign dm_we = sel_dm_con[0] ? sbhw_we : 
				sel_dm_con[1] ? slr_we : 4'b0000;
assign dm_addr = aluso;
endmodule