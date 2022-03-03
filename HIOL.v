/*====================Ports Declaration====================*/
module hiol (
    input wire clk,rst_n,
    input wire [1:0] wen_hiol, //control:{0:hi,1:ol} 
    input wire [63:0] data_in,
    output wire [31:0] hi_out,ol_out
    );
/*====================Variable Declaration====================*/
reg [31:0] data_hi,data_ol;
/*====================Function Code====================*/
always @(posedge clk ) begin
    if (!rst_n) begin
        data_hi <= 32'b0;
        data_ol <= 32'b0;
    end
    else begin
        data_hi <= wen_hiol[0] ? data_in[63:32] : data_hi;
        data_ol <= wen_hiol[1] ? data_in[31:0]  : data_ol;
    end
end
assign hi_out = data_hi;
assign ol_out = data_ol;
endmodule