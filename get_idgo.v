/*====================Ports Declaration====================*/
module get_idgo (
    input wire [4:0] wr_exe,wr_mem,wr_wb,
    input wire [2:0] get_idgo_idcon,//control:{0:rsrt,1:rs,2:rt}
    input wire gei_idgo_execon,gei_idgo_memcon,gei_idgo_wbcon,//control:{0:不需要,1:需要}
    input wire [4:0] RR1,RR2,
    output wire go_id
    );
/*====================Variable Declaration====================*/

/*====================Function Code====================*/

endmodule