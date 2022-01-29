/*====================Ports Declaration====================*/
module brcal(
 	output wire [31:0] RD1, //
	output wire [31:0] RD2, //
	output wire [5:0] brcal_con, //control:选择计算类型--{0:E,1:NE,2:GE,3:GT,4:LE,5:LT}
	output wire brcal_out //control:决定是否跳转--{0:不跳转,1:跳转}
	);

/*====================Variable Declaration====================*/
wire beq_res; 
wire bne_res; 
wire bgez_res;
wire bgtz_res;
wire blez_res;
wire bltz_res;

/*====================Function Code====================*/
assign beq_res =  (RD1==RD2);
assign bne_res =  !beq_res;
assign bgez_res = !RD1[31];
assign bgtz_res = bgez_res&&(|(RD1[30:0]));
assign bltz_res = RD1[31];
assign blez_res = RD1[31]||(!(|RD1));
assign brcal_out = 	brcal_con[0] ? beq_res:
				    brcal_con[1] ? bne_res:
	 				brcal_con[2] ? bgez_res:			
 					brcal_con[3] ? bgtz_res:
					brcal_con[4] ? blez_res: bltz_res;
endmodule