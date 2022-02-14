/*====================Ports Declaration====================*/
module llr (
    input wire [31:0] word,
    input wire [7:0] onehot,
    output wire [31:0] llr_data,
    output wire [3:0] llr_we
    );
/*====================Variable Declaration====================*/
/*====================Function Code====================*/
assign llr_data =   (onehot[2]||onehot[7]) ? {word[23:16],word[15:8],word[7:0],word[31:24]} :
                    (onehot[1]||onehot[6]) ? {word[15:0],word[31:16]} : 
                    (onehot[0]||onehot[5]) ? {word[7:0],word[31:24],word[23:16],word[15:8]} : word;
assign llr_we = onehot[7] ? 4'b0001 :
                onehot[6] ? 4'b0011 :
                onehot[5] ? 4'b0111 :
                (onehot[3]||onehot[4]) ? 4'b1111 :
                onehot[2] ? 4'b1110 :
                onehot[1] ? 4'b1100 :
                onehot[0] ? 4'b1000 : 4'b0;  
endmodule