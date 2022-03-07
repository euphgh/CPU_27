/*====================Ports Declaration====================*/
module sbhw (
    input wire [31:0] RD2,
    input wire [2:0] sbhw_con,
    input wire [1:0] adlr,
    output wire [31:0] sbhw_data, //data:数据内存写数据--{0:sb,1:sh,2:sw}
    output wire [3:0] sbhw_we //control:数据内存写使能--{0:0001,1:0011,2:1111}
    );
/*====================Variable Declaration====================*/
wire [3:0] sb_we,sw_we,sh_we;
/*====================Function Code====================*/
assign sbhw_data =  sbhw_con[0] ? {4{RD2[7:0]}} :
                    sbhw_con[1] ? {2{RD2[15:0]}} : RD2 ;
assign sb_we = (!(|adlr)) ? 4'b0001:
                (adlr==2'b01) ? 4'b0010:
                (adlr==2'b10) ? 4'b0100:4'b1000;
assign sh_we = (adlr==2'b0) ? 4'b0011 : 4'b1100;
assign sw_we = 4'b1111;
assign sbhw_we   =  sbhw_con[0] ? sb_we : 
                    sbhw_con[1] ? sh_we :
                    sbhw_con[2] ? sw_we : 4'b0;
endmodule