`include "defines.vh"
/*====================Ports Declaration====================*/
module signext(
    input wire [15:0] imm,
    input wire [2:0] extend_con,
    output wire [31:0] extend_out
    );
/*====================Variable Declaration====================*/
wire [31:0] out0,out1,out2;
/*====================Function Code====================*/
assign out0 = {{16{imm[15]}},imm};
assign out1 = {16'b0,imm};
assign out2 = {{14{imm[15]}},imm,2'b0};
assign extend_out = extend_con[0] ? out0 :
                    extend_con[1] ? out1 : out2;
endmodule