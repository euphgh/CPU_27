`include "defines.vh"
/*====================Ports Declaration====================*/
module lubhw (
    input wire [31:0] word, //data:
    input wire [1:0] adrl_lubhw, //control:
    input wire [4:0] lubhw_con, //control:{0:lb,1:lbu,2:lh,3:lhu,4:lw}
    output wire [31:0] lubhw_out //data:返回回写值
    );
/*====================Variable Declaration====================*/
wire [7:0] byte;
wire [15:0] half;
/*====================Function Code====================*/
assign byte = (adrl_lubhw==2'b00) ? word[7:0] :
              (adrl_lubhw==2'b01) ? word[15:8] :
              (adrl_lubhw==2'b10) ? word[23:16] : word[31:24];
assign half = (adrl_lubhw==2'b00) ? word[15:0] : word[31:16];
assign lubhw_out = lubhw_con[0] ? {{24{byte[7]}},byte} :
                    lubhw_con[1] ? {24'b0,byte} :
                    lubhw_con[2] ? {{16{half[15]}},half} :
                    lubhw_con[3] ? {16'b0,half} : word;
endmodule