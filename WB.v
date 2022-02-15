`include "defines.vh"
/*====================Ports Declaration====================*/
module WB(
    //sys
	input  wire clk,rst_n,
    output wire wb_allowin_out,
    input  wire mem_valid_in,
    output wire wb_valid_out,
    //datain
	input wire [31:0] mem_wbdata_in, //data:回写数据
    input wire [3:0]  mem_reg_we_in, //control:回写使能
    input wire [31:0] mem_PC_in,
    input wire [4:0]  mem_wnum_in,
    input wire [2:0]  mem_write_type_in,
    //dataout
	output wire [31:0] wb_wbdata_out, //data:回写数据
	output wire [3:0]  wb_reg_we_out, //control:回写使能
    output wire [4:0]  wb_wnum_out,
    output reg  [4:0]  wb_wnum_reg_out,
    output reg  [2:0]  wb_write_type_out,

    //debug 信号， 供验证平台使用效
    output reg [31:0] debug_wb_pc,   //写回级（多周期最后一级） 的 PC， 因而需要 mycpu信号，高电平有效
    output reg [3:0]  debug_wb_rf_wen,   //写回级写寄存器堆(regfiles)的写使能，为字节写，字节寻址
    output reg [4:0]  debug_wb_rf_wnum,   //写回级写 regfiles 的目的寄存器号
    output reg [31:0] debug_wb_rf_wdata   //写回级写 regfiles 的写数据
);
/*====================Variable Declaration====================*/

// other----------------------------------------
wire [31:0] WB_PC;
assign WB_PC = debug_wb_pc;
wire allowin,ready;
reg  valid_r;
// ---------------------------------------------
/*====================Function Code====================*/
assign ready = 1'b1; 
assign allowin = (!valid_r) || ready ;
assign wb_allowin_out = allowin;
assign wb_valid_out = ready && valid_r;
always @(posedge clk ) begin
    if (!rst_n) begin
        valid_r <= 1'b0;
    end else begin
        valid_r <= mem_valid_in;
    end
end

assign wb_wbdata_out = mem_wbdata_in;
assign wb_reg_we_out = mem_reg_we_in;
assign wb_wnum_out = mem_wnum_in;

always @(posedge clk) begin
    if (!rst_n) begin
        debug_wb_pc <= `debug_wb_pc;
        debug_wb_rf_wen <= `debug_wb_rf_wen;
        debug_wb_rf_wnum <= `debug_wb_rf_wnum;
        debug_wb_rf_wdata <= `debug_wb_rf_wdata;
        wb_write_type_out <= `wb_write_type;
        wb_wnum_reg_out <= `wb_wnum_reg;
    end
    else if (allowin && mem_valid_in) begin
        debug_wb_pc <= mem_PC_in;
        debug_wb_rf_wen <= mem_reg_we_in;
        debug_wb_rf_wnum <= mem_wnum_in;
        debug_wb_rf_wdata <= mem_wbdata_in;
        wb_write_type_out <= mem_write_type_in;
        wb_wnum_reg_out <= mem_wnum_in;
    end
    else if (!mem_valid_in) begin
        debug_wb_rf_wen <= `debug_wb_rf_wen;
        debug_wb_rf_wnum <= `debug_wb_rf_wnum;
        debug_wb_rf_wdata <= `debug_wb_rf_wdata;
        wb_write_type_out <= `wb_write_type;
        wb_wnum_reg_out <= `wb_wnum_reg;
    end
end
endmodule