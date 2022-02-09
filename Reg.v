`timescale 1ns / 1ps
module Reg(
    input wire clk,
    input wire rst_n, //只能做到保护寄存器内容不被修改
    input wire [3:0] reg_we,
    input wire [4:0] RR1,RR2,WR,
    input wire [31:0] WD,
    output wire [31:0] RD1,RD2
    );
    reg [31:0] rf [31:0];

    initial begin
        $readmemh("D:/4Dworks/lab1/lab1.srcs/sources_1/new/lab2_reg_data.txt", rf);
    end
    always @(posedge clk) begin
        if ((reg_we[0]||reg_we[1]||reg_we[2]||reg_we[3]) && (|WR) &&(rst_n) ) begin
            rf[WR][7:0] = reg_we[0] ? WD[7:0] : rf[WR][7:0];
            rf[WR][15:8] = reg_we[1] ? WD[15:8] : rf[WR][15:8];
            rf[WR][23:16] = reg_we[2] ? WD[23:16] : rf[WR][23:16];
            rf[WR][31:24] = reg_we[3] ? WD[31:24] : rf[WR][31:24];
        end 
    end
    wire readable1,readable2;
    assign readable1 = (|RR1)&&(rst_n);
    assign readable2 = (|RR2)&&(rst_n);
    assign RD1=readable1 ? rf[RR1]:32'b0;
    assign RD2=readable2 ? rf[RR2]:32'b0;
endmodule