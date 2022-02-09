/*====================Ports Declaration====================*/
module lr_onehot (
    input wire [1:0] adlr,
    input wire [1:0] lr_con, //control:{0:l,1:r}
    output wire [7:0] onehot 
    );
/*====================Variable Declaration====================*/
/*====================Function Code====================*/
assign onehot =    ({lr_con[1],adlr}==3'd0) ? 8'd1 :
                   ({lr_con[1],adlr}==3'd1) ? 8'd2 : 
                   ({lr_con[1],adlr}==3'd2) ? 8'd4 : 
                   ({lr_con[1],adlr}==3'd3) ? 8'd8 : 
                   ({lr_con[1],adlr}==3'd4) ? 8'd16 :
                   ({lr_con[1],adlr}==3'd5) ? 8'd32 :
                   ({lr_con[1],adlr}==3'd6) ? 8'd64 : 8'd128 ;
endmodule