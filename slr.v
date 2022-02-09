/*====================Ports Declaration====================*/
module slr (
    input wire [31:0] RD2,
    input wire [7:0] onehot,
    output wire [31:0] slr_data,
    output wire [3:0] slr_we
    );
/*====================Variable Declaration====================*/
/*====================Function Code====================*/
assign slr_data =   (onehot[0]||onehot[5]) ? {RD2[23:16],RD2[15:8],RD2[7:0],RD2[31:24]} :
                    (onehot[1]||onehot[6]) ? {RD2[15:0],RD2[31:16]} : 
                    (onehot[2]||onehot[7]) ? {RD2[7:0],RD2[31:24],RD2[23:16],RD2[15:8]} : RD2;
assign slr_we = onehot[0] ? 4'b0001 :
                onehot[1] ? 4'b0011 :
                onehot[2] ? 4'b0111 :
                (onehot[3]||onehot[4]) ? 4'b1111 :
                onehot[5] ? 4'b1110 :
                onehot[6] ? 4'b1100 :
                onehot[7] ? 4'b1000 : 4'b0;  
endmodule