//~ `New testbench
`timescale  1ns / 1ps

module tb_div;

// div Parameters
parameter PERIOD  = 10;


// div Inputs
reg   div_clk                              = 0 ;
reg   resetn                               = 0 ;
reg   div                                  = 0 ;
reg   div_signed                           = 0 ;
reg   [31:0]  x                            = 0 ;
reg   [31:0]  y                            = 0 ;

// div Outputs
wire  [31:0]  s                            ;    
wire  [31:0]  r                            ;    
wire  complete                             ;    


initial
begin
    forever #(PERIOD/2)  div_clk=~div_clk;
end

initial
begin
    #(PERIOD*2) resetn  =  1;
end

div  u_div (
    .div_clk                 ( div_clk    ),
    .resetn                  ( resetn     ),
    .div                     ( div        ),
    .div_signed              ( div_signed ),
    .x                       ( x          ),
    .y                       ( y          ),

    .s                       ( s          ),
    .r                       ( r          ),
    .complete                ( complete   )
);

initial
begin
    x <= 81;
    y <= 9;
    div_signed = 0;
    div <= 1;
    #(PERIOD*36);
    x <= -81;
    y <= 9;
    div_signed = 1;
    div <= 1;
    #(PERIOD*36);
    $finish;
end

endmodule