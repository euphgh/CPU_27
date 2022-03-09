`include "defines.vh"
/*====================Ports Declaration====================*/
module cp0_BadVAddr (
    input  wire clk,rst_n,exception,
    input  wire [31:0] error_VAddr,
    input  wire [4:0]  ExcCode,
    output reg  [31:0] cp0_BadVAddr_data
    );
/*====================Variable Declaration====================*/
/*====================Function Code====================*/
always @(posedge clk ) begin
    //if (!rst_n) 
        //cp0_BadVAddr_data <= `BadVAddr_ini;
    //else if (exception && (ExcCode[4:1]==4'b0010)) 
    if (exception && (ExcCode[4:1]==4'b0010)) 
        cp0_BadVAddr_data <= error_VAddr;
end
endmodule