`include "defines.vh"
/*====================Ports Declaration====================*/
module cp0_Compare (
    input  wire clk,rst_n,mtc0_we,
    input  wire [31:0] mtc0_data,
    input  wire [7:0]  cp0_addr,
    output reg  [31:0] cp0_Compare_data
    );
/*====================Variable Declaration====================*/
wire Compare_watch_equal = cp0_addr==`cp0addr_Status;
wire Compare_watch_write = (mtc0_we && cp0_addr==`cp0addr_Status);
/*====================Function Code====================*/
always @(posedge clk ) begin
    // if (!rst_n) 
    //     cp0_Compare_data <=`Compare_ini;
    // else if (mtc0_we && (cp0_addr==`cp0addr_Compare))
    if (mtc0_we && (cp0_addr==`cp0addr_Compare))
        cp0_Compare_data <= mtc0_data;
end
endmodule