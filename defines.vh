//PC
`define StartPoint 32'b0
`define StartNPC 32'b0
`define StartNNPC 32'b0
//IF
`define ini_id_brcal_res_in 1'b0
`define ini_id_bjpc_res_in 32'b0
`define ini_id_nextPC_in 32'hbfc00000 
`define ini_if_NPC_in 32'hbfbf_fffc
`define ini_id_RD1_in 32'b0
`define ini_id_RD2_in 32'b0
`define ini_id_extend_res_in 32'b0
`define ini_id_instr_index_in 32'b0
`define ini_id_bjpc_con_in 32'b0
`define ini_id_brcal_con_in 32'b0

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
`define ini_if_Instruct_in 32'b0
//new
`define ini_if_PC_in 32'b0
`define ini_if_NNPC_in 32'b0
`define ini_exe_wnum 4'b0
`define ini_mem_wnum 4'b0
`define ini_wb_wnum 4'b0
`define ini_exe_type 3'b0
`define ini_mem_type 3'b0
`define ini_wb_type 3'b0
//EXE
`define ini_id_mul_div_op 6'b0
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
//WB
`define ini_mem_PC_in 32'b0
`define ini_mem_dm_data_in 32'b0
`define ini_mem_wnum_in 5'b0
`define ini_mem_sel_wbdata_in 5'b0
`define ini_mem_onehot_in 8'b0
`define ini_mem_lubhw_con_in 2'b0
`define ini_mem_adrl_in 2'b0
`define ini_mem_write_type_in 3'b0
`define ini_mem_wbdata_in 32'b0
`define ini_mem_llr_we_in 4'b0

//datapath
`define debug_wb_pc 32'b0
`define debug_wb_rf_wen 4'b0
`define debug_wb_rf_wnum 5'b0
`define debug_wb_rf_wdata 32'b0


//CP0
//Status
`define Bev 22
`define Bev_ini 1'b0
`define EXL 1
`define EXL_ini 1'b0
`define IE 0
`define IE_ini 1'b0
`define IM 15:8
`define IM_ini 8'b0
`define cp0addr_Status  6'b011000
//Cause
`define TI 30
`define BD 31
`define IP_hard 15:10
`define IP_soft 9:8
`define ExcCode 6:2
`define TI_ini 1'b0
`define BD_ini 1'b0
`define IP_hard_ini 6'b0
`define IP_soft_ini 2'b0
`define IP7 15
`define IP6to2 14:10
`define ExcCode_ini 5'b0
`define cp0addr_Compare  6'b010110
`define cp0addr_Cause  6'b011010
//EPC
`define EPC_ini 32'b0
`define cp0addr_EPC 6'b011100
//BadVAdrr
`define BadVAddr_ini 32'hbfc00000
//Count
`define cp0addr_Count 6'b010010
//compare
`define cp0addr_Compare 6'b010110
`define Compare_ini 32'b0
//ExcCode
`define Int 5'b0
`define AdEL 5'b00100
`define AdES 5'b00101
`define Sys  5'b01000
`define Bp   5'b01001
`define RI   5'b01010
`define Ov   5'b01100