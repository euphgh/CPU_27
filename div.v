/*====================Ports Declaration====================*/
module div (
    input  wire div_clk,resetn,mem_ClrStpJmp_in,
    input  wire div,
    input  wire div_signed, //{0:无符号,1:有符号}
    input  wire [31:0] x,y,
    output wire [31:0] s,r,
    output wire complete
    );
/*====================Variable Declaration====================*/
wire clk = div_clk;
wire rst_n = resetn;
wire x_sign,y_sign;
wire first;
wire [31:0] x_abs,y_abs;
reg [5:0] timer; 
reg [31:0] divisor,quotient_iter;
reg [63:0] minuend;
wire reminder_sign,quotient_sign;
reg reminder_sign_r,quotient_sign_r;
wire  [31:0]  quotient_temp;
wire  [63:0]  minuend_back;
wire pre_complete;
wire ge3 = (|timer[5:2])||(timer[0]&&timer[1]); //计数周期在3及其以上
wire break = mem_ClrStpJmp_in && (!ge3);
/*====================Function Code====================*/
assign x_sign = x[31]&&div_signed;
assign y_sign = y[31]&&div_signed;
assign x_abs = ({32{x_sign}}^x) + x_sign;
assign y_abs = ({32{y_sign}}^y) + y_sign; 
assign first = !(|timer);
assign quotient_sign = (x[31]^y[31]) && div_signed;
assign reminder_sign = x[31] && div_signed;

always @(posedge clk ) begin
    if (!(rst_n&&div)||complete||break) begin
        divisor <= 32'hffff_ffff;
        minuend <= 64'b0;
        timer = 6'b0;
        quotient_iter <= 32'b0;
        reminder_sign_r <= 1'b0;
        quotient_sign_r <=1'b0;
    end
    else begin
        timer <= timer+1'b1;
        minuend <= first ? {32'b0,x_abs}:(minuend_back);
        divisor <= first ? y_abs : divisor;
        quotient_iter <= quotient_temp; 
        reminder_sign_r = (first) ? reminder_sign : reminder_sign_r;
        quotient_sign_r = (first) ? quotient_sign : quotient_sign_r;
    end
end

try_div_ans  u_try_div_ans (
    .minuend                 ( minuend         ),
    .divisor                 ( divisor         ),
    .timer                   ( timer           ),
    .quotient_iter           ( quotient_iter   ),

    .quotient_temp           ( quotient_temp   ),
    .minuend_back            ( minuend_back    ),
    .pre_complete            ( pre_complete    )
);
reg [31:0] quotient_temp_r;
reg [31:0] minuend_back_r;
reg pre_complete_r;
always @(posedge clk ) begin
    if (!(rst_n&&div)||complete) begin
        quotient_temp_r <= 32'b0;
        minuend_back_r <= 32'b0;
        pre_complete_r <= 1'b0;
    end
    else begin
        quotient_temp_r <= quotient_temp;
        minuend_back_r <= minuend_back[63:32];
        pre_complete_r <= pre_complete;
    end
end
assign s = quotient_sign_r ? (~quotient_temp_r+1'b1) : quotient_temp_r;
assign r = reminder_sign_r ? (~minuend_back_r+1'b1) : minuend_back_r;
assign complete = pre_complete_r;
endmodule