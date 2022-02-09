//全局
`define RstEnable 1'b1
`define RstDisable 1'b0
`define ZeroWord 32'h00000000
`define WriteEnable 1'b1
`define WriteDisable 1'b0
`define ReadEnable 1'b1
`define ReadDisable 1'b0
`define AluOpBus 7:0
`define AluSelBus 2:0
`define InstValid 1'b0
`define InstInvalid 1'b1
`define Stop 1'b1
`define NoStop 1'b0
`define InDelaySlot 1'b1
`define NotInDelaySlot 1'b0
`define Branch 1'b1
`define NotBranch 1'b0
`define InterruptAssert 1'b1
`define InterruptNotAssert 1'b0
`define TrapAssert 1'b1
`define TrapNotAssert 1'b0
`define True_v 1'b1
`define False_v 1'b0
`define ChipEnable 1'b1
`define ChipDisable 1'b0

//IF
`define StartPoint 32'h00000000
`define ini_Instruct 32'h00000000 //BFC0_0000的J指令
`define ini_NPC_reg 32'hbfc00_000 //高四位是B
`define ini_PC_reg 32'b0
`define StartNPC 32'hbfc00000
`define StartNNPC 32'hbfc00004

//ID
`define ini_sel_wbdata_id 3'b0
`define ini_sel_dm_id 2'b0
`define ini_sel_mw_con_id 2'b0
`define ini_RD1 32'b0
`define ini_RD2 32'b0
`define ini_aluop 12'b0
`define ini_aludata1 32'b0
`define ini_aludata2 32'b0
`define ini_instr_index 26'b0
`define ini_sbhw_con 3'b0
`define ini_addrexc_con 5'b0
`define ini_lr_con 2'b0
`define ini_lubhw_con_id 5'b0 
`define ini_NNPC_id 32'b0
`define ini_regnum_id 5'b0
`define ini_PC_id 32'b0
`define idstop_con_w_reg 1'b0
//EXE
`define ini_aluout_exe 32'b0
`define ini_sel_wbdata_exe 3'b0
`define ini_lubhw_con_exe 5'b0
`define ini_onehot 8'b0
`define ini_regnum_exe 5'b0
`define ini_exe_reg 32'b0//决定debugpc初值1级
`define idstop_con_w_tmo 1'b0//最初不暂停
`define idstop_con_w_eo 1'b0

//MEM
`define ini_wbdata 32'b0   
`define ini_reg_we_mem 4'b0

// addrexc
`define AdEL 8'h04 
`define AdES 8'h05

//datapath
`define debug_wb_pc 32'b0
`define debug_wb_rf_wen 4'b0
`define debug_wb_rf_wnum 5'b0
`define debug_wb_rf_wdata 32'b0