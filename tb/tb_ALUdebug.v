//~ `New testbench
`timescale  1ns / 1ps  

module tb_ALUdebug;

// ALU Parameters      
parameter PERIOD  = 10;


// ALU Inputs
reg   [31:0]  scr0                         = 0 ;
reg   [31:0]  scr1                         = 0 ;
reg   [11:0]  aluop                        = 0 ;

// ALU Outputs
wire  overflow                             ;
wire  [31:0]  aluso                        ;

ALU  u_ALU (
    .scr0                    ( scr0       ),
    .scr1                    ( scr1       ),
    .aluop                   ( aluop      ),

    .overflow                ( overflow   ),
    .aluso                   ( aluso      )
);

initial
begin
    aluop = 12'd1;scr1 = 32'h0000fbac;scr0 = 32'h12345678;
    #(PERIOD) scr1 = 32'hbfac0000;

    $finish;
end

endmodule