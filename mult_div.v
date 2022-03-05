/*====================Ports Declaration====================*/
module mult_div (
        input wire clk,rst_n,
        input wire [5:0] mult_div_op, //control:{0:mult,1:multu,2:div,4:mthi,5:mtol}
        input wire [31:0] in0,in1, //data:{运算指令时即为运算数字，MT指令时in0为hi,in1为ol}
        input wire read_request, //{0:mthi,1:mtol}
        output wire [31:0] mult_div_res,
        output reg accessible //control:表示hiol的数据可以使用
    );
    /*====================Variable Declaration====================*/
    reg div;
    wire div_w;
    reg [5:0] mult_div_op_r;
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
             .div                     ( div_w        ),
             .div_signed              ( div_signed   ),
             .x                       ( x            ),
             .y                       ( y            ),

             .s                       ( s            ),
             .r                       ( r            ),
             .complete                ( complete     )
         );
    always @(posedge clk )
    begin
        if (!rst_n)
        begin
            div <= 1'b0;
            accessible <= 1'b0;
        end
        else
        begin
            div <= div ? (!complete) : (|mult_div_op[3:2]);
            accessible <= (div&&complete)||(!div);
        end
    end
    assign div_w = (|mult_div_op[3:2])||div;
    assign x = in0;
    assign y = in1;
    assign div_signed = mult_div_op[2];

    wire [63:0] mt_temp0;
    wire [1:0] wen_temp0;
    reg [63:0] mt_temp1;
    reg [1:0] wen_temp1;

    assign mt_temp0 =  {in0,in1};
    assign wen_temp0 = (|mult_div_op_r[2:0]) ? 2'b11 :
                        (mult_div_op_r[4]) ? 2'b10 :
                        (mult_div_op_r[5]) ? 2'b01 :2'b00;

    always @(posedge clk ) 
    begin
        if (!rst_n) begin
            mt_temp1 <= 32'b0;
            wen_temp1 <= 2'b0;
            mult_div_op_r <= 6'b0;
        end
        else begin
            mt_temp1 <= mt_temp0;
            wen_temp1 <= wen_temp0;
            mult_div_op_r <= mult_div_op;
        end
    end
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
    assign wen_hiol = complete ? 2'b11 : wen_temp1;
    assign data_in =  complete ? {r,s} : 
                        (|mult_div_op_r[2:0]) ? mult_res : mt_temp1;
    assign mult_div_res = read_request ? hi_out : ol_out;
endmodule
