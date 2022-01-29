`include "defines.vh"
/*====================Ports Declaration====================*/
module PC(
 	output wire [0:0] clk, //
	output wire [0:0] rst_n, //
	output wire [31:0] pc_in, //
	output reg [31:0] PC, //
	output wire [31:0] NPC //
	);

/*====================Variable Declaration====================*/
wire [31:2] high; //:None

/*====================Function Code====================*/
initial begin
	PC <= `StartPoint;
end
always @(posedge clk) begin
	if (!rst_n)begin
		PC <= pc_in;
	end
	else begin
		PC <= `StartPoint;
	end
end
assign high = PC[31:2] + 1;
assign NPC = {high,PC[1:0]};
endmodule