/*====================Ports Declaration====================*/
`include "defines.vh"
module ID(
	input wire clk,rst_n,go_id,
 	input wire [31:0] Instruct, //data:
	input wire [31:0] NPC,NNPC, //address:
	input wire [31:0] wbdata, //data:
	input wire [3:0] reg_we_mem, //control:
    input wire [31:0] PC_ifget,PC_memget,
    input wire [4:0] regnum_mem, //nc
    input wire idstop_out,

	output reg [3:0] sel_wbdata_id_reg, //control:
	output reg [1:0] sel_dm_id_reg, //control:
	output reg [31:0] RD2_reg, //data:
	output reg [11:0] aluop_reg,
	output reg [31:0] aludata1_reg, //data:
	output reg [31:0] aludata2_reg, //data:
    output reg [2:0] sbhw_con_reg, //control:
    output reg [4:0] regnum_id_reg, //nc
    output reg [31:0] NNPC_id_reg, //nc
    output reg [31:0] PC_id_reg,
    //new
    output reg [3:0] addrexc_con_reg, //control:地址例外选择子
    output reg [1:0] lr_con_reg, //control:onehot模块选择子
    output reg [4:0] lubhw_con_id_reg,
    
    output wire allowin_id,//control:用来告诉if段是否可以流水
    output wire [4:0] RR1,RR2,
    output wire [2:0] idstop_idcon,//nc decoder
    output reg idstop_con_w_reg,//nc

	output wire [31:0] bjpc_out,
	output wire  brcal_out,

     //debug 信号， 供验证平台使用
    output [31:0] debug_wb_pc_wire,   //写回级（多周期最后一级） 的 PC， 因而需要 mycpu 里将 PC 一路带到写回级
    output [3:0] debug_wb_rf_wen_wire,   //写回级写寄存器堆(regfiles)的写使能，为字节写使能，如果 mycpu 写 regfiles为单字节写使能，则将写使能扩展成 4 位即可。
    output [4:0] debug_wb_rf_wnum_wire,   //写回级写 regfiles 的目的寄存器号
    output [31:0] debug_wb_rf_wdata_wire   //写回级写 regfiles 的写数据
	);

/*====================Variable Declaration====================*/

//reg Inputs--------------------------------------------------
// wire [4:0]  RR1;[port]   
// wire [4:0]  RR2;[port]   
wire [3:0] reg_we ;
wire [4:0]  WR;    
wire [31:0]  WD;
// reg Output
wire [31:0] RD1,RD2;
//------------------------------------------------------------

// signext Inputs---------------------------------------------       
// wire   [15:0]  imm [decoder]
wire   [2:0]  extend_con; //control:选择:imm的符号扩展-0/imm的0扩展-1/off的左移两位扩展-2

// signext Outputs
wire  [31:0]  extend_out;
//------------------------------------------------------------


// decoder Inputs----------------------------------------------      
// decoder Inputs      
// wire  [31:0]  Instruct;

// decoder Outputs
wire  [4:0]  rs;
wire  [4:0]  rt;
wire  [4:0]  rd;
wire  [15:0]  imm;
wire  [25:0]  instr_index; 
wire  [4:0]  sa;
wire  [2:0]  sel_wr_con;   
wire  [1:0]  sel_alud1_con;
wire  [1:0]  sel_alud2_con;
// wire  [2:0]  extend_con;[extend]   
wire  [2:0]  bjpc_con;     
wire  [6:0]  brcal_con;    
wire  [11:0]  aluop;       
wire  [2:0]  sbhw_con;     
wire  [1:0]  sel_dm_con;   
wire  [3:0]  sel_wb_con;   
wire  [3:0]  addrexc_con;
wire  [1:0]  lr_con;
wire  [4:0]  lubhw_con;
wire  [1:0]  bjaddrexc_con;
// wire idstop_con_w;[port]
//------------------------------------------------------------

// brcal Inputs ----------------------------------------------       
//wire  [31:0]  RD1; [reg]     
//wire  [31:0]  RD2; [reg]    
//wire  [5:0]  brcal_con; [decoder]

// brcal Outputs
// wire  brcal_out;
//------------------------------------------------------------

// bjpc Inputs-------------------------------------------------
// wire  [31:0]  NPC; [port]       
// wire  [31:0]  RD1; [reg]       
// wire  [31:0]  extend_out; [SE]
// wire  [25:0]  instr_index; [decoder]
// wire  [2:0]  bjpc_con; [decorder]   

// bjpc Outputs
// wire  [31:0]  bjpc_out; [port]
//------------------------------------------------------------

// others-----------------------------------------------------
wire [31:0] aludata1_wire,aludata2_wire;
//new
// wire [4:0] addrexc_con_wire; //control:地址例外选择子[decoder]
// wire [1:0]  lr_con_wire; //control:onehot模块选择子[decoder]
// wire [4:0] lubhw_con_id_wire;[decoder]
wire [4:0] regnum_id_wire;
//------------------------------------------------------------

/*====================Function Code====================*/
always @(posedge clk ) begin
    if (!(rst_n&&(!idstop_out))) begin
        if (idstop_out)begin
            sel_wbdata_id_reg <= `ini_sel_wbdata_id;
            sel_dm_id_reg <= `ini_sel_dm_id;
            RD2_reg <= `ini_RD2;
            aluop_reg <= `ini_aluop;
            aludata1_reg <= `ini_aludata1;
            aludata2_reg <= `ini_aludata2;
            sbhw_con_reg <= `ini_sbhw_con; 
            addrexc_con_reg <= `ini_addrexc_con ;
            lr_con_reg <= `ini_lr_con ;
            lubhw_con_id_reg <= `ini_lubhw_con_id ;
            regnum_id_reg <= `ini_regnum_id;
            NNPC_id_reg <= `ini_NNPC_id;
            idstop_con_w_reg <= `idstop_con_w_reg;
        end
        else begin
            sel_wbdata_id_reg <= `ini_sel_wbdata_id;
            sel_dm_id_reg <= `ini_sel_dm_id;
            RD2_reg <= `ini_RD2;
            aluop_reg <= `ini_aluop;
            aludata1_reg <= `ini_aludata1;
            aludata2_reg <= `ini_aludata2;
            sbhw_con_reg <= `ini_sbhw_con; 
            addrexc_con_reg <= `ini_addrexc_con ;
            lr_con_reg <= `ini_lr_con ;
            lubhw_con_id_reg <= `ini_lubhw_con_id ;
            regnum_id_reg <= `ini_regnum_id;
            NNPC_id_reg <= `ini_NNPC_id;
            PC_id_reg <= `ini_PC_id;
            idstop_con_w_reg <= `idstop_con_w_reg;
        end
    end else begin
        if (go_id) begin
            sel_wbdata_id_reg <= sel_wb_con;
            sel_dm_id_reg <= sel_dm_con;
			RD2_reg <= RD2;
			aluop_reg <= aluop;
			aludata1_reg <= aludata1_wire;
			aludata2_reg <= aludata2_wire;
            sbhw_con_reg <= sbhw_con;    
            addrexc_con_reg <= addrexc_con ;
            lr_con_reg <= lr_con ;
            lubhw_con_id_reg <= lubhw_con ;
            regnum_id_reg <= regnum_id_wire;
            NNPC_id_reg <= NNPC ;
            PC_id_reg <= PC_ifget ;
            idstop_con_w_reg <= idstop_con_w;
        end
    end
end
Reg  u_Reg (
    .clk                     ( clk      ),
    .rst_n                   ( rst_n    ),
    .reg_we                  ( reg_we   ),
    .RR1                     ( RR1      ),
    .RR2                     ( RR2      ),
    .WR                      ( WR       ),
    .WD                      ( WD       ),

    .RD1                     ( RD1      ),
    .RD2                     ( RD2      )
);
signext  u_signext (
    .imm 		             ( imm		    ),
    .extend_con              ( extend_con   ),

    .extend_out              ( extend_out   ) 
);

decoder  u_decoder (
    .Instruct                ( Instruct         ),

    .rs                      ( rs               ),
    .rt                      ( rt               ),
    .rd                      ( rd               ),
    .imm                     ( imm              ),
    .instr_index             ( instr_index      ),
    .sa                      ( sa               ),
    .sel_wr_con              ( sel_wr_con       ),
    .sel_alud1_con           ( sel_alud1_con    ),
    .sel_alud2_con           ( sel_alud2_con    ),
    .extend_con              ( extend_con       ),
    .bjpc_con                ( bjpc_con         ),
    .brcal_con               ( brcal_con        ),
    .aluop                   ( aluop            ),
    .sbhw_con                ( sbhw_con         ),
    .sel_dm_con              ( sel_dm_con       ),
    .sel_wb_con              ( sel_wb_con       ),
    .addrexc_con             ( addrexc_con      ),
    .lr_con                  ( lr_con           ),
    .lubhw_con               ( lubhw_con        ),
    //new
    .idstop_idcon            ( idstop_idcon     ),
    .idstop_con_w            ( idstop_con_w     )    
);

brcal  u_brcal (
    .RD1                     ( RD1         ),
    .RD2                     ( RD2         ),
    .brcal_con               ( brcal_con   ),

    .brcal_out               ( brcal_out   )
);

bjpc  u_bjpc (
    .NPC                     ( NPC           ),
    .RD1                     ( RD1           ),
    .extend_out              ( extend_out    ),
    .instr_index             ( instr_index   ),
    .bjpc_con                ( bjpc_con      ),

    .bjpc_out                ( bjpc_out      )
);
assign regnum_id_wire = sel_wr_con[0] ? rt:
			sel_wr_con[1] ? rd : 32'd31;
assign aludata1_wire = sel_alud1_con[0] ? RD1 : {27'b0,sa}; //不支持位移负值
assign aludata2_wire = sel_alud2_con[0] ? RD2 : extend_out;	
assign RR1 = rs;
assign RR2 = rt;		
assign WD = wbdata;
assign reg_we = reg_we_mem;
assign WR = regnum_mem ;
assign debug_wb_pc_wire = PC_memget;
assign debug_wb_rf_wen_wire = reg_we_mem;
assign debug_wb_rf_wnum_wire = regnum_mem;
assign debug_wb_rf_wdata_wire = wbdata;
assign allowin_id = go_id;
endmodule