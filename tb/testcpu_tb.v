//~ `New testbench
`timescale  1ns / 1ps  

module testcpu_tb;     

// testcpu Parameters  
parameter PERIOD  = 10;
reg rst_n=0;

// testcpu Inputs      
reg   clk                = 0 ;
reg   [5:0]  ext_int     = 0 ;
// testcpu Outputs
wire  [31:0]  debug_wb_pc                  ;
wire  [3:0]  debug_wb_rf_wen               ;
wire  [4:0]  debug_wb_rf_wnum              ;
wire  [31:0]  debug_wb_rf_wdata            ;

initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

testcpu  u_testcpu (
    .clk                     ( clk                       ),
    .resetn                  ( rst_n                     ),
    .ext_int                 ( ext_int             ),

    .debug_wb_pc             ( debug_wb_pc         ),
    .debug_wb_rf_wen         ( debug_wb_rf_wen     ),
    .debug_wb_rf_wnum        ( debug_wb_rf_wnum    ),
    .debug_wb_rf_wdata       ( debug_wb_rf_wdata   )
);

initial
begin
    #(60*PERIOD);
    $finish;
end

endmodule