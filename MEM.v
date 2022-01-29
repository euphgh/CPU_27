/*====================Ports Declaration====================*/
module MEM(
 	output reg [0:0] sel_dmin, //control
	output reg [1:0] sel_wbdata, //control
	output reg aluout, //Warning:no bit in excel! control
	output reg [31:0] sbh_out, //data
	output reg [31:0] bjpc_out, //address
	output reg [31:0] RD2, //data
	output reg [31:0] wbdata, //data
	output reg [3:0] reg_we //control
	);

/*====================Variable Declaration====================*/
reg [3:0] dm_we; //control

/*====================Function Code====================*/

endmodule