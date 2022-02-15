`include "defines.vh"
/*====================Ports Declaration====================*/
module mycpu_top (
    input wire clk,     
    input wire resetn,  
    input wire [5:0] ext_int, 

    output wire inst_sram_en,     
    output wire [3:0] inst_sram_wen,    
    output wire [31:0] inst_sram_addr,   
    output wire [31:0] inst_sram_wdata,  
    input wire [31:0] inst_sram_rdata,  
    
    output wire data_sram_en,     
    output wire [3:0] data_sram_wen,    
    output wire [31:0] data_sram_addr,   
    output wire [31:0] data_sram_wdata,  
    input wire [31:0] data_sram_rdata,  

    //debug
    output wire [31:0] debug_wb_pc,      
    output wire [3:0] debug_wb_rf_wen, 
    output wire [4:0] debug_wb_rf_wnum, 
    output wire [31:0] debug_wb_rf_wdata
    );
/*====================Variable Declaration====================*/

/*====================Function Code====================*/
// datapath Inputs
// wire  clk;[port]
wire  rst_n;
// wire  [31:0]  inst_sram_rdata;[port]
// wire  [31:0]  data_sram_rdata;[port]

// datapath Outputs
// wire  inst_sram_en;[port]
// wire  [3:0]  inst_sram_wen;   [port]
// wire  [31:0]  inst_sram_addr; [port]
// wire  [31:0]  inst_sram_wdata;[port]
// wire  data_sram_en;[port]
// wire  [3 :0]  data_sram_wen;  [port]
// wire  [31:0]  data_sram_addr; [port]
// wire  [31:0]  data_sram_wdata;[port]
// wire  [31:0]  debug_wb_pc;    [port]
// wire  [3:0]  debug_wb_rf_wen; [port]
// wire  [4:0]  debug_wb_rf_wnum;[port]
// wire  [31:0]  debug_wb_rf_wdata;[port]

datapath  u_datapath (
    .clk                     ( clk                 ),
    .rst_n                   ( rst_n               ),
    .inst_sram_rdata         ( inst_sram_rdata     ),
    .data_sram_rdata         ( data_sram_rdata     ),
    .ext_int                 ( ext_int             ),

    .inst_sram_en            ( inst_sram_en        ),
    .inst_sram_wen           ( inst_sram_wen       ),
    .inst_sram_addr          ( inst_sram_addr      ),
    .inst_sram_wdata         ( inst_sram_wdata     ),
    .data_sram_en            ( data_sram_en        ),
    .data_sram_wen           ( data_sram_wen       ),
    .data_sram_addr          ( data_sram_addr      ),
    .data_sram_wdata         ( data_sram_wdata     ),
    .debug_wb_pc             ( debug_wb_pc         ),
    .debug_wb_rf_wen         ( debug_wb_rf_wen     ),
    .debug_wb_rf_wnum        ( debug_wb_rf_wnum    ),
    .debug_wb_rf_wdata       ( debug_wb_rf_wdata   )
);
assign rst_n = resetn;

endmodule