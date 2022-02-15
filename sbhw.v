/*====================Ports Declaration====================*/
module sbhw (
    input wire [31:0] RD2,
    input wire [2:0] sbhw_con,
    output wire [31:0] sbhw_data, //data:数据内存写数据--{0:sb,1:sh,2:sw}
    output wire [3:0] sbhw_we //control:数据内存写使能--{0:0001,1:0011,2:1111}
    );
/*====================Variable Declaration====================*/

/*====================Function Code====================*/
assign sbhw_data =  sbhw_con[0] ? {4{RD2[7:0]}} :
                    sbhw_con[1] ? {2{RD2[15:0]}} : RD2 ;
assign sbhw_we   =  sbhw_con[0] ? 4'b0001 : 
                    sbhw_con[1] ? 4'b0011 :
                    sbhw_con[2] ? 4'b1111 : 4'b0;
endmodule