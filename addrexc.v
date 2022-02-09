`include "defines.vh"
/*====================Ports Declaration====================*/
module addrexc (
    input wire [31:0] address,
    input wire [3:0] addrexc_con, //control:选择哪种类型的地址检查{0:r2,1:r4,2:w2,3:w4,4:不检查}
    output wire ExceptSet,
    output wire [7:0] ExcCode
    );
/*====================Variable Declaration====================*/
wire two,four;
/*====================Function Code====================*/
assign two = address[0];
assign four = address[0]||address[1]; 
assign ExceptSet =  (addrexc_con[0]||addrexc_con[2]) ? two :
                    (addrexc_con[1]||addrexc_con[3]) ? four : 1'b0;
                    
assign ExcCode =    (addrexc_con[0]||addrexc_con[1]) ? `AdEL : `AdES;
endmodule