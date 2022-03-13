/*====================Ports Declaration====================*/
module mult_div (
        input wire clk,rst_n,
        input wire [3:0] exe_mult_div_signed_in,//dataw:{0:mult,1:multu,2:div,3:divu}
        input wire [31:0] in0,in1,//dataw:
        input wire wb_ClrStpJmp_in,

        output wire div_complete_out,
        output wire mult_complete_out,
        output wire [63:0] mult_res_out,
        output wire [63:0] div_res_out,
        output wire div_tready_out
    );
    /*====================Variable Declaration====================*/
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
    assign multop = exe_mult_div_signed_in[0];
    assign mult_res_out = mult_res;
    // div Inputs
    wire  div_signed,reseten;
    wire  [31:0]  x;
    wire  [31:0]  y;
    // div Outputs
    wire  [31:0]  s;
    wire  [31:0]  r;
    wire  complete,div_tready;
    wire  [5:0] timer_out;

    div  u_div (
             .div_clk                 ( clk          ),
             .resetn                  ( reseten      ),
             .div                     ( div          ),
             .div_signed              ( div_signed   ),
             .x                       ( x            ),
             .y                       ( y            ),

             .s                       ( s            ),
             .r                       ( r            ),
             .complete                ( complete     ),
             .timer_out               ( timer_out    ),
             .div_tready              ( div_tready   )
         );
    assign reseten = rst_n&&(!(wb_ClrStpJmp_in&&(|timer_out[5:2])));
endmodule
