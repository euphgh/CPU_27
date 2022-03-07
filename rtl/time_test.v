`timescale 1ns / 1ps
module time_test(
    input wire clk,rst_n,
    input wire [31:0] in0,in1,
    input wire op,
    output reg [63:0] out0
    );
reg  [31:0]  scr0;
reg  [31:0]  scr1;
reg  multop;      
always @(posedge clk ) begin
    if (!rst_n) begin
        scr0 <= 32'd0;
        scr1 <= 32'd0;
        multop <= 1'b0;
    end
    else begin
        scr0 <= in0;
        scr1 <= in1;
        multop <= op;
    end
end
wire  [63:0]  mult_res;

mult  u_mult (
    .clk                     ( clk        ),
    .rst_n                   ( rst_n      ),
    .scr0                    ( scr0       ),
    .scr1                    ( scr1       ),
    .multop                  ( multop     ),

    .mult_res                ( mult_res   ) 
);
always @(posedge clk ) begin
    if (!rst_n) begin
        out0 <= 64'b0;
    end
    else begin
        out0 <= mult_res;
    end    
end
endmodule
