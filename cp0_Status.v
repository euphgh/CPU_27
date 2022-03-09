`include "defines.vh"
/*====================Ports Declaration====================*/
module cp0_Status (
    input  wire clk,rst_n,mtc0_we,exception,eret_flush,
    input  wire [5:0] cp0_addr,
    input  wire [31:0] mct0_data,
    output reg  [31:0] cp0_Status_data
    );
/*====================Variable Declaration====================*/
/*====================Function Code====================*/
always @(posedge clk ) begin
    //EXL
    if (!rst_n) 
        cp0_Status_data[`EXL] <= `EXL_ini;
    else if (exception) 
        cp0_Status_data[`EXL] <= 1'b1;
    else if (eret_flush)
        cp0_Status_data[`EXL] <= 1'b0;
    else if (mtc0_we && cp0_addr==`cp0addr_Status)
        cp0_Status_data[`EXL] <= mct0_data[`EXL];
    //IE
    if (!rst_n)
        cp0_Status_data[`IE] <= `IE_ini;
    else if (mtc0_we && cp0_addr==`cp0addr_Status)
        cp0_Status_data[`IE] <= mct0_data[`IE];
    //IM    
    // if (!rst_n)
    //     cp0_Status_data[`IM] <=`IM_ini;
    // else if (mtc0_we && cp0_addr==`cp0addr_Status)
    if (mtc0_we && cp0_addr==`cp0addr_Status)
        cp0_Status_data[`IM] <= mct0_data[`IM];
end
endmodule