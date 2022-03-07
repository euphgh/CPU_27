//~ `New testbench
`timescale  1ns / 1ps

module tb_ThreeToTwo;
reg clk=1;
reg rst_n = 0;
// ThreeToTwo Parameters
parameter PERIOD  = 10;


// ThreeToTwo Inputs
reg   [7:0]  in0                     = 0 ;
reg   [7:0]  in1                     = 0 ;
reg   [7:0]  in2                     = 0 ;

// ThreeToTwo Outputs
wire  [8:0]  out0                      ;    
wire  [8:0]  out1                      ;    


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

ThreeToTwo #(.BUSin(8)) u_ThreeToTwo (
    .in0                     ( in0  ),
    .in1                     ( in1  ),
    .in2                     ( in2  ),

    .out0                    ( out0 ),
    .out1                    ( out1 )
);
always @(posedge clk) begin
    in0 <= $random;
    in1 <= $random;
    in2 <= $random; 
end

wire [9:0] Three_sum = in0 + in1 + in2;
wire [9:0] Two_sum = out0 + out1;
wire ok = (Three_sum==Two_sum);
endmodule