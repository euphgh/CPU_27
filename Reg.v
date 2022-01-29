`timescale 1ns / 1ps
module Reg
    (
    input wire clk,
    input wire rst_n,
    input wire [3:0] reg_we,
    input wire [4:0] RR1,RR2,WR,
    input wire [31:0] WD,
    output wire [31:0] RD1,RD2
    );
    reg [31:0] rf [31:0];

    initial begin
        $readmemh("D:/4Dworks/lab1/lab1.srcs/sources_1/new/lab2_reg_data.txt", rf);
    end
    always @(negedge rst_n) begin//异步清零
        $readmemh("D:/4Dworks/lab1/lab1.srcs/sources_1/new/lab2_reg_data.txt", rf);
    end
    always @(posedge clk) begin
        if ((reg_we[0]||reg_we[1]||reg_we[2]||reg_we[3]) && (|WR)) begin
            rf[WR][7:0] = reg_we[0] ? WD[7:0] : rf[WR][7:0];
            rf[WR][15:8] = reg_we[1] ? WD[15:8] : rf[WR][15:8];
            rf[WR][23:16] = reg_we[2] ? WD[23:16] : rf[WR][23:16];
            rf[WR][31:24] = reg_we[3] ? WD[31:24] : rf[WR][31:24];
        end 
    end
    assign RD1=(RR1==5'b0) ? 32'b0:rf[RR1];
    assign RD2=(RR2==5'b0) ? 32'b0:rf[RR2];
endmodule