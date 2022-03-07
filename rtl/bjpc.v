/*====================Ports Declaration====================*/
module bjpc(
 	input wire [31:0] NPC, //address
	input wire [31:0] RD1, //address
	input wire [31:0] extend_out, //data:左移两位有符号扩展
	input wire [25:0] instr_index, //data:指令后26位
	input wire [2:0] bjpc_con, //control:选择输出指令类型--{0:J指令,1:B类指令,2:JR指令}
	output wire [31:0] bjpc_out //address:BJ类指令的跳转地址
	);

/*====================Variable Declaration====================*/
wire [31:0] jpc;
wire [31:0] jrpc;
wire [31:0] bpc;
/*====================Function Code====================*/
assign jpc = {NPC[31:28],instr_index,2'b0};
assign bpc = extend_out+NPC;
assign jrpc = RD1;
assign bjpc_out = bjpc_con[0] ? jpc:
				  bjpc_con[1] ? bpc:jrpc;
endmodule