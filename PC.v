`include "defines.vh"
/*====================Ports Declaration====================*/
module PC(
 	input wire clk, 
	input wire rst_n, 
	input wire [31:0] pc_in, 
	input wire go_if,
	
	output reg [31:0] PC,NPC,NNPC
	);

/*====================Variable Declaration====================*/
wire [31:3] high;
/*====================Function Code====================*/
initial begin
	PC <= `StartPoint;
	NPC <= `StartNPC;
end
always @(posedge clk) begin
	if (!rst_n)begin
		PC <= `StartPoint;
		NPC <= `StartNPC;
		NNPC <= `StartNNPC;
	end
	else if (go_if) begin
		PC <= pc_in;
		NPC <= pc_in+3'd4;//可简化
		NNPC = pc_in+4'd8;//可简化
	end
end
endmodule