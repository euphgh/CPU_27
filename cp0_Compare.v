`include "defines.vh"
/*====================Ports Declaration====================*/
module cp0_Compare (
    input  wire clk,rst_n,exception,mtc0_we,
    input  wire [31:0] mtc0_data,
    input  wire [5:0]  cp0_addr,
    output reg  [31:0] cp0_Compare_data
    );
/*====================Variable Declaration====================*/
reg tick;
/*====================Function Code====================*/
always @(posedge clk ) begin
    if (!rst_n) 
        cp0_Compare_data <=`Compare_ini;
    else if (exception && (cp0_addr==`cp0addr_Compare))
        cp0_Compare_data <= mtc0_data;
end
endmodule