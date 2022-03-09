`include "defines.vh"
/*====================Ports Declaration====================*/
module cp0_Status (
    input  wire clk,rst_n,mtc0_we,exception,eret_op,
    input  wire [5:0] cp0_addr,
    input  wire [31:0] mtc0_data,
    output wire [31:0] cp0_Status_data
    );
/*====================Variable Declaration====================*/
reg  [31:0] cp0_Status_data_r;
/*====================Function Code====================*/
always @(posedge clk ) begin
    //EXL
    if (!rst_n) 
        cp0_Status_data_r[`EXL] <= `EXL_ini;
    else if (exception) 
        cp0_Status_data_r[`EXL] <= 1'b1;
    else if (eret_op)
        cp0_Status_data_r[`EXL] <= 1'b0;
    else if (mtc0_we && cp0_addr==`cp0addr_Status)
        cp0_Status_data_r[`EXL] <= mtc0_data[`EXL];
    //IE
    if (!rst_n)
        cp0_Status_data_r[`IE] <= `IE_ini;
    else if (mtc0_we && cp0_addr==`cp0addr_Status)
        cp0_Status_data_r[`IE] <= mtc0_data[`IE];
    //IM    
    // if (!rst_n)
    //     cp0_Status_data_r[`IM] <=`IM_ini;
    // else if (mtc0_we && cp0_addr==`cp0addr_Status)
    if (mtc0_we && cp0_addr==`cp0addr_Status)
        cp0_Status_data_r[`IM] <= mtc0_data[`IM];

    cp0_Status_data_r[`Bev] <= 1'b1;
end
assign cp0_Status_data = cp0_Status_data_r | 32'b0;
endmodule