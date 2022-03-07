//~ `New testbench
`timescale  1ns / 1ps

module tb_Reg;

// Reg Parameters
parameter PERIOD  = 10;


// Reg Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   [3:0]  reg_we                        = 4'b1111 ;
reg   [4:0]  RR1                           = 0 ;
reg   [4:0]  RR2                           = 0 ;
reg   [4:0]  WR                            = 5'd1 ;
reg   [31:0]  WD                           = 0 ;

// Reg Outputs
wire  [31:0]  RD1                          ;    
wire  [31:0]  RD2                          ;    


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

Reg  u_Reg (
    .clk                     ( clk            ),
    .rst_n                   ( rst_n          ),
    .reg_we                  ( reg_we   ),
    .RR1                     ( RR1      ),
    .RR2                     ( RR2      ),
    .WR                      ( WR       ),
    .WD                      ( WD       ),

    .RD1                     ( RD1      ),
    .RD2                     ( RD2      )
);

initial
begin
    WD = 32'h11111111;
    #(PERIOD*3) WD = 32'h22222222;
    #(PERIOD*3);
    $finish;
end

endmodule