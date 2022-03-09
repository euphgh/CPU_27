`include "defines.vh"
/*====================Ports Declaration====================*/
module cp0_Count (
    input  wire clk,rst_n,exception,mtc0_we,
    input  wire [31:0] mtc0_data,
    input  wire [5:0]  cp0_addr,
    output reg  [31:0] cp0_Count_data
    );
/*====================Variable Declaration====================*/
reg tick;
/*====================Function Code====================*/
always @(posedge clk ) begin
    if (!rst_n) 
        tick <=1'b0;
    else
        tick <= ~tick;
    
    if (!rst_n) 
        cp0_Count_data <=`Count_ini;
    else if (exception && (cp0_addr==`cp0addr_Count))
        cp0_Count_data <= mtc0_data;
    else if(tick)
        cp0_Count_data <= cp0_Count_data + 1'b1;
end
endmodule