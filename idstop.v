/*====================Ports Declaration====================*/
module idstop (
    input wire [4:0] wr_exe,wr_mem,
    input wire [2:0] idstop_idcon,//control:{0:rs,1:rt,2:rtrs}
    input wire idstop_execon,idstop_memcon,//control:{0:不需要,1:需要}
    input wire [4:0] RR1,RR2,
    output wire idstop_out
    );
/*====================Variable Declaration====================*/
wire [1:0] same_r;
/*====================Function Code====================*/
assign same_r[0] =  (|RR1)&&(((RR1==wr_exe)&&idstop_execon) ? 1'b1 :
                    ((RR1==wr_mem)&&idstop_memcon) ? 1'b1 : 1'b0);
assign same_r[1] =  (|RR2)&&(((RR2==wr_exe)&&idstop_execon) ? 1'b1 :
                    ((RR2==wr_mem)&&idstop_memcon) ? 1'b1 : 1'b0);
 
assign idstop_out = ({idstop_idcon[0]||idstop_idcon[2]} && same_r[0]) |
                    ({idstop_idcon[1]||idstop_idcon[2]} && same_r[1]) ;
endmodule