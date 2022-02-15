`include "defines.vh"
/*====================Ports Declaration====================*/
module idready (
    input wire [2:0] exe_write_type,mem_write_type,wb_write_type, //control{0:wb,1:mem,2:exe,000:nocheck}
    input wire [4:0] exe_wnum,mem_wnum,wb_wnum,
    input wire [2:0] read_type, //control:{0:rs1:rt2:rtrs}
    input wire [4:0] RR1,RR2,
    output wire ready
    );
/*====================Variable Declaration====================*/
wire exe_RR1,mem_RR1,wb_RR1;
wire exe_RR2,mem_RR2,wb_RR2;
wire exe_same,mem_same,wb_same;
wire exe_stop,mem_stop,wb_stop;
wire exe_check,mem_check,wb_check;
/*====================Function Code====================*/
assign exe_RR1 = (RR1==exe_wnum) ; 
assign mem_RR1 = (RR1==mem_wnum) ; 
assign  wb_RR1 = (RR1==wb_wnum) ;
assign exe_RR2 = (RR2==exe_wnum) ; 
assign mem_RR2 = (RR2==mem_wnum) ; 
assign  wb_RR2 = (RR2==wb_wnum) ;
assign exe_check = (|exe_write_type) ; 
assign mem_check = (|mem_write_type) ; 
assign wb_check = (|wb_write_type) ;
assign exe_same = ((read_type[0]||read_type[2]) && exe_RR1)
                | ((read_type[1]||read_type[2]) && exe_RR2);
assign mem_same = ((read_type[0]||read_type[2]) && mem_RR1)
                | ((read_type[1]||read_type[2]) && mem_RR2);
assign wb_same = ((read_type[0]||read_type[2]) && wb_RR1)
               | ((read_type[1]||read_type[2]) && wb_RR2);
assign exe_stop = exe_same && exe_check;
assign mem_stop = mem_same && mem_check;
assign wb_stop = wb_same && wb_check;
assign ready = !(exe_stop||mem_stop)&&1'b1;
endmodule