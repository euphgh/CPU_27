`include "defines.vh"
/*====================Ports Declaration====================*/
module PC(
 	input wire clk, 
	input wire rst_n, 
	input wire [31:0] pc_in, 
	
	output reg [31:0] PC, NPC,
	output wire [31:0] NNPC
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
	end
	else begin
		PC <= pc_in;
		NPC <= pc_in+4;
	end
end
assign high = pc_in[31:3] + 1'b1;
assign NNPC = {high,pc_in[2:0]};
endmodule