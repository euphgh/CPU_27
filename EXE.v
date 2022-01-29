/*====================Ports Declaration====================*/
module EXE(
 	output reg sbh_con, //Warning:no bit in excel! control:控制输出为SB/SBU/SH/SHU
	output reg brcal_con, //Warning:no bit in excel! control
	output reg bjpc_con, //Warning:no bit in excel! control
	output reg [1:0] sel_pcback_exe, //control:在ID阶段PC选择器选择信号
	output reg [0:0] sel_dmin, //control
	output reg [1:0] sel_wbdata, //control
	output reg aluop, //Warning:no bit in excel! control
	output reg [31:0] RD1, //data
	output reg [31:0] RD2, //data
	output reg [31:0] aludata1, //data
	output reg [31:0] aludata2, //data
	output reg [25:0] instr_index, //data:指令后26位
	output reg [31:0] aluout, //data
	output reg [31:0] sel_pcback_out_exe, //address:exe阶段的计算出的新PC
	output reg [31:0] sbh_out, //data
	output reg [31:0] bjpc_out, //address
	output reg [0:0] brcal_out //control
	);

/*====================Variable Declaration====================*/
reg [31:0] aluout; //data

/*====================Function Code====================*/

endmodule