`include "defines.vh"
/*====================Ports Declaration====================*/
module cp0_Cause (
    input  wire clk,rst_n,mtc0_we,exception,eret_flush,bd,equal,
    input  wire [6:0] cp0_addr,
    input  wire [31:0] mct0_data,
    output reg  [31:0] cp0_Cause_data
    );
/*====================Variable Declaration====================*/
/*====================Function Code====================*/
always @(posedge clk ) begin
    if (!rst_n) 
        cp0_Cause_data[`BD] <= `BD_ini;
    else if (exception) 
        cp0_Cause_data[`BD] <= bd;

    if (!rst_n)
        cp0_Cause_data[`TI] <= `TI_ini;
    else if (mtc0_we && cp0_addr==`cp0addr_Status)
        cp0_Cause_data[`TI] <= equal;
        
    if (!rst_n)
        cp0_Cause_data[`IM] <=`IM_ini;
    else if (mtc0_we && cp0_addr==`cp0addr_Status)
        cp0_Cause_data[`IM] <= mct0_data[`IM];
end
endmodule