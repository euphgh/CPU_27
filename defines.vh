//IF
`define ini_id_brcal_res_in 1'b0
`define ini_id_bjpc_res_in 32'b0
`define ini_id_NPC_in 32'hbfc00000

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
//new
`define ini_if_PC_in 32'b0
`define ini_if_NPC_in 32'hbfc00000
`define ini_if_NNPC_in 32'b0
`define ini_exe_wnum 4'b0
`define ini_mem_wnum 4'b0
`define ini_wb_wnum 4'b0
`define ini_exe_type 3'b0
`define ini_mem_type 3'b0
`define ini_wb_type 3'b0
//EXE
`define ini_id_sbhw_con_in 3'b0
`define ini_id_addrexc_con_in 4'b0
`define ini_id_sel_wbdata_in 4'b0
`define ini_id_aluop_in 12'b0
`define ini_id_RD2_in 32'b0
`define ini_id_aludata1_in 32'b0
`define ini_id_aludata2_in 32'b0
`define ini_id_sel_dm_con_in 2'b0
`define ini_id_lr_con_in 2'b0
`define ini_id_lubhw_con_in 5'b0
`define ini_id_PC_in 32'b0
`define ini_id_NNPC_in 32'b0
`define ini_id_regnum_in 5'b0
`define ini_id_write_type_in 3'b0
//MEM
`define ini_wbdata 32'b0   
`define ini_reg_we_mem 4'b0
`define ini_exe_write_type_in 3'b0
`define ini_exe_sel_wbdata_in 4'b0
`define ini_exe_aluout_in 32'b0   
`define ini_exe_onehot_in 8'b0    
`define ini_exe_lubhw_con_in 5'b0 
`define ini_exe_PC_in 32'b0       
`define ini_exe_NNPC_in 32'b0     
`define ini_exe_regnum_in 5'b0    

// addrexc
`define AdEL 8'h04 
`define AdES 8'h05

//datapath
`define debug_wb_pc 32'b0
`define debug_wb_rf_wen 4'b0
`define debug_wb_rf_wnum 5'b0
`define debug_wb_rf_wdata 32'b0

//WB
`define wb_write_type 3'b0
`define wb_wnum_reg 3'b0