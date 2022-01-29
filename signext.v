`include "defines.vh"
/*====================Ports Declaration====================*/
module signext(
    input wire [15:0] extend_in,
    input wire [2:0] extend_con,
    output wire [31:0] extend_out
    );
/*====================Variable Declaration====================*/
wire [31:0] out0,out1,out2;
/*====================Function Code====================*/
assign out0 = {{16{extend_in[15]}},extend_in};
assign out1 = {16'b0,extend_in};
assign out2 = {{14{extend_in[15]}},extend_in,2'b0};
assign extend_out = extend_in[0] ? out0 :
                    extend_in[1] ? out1 : out2;
endmodule