//~ `New testbench
`timescale  1ns / 1ps

module tb_mult;

// mult Parameters
parameter PERIOD  = 10;
reg clk = 0 ;
reg rst_n = 0 ;

// mult Inputs
reg   [31:0]  scr0                         = 32'hf000_0000 ;
reg   [31:0]  scr1                         = 32'h9e00_0000 ;
reg   multop                               = 1 ;

// mult Outputs
wire  [63:0]  mult_res                     ;    


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

mult  u_mult (
    .scr0                    ( scr0     ),
    .scr1                    ( scr1     ),
    .multop                  ( multop   ),

    .mult_res                ( mult_res )
);

always @(posedge clk)begin
    scr0 <=  $random;
    scr1 <=  $random;
    multop <=  {$random}%2;
end

wire signed [63:0] result_ref;
wire signed [32:0] x_e;
wire signed [32:0] y_e;
assign x_e        = {multop & scr0[31],scr0};
assign y_e        = {multop & scr1[31],scr1};
assign result_ref = x_e * y_e;
assign ok         = (result_ref == mult_res);

endmodule