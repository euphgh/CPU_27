`include "defines.vh"
/*====================Ports Declaration====================*/
module mult_div (
    input wire clk,rst_n,
    input wire [7:0] mult_div_op, //control:{0:mult,1:multu,2:div,3:divu,4:mfhi,5:mflo,6:mthi,7:mtol}
    input wire [31:0] in0,in1, //data:{运算指令时即为运算数字，MT指令时in0为hi,in1为ol}
    output wire [31:0] hi,ol,
    output reg accessible //control:表示hiol的数据可以使用
    );
/*====================Variable Declaration====================*/
reg div;
/*====================Function Code====================*/
wire  [31:0]  scr0;
wire  [31:0]  scr1;
wire  multop;      
// mult Outputs
wire  [63:0]  mult_res;
mult  u_mult (
    .clk                     ( clk        ),
    .rst_n                   ( rst_n      ),
    .scr0                    ( scr0       ),
    .scr1                    ( scr1       ),
    .multop                  ( multop     ),

    .mult_res                ( mult_res   ) 
);
assign scr0 = in0;
assign scr1 = in1;
assign multop = mult_div_op[0];
// div Inputs    
wire  div_signed;
wire  [31:0]  x; 
wire  [31:0]  y; 
// div Outputs
wire  [31:0]  s;
wire  [31:0]  r;
wire  complete;

div  u_div (
    .div_clk                 ( clk          ),
    .resetn                  ( rst_n        ),
    .div                     ( div          ),
    .div_signed              ( div_signed   ),
    .x                       ( x            ),
    .y                       ( y            ),

    .s                       ( s            ),
    .r                       ( r            ),
    .complete                ( complete     ) 
);
always @(posedge clk ) begin
    if (!rst_n) begin
        div <= 1'b0;
        accessible <= 1'b0;
    end
    else begin
        div <= div ? (!complete) : (|mult_div_op[3:2]);
        accessible <=  !div;
    end
end
assign x = in0;
assign y = in1;
assign div_signed = mult_div_op[2];
// hiol Inputs        
wire  [1:0] wen_hiol;       
wire  [63:0]  data_in;

// hiol Outputs
wire  [31:0]  hi_out;
wire  [31:0]  ol_out;

hiol  u_hiol (
    .clk                     ( clk        ),
    .rst_n                   ( rst_n      ),
    .wen_hiol                ( wen_hiol   ),
    .data_in                 ( data_in    ),

    .hi_out                  ( hi_out     ),
    .ol_out                  ( ol_out     ) 
);
assign hi = hi_out;
assign ol = ol_out;
assign wen_hiol = mult_div_op[7:6]||{2{|mult_div_op[3:0]}};
assign data_in =    (|mult_div_op[1:0]) ? mult_res :
                    (|mult_div_op[3:2]) ? {s,r} : {in0,in1};
endmodule