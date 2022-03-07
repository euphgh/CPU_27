`include "defines.vh"
/*====================Ports Declaration====================*/
module testcpu (
    input wire clk,     
    input wire resetn,  
    input wire [5:0] ext_int, 
    //debug
    output wire [31:0] debug_wb_pc,      
    output wire [3:0] debug_wb_rf_wen,
    output wire [4:0] debug_wb_rf_wnum, 
    output wire [31:0] debug_wb_rf_wdata
    );
/*====================Variable Declaration====================*/
wire inst_sram_en;     
wire [3:0] inst_sram_wen;    
wire [31:0] inst_sram_addr;  
wire [31:0] inst_sram_wdata; 
wire [31:0] inst_sram_rdata;

wire data_sram_en;     
wire [3:0] data_sram_wen;
wire [31:0] data_sram_addr;   
wire [31:0] data_sram_wdata;  
wire [31:0] data_sram_rdata;  
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

/*====================Function Code====================*/
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
data_ram dm (
  .clka(clk),    
  .ena(data_sram_en),      // input wire ena
  .wea(data_sram_wen),      // input wire [3 : 0] wea
  .addra({data_sram_addr[15:2]}),  // input wire [17 : 0] addra
  .dina(data_sram_wdata),    // input wire [31 : 0] dina
  .douta(data_sram_rdata)  // output wire [31 : 0] douta
);
ins_ram im (
  .clka(clk),    
  .ena(inst_sram_en),      // input wire ena
  .wea(inst_sram_wen),      // input wire [3 : 0] wea
  .addra({inst_sram_addr[15:2]}),  // input wire [17 : 0] addra
  .dina(inst_sram_wdata),    // input wire [31 : 0] dina
  .douta(inst_sram_rdata)  // output wire [31 : 0] douta
);

endmodule