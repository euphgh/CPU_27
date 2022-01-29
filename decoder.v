/*====================Ports Declaration====================*/
module decoder(
 	input wire [31:0] Instruct, //address
	output wire [4:0] rs, //data
	output wire [4:0] rt, //data
	output wire [4:0] rd, //data
	output wire [15:0] imm, //data
	output wire [25:0] instr_index, //data
	output wire [4:0] sa, //data
	output wire [2:0] sel_wr_con, //control
	output wire [1:0] sel_alud1_con, //control
	output wire [1:0] sel_alud2_con, //control
	output wire [2:0] extend_con, //control
	output wire [2:0] bjpc_con, //control
	output wire [5:0] brcal_con, //control
	output wire [11:0] aluop, //control
	output wire [1:0] sbh_con, //control
	output wire [1:0] din_con, //control
	output wire [1:0] dmw_con, //control
	output wire [3:0] wb_con //control
	);

/*====================Variable Declaration====================*/

/*====================Function Code====================*/

endmodule