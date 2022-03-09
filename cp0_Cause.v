`include "defines.vh"
/*====================Ports Declaration====================*/
module cp0_Cause (
    input  wire clk,rst_n,mtc0_we,exception,eret_flush,bd,equal,
    input  wire [4:0] int_in,
    input  wire [4:0] ExcCode, 
    input  wire [5:0] cp0_addr,
    input  wire [31:0] mct0_data,
    output reg  [31:0] cp0_Cause_data
    );
/*====================Variable Declaration====================*/
/*====================Function Code====================*/
always @(posedge clk ) begin
    //BD
    if (!rst_n) 
        cp0_Cause_data[`BD] <= `BD_ini;
    else if (exception) 
        cp0_Cause_data[`BD] <= bd;
    //TI
    if (!rst_n)
        cp0_Cause_data[`TI] <= `TI_ini;
    else if (mtc0_we && cp0_addr==`cp0addr_Compare)
        cp0_Cause_data[`TI] <= 1'b0;
    else if (equal)
        cp0_Cause_data[`TI] <= 1'b1;
    //IP
    if (!rst_n)
        cp0_Cause_data[`IP_hard] <=`IP_hard_ini;
    else if (mtc0_we && cp0_addr==`cp0addr_Cause)
        cp0_Cause_data[`IP7] <= int_in[5]|cp0_Cause_data[`TI];
        cp0_Cause_data[`IP6to2] <= int_in[4:0];
    //ExcCode
    if (!rst_n) 
        cp0_Cause_data[`ExcCode] <= `ExcCode_ini;
    else if (exception) 
        cp0_Cause_data[`ExcCode] <= ExcCode;
end
endmodule