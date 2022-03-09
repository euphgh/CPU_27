`include "defines.vh"
/*====================Ports Declaration====================*/
module cp0_EPC (
    input  wire clk,rst_n,mtc0_we,exception,EXL,BD,
    input  wire [31:0] mem_to_wb_PC_r,
    input  wire [5:0]  cp0_addr,
    input  wire [31:0] mtc0_data,
    output reg  [31:0] cp0_EPC_data
    );
/*====================Variable Declaration====================*/
/*====================Function Code====================*/
always @(posedge clk ) begin
    //if (!rst_n) 
        //cp0_EPC_data <= `EPC_ini;
    //else if (exception && (!EXL)) 
    if (exception && (!EXL)) 
        cp0_EPC_data <= BD ? (mem_to_wb_PC_r-3'd4) : mem_to_wb_PC_r;
    else if  (mtc0_we && (cp0_addr==`cp0addr_EPC))
        cp0_EPC_data <= mtc0_data;
end
endmodule