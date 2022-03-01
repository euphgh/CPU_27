/*====================Ports Declaration====================*/
module ThreeToTwo 
    #(parameter BUSin = 32)
    (
    input wire [BUSin-1:0] in0,in1,in2,
    output wire [BUSin:0] out0,out1
    );
/*====================Variable Declaration====================*/

/*====================Function Code====================*/
    genvar i; //genvar i;也可以定义到generate语句里面
    generate
        for(i=0;i<BUSin;i=i+1)
        begin
            assign out0[i] = in0[i]^in1[i]^in2[i];
            assign out1[i+1] = (in0[i]&&in1[i])||(in1[i]&&in2[i])||(in0[i]&&in2[i]);
        end
    endgenerate
    assign out0[BUSin] = out0[BUSin-1];
    assign out1[0] = 1'b0;
endmodule