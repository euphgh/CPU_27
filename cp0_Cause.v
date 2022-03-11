`include "defines.vh"
/*====================Ports Declaration====================*/
module cp0_Cause (
    input  wire clk,rst_n,mtc0_we,exception,bd,equal,
    input  wire [5:0] ext_int,
    input  wire [4:0] ExcCode, 
    input  wire [7:0] cp0_addr,
    input  wire [31:0] mtc0_data,
    output wire [31:0] cp0_Cause_data
    );
/*====================Variable Declaration====================*/
reg [31:0] cp0_Cause_data_r;
/*====================Function Code====================*/
always @(posedge clk ) begin
    //BD
    if (!rst_n) 
        cp0_Cause_data_r[`BD] <= `BD_ini;
    else if (exception) 
        cp0_Cause_data_r[`BD] <= bd;
    //TI
    if (!rst_n)
        cp0_Cause_data_r[`TI] <= `TI_ini;
    else if (mtc0_we && cp0_addr==`cp0addr_Compare)
        cp0_Cause_data_r[`TI] <= 1'b0;
    else if (equal)
        cp0_Cause_data_r[`TI] <= 1'b1;
    //IP72
    if (!rst_n)
        cp0_Cause_data_r[`IP_hard] <=`IP_hard_ini;
    else begin
        cp0_Cause_data_r[`IP7] <= ext_int[5]|cp0_Cause_data_r[`TI];
        cp0_Cause_data_r[`IP6to2] <= ext_int[4:0];
    end
    //IP2
    if (!rst_n)
        cp0_Cause_data_r[`IP_soft] <=`IP_soft_ini;
    else if (mtc0_we && cp0_addr==`cp0addr_Cause)
        cp0_Cause_data_r[`IP_soft] <= mtc0_data[`IP_soft];
    //ExcCode
    if (!rst_n) 
        cp0_Cause_data_r[`ExcCode] <= `ExcCode_ini;
    else if (exception) 
        cp0_Cause_data_r[`ExcCode] <= ExcCode;
end
assign cp0_Cause_data = cp0_Cause_data_r | 32'b0;
endmodule