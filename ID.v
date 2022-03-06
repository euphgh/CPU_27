/*====================Ports Declaration====================*/
`include "defines.vh"
module ID(
    //sys
	input  wire clk,rst_n,
    input  wire exe_allowin_in,
    output wire id_allowin_out,
    input  wire if_valid_in,
    output wire id_valid_out,
    //datain
 	input wire [31:0] if_PC_in,if_NPC_in,if_NNPC_in, //datar:
    input wire [31:0] if_Instruct_in, //dataw:
	input wire [31:0] wb_wdata_in, //dataw:
	input wire [3:0]  wb_wen_in, //dataw:
    input wire [4:0]  wb_wnum_in, //dataw:
    input wire [2:0] exe_write_type,mem_write_type,wb_write_type, //control{0:wb,1:mem,2:exe,000:nocheck}
    input wire [4:0] exe_wnum,mem_wnum,wb_wnum,
    //dataout
	output wire [4:0]  id_sel_wbdata_out, //control:
	output wire [1:0]  id_sel_dm_out, //control:
	output wire [31:0] id_RD2_out, //data:
	output wire [11:0] id_aluop_out,
	output wire [31:0] id_aludata1_out, //data:
	output wire [31:0] id_aludata2_out, //data:
    output wire [2:0]  id_sbhw_con_out, //control:
    output wire [4:0]  id_regnum_out,
    output wire [31:0] id_NNPC_out, 
    output wire [31:0] id_PC_out,
    output wire [3:0]  id_addrexc_con_out, //control:地址例外选择子
    output wire [1:0]  id_lr_con_out, //control:onehot模块选择子
    output wire [4:0]  id_lubhw_con_out,
    output wire id_brcal_res_out,
    output wire [31:0] id_bjpc_res_out,
    output wire [2:0] id_write_type_out,
    output wire [7:0] id_mult_div_op
	);


/*====================Variable Declaration====================*/

//reg Inputs--------------------------------------------------
wire [4:0]  RR1;
wire [4:0]  RR2;
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
wire  [31:0]  Instruct;

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
wire  [4:0]  sel_wb_con;   
wire  [3:0]  addrexc_con;
wire  [1:0]  lr_con;
wire  [4:0]  lubhw_con;
wire  [1:0]  bjaddrexc_con;
wire  [1:0]  read_type;
wire  [2:0]  write_type;
wire  [7:0]  mult_div_op;
wire  nop;
//------------------------------------------------------------

// brcal Inputs ----------------------------------------------       
//wire  [31:0]  RD1; [reg]     
//wire  [31:0]  RD2; [reg]    
//wire  [5:0]  brcal_con; [decoder]

// brcal Outputs
// wire  brcal_out;
//------------------------------------------------------------

// bjpc Inputs-------------------------------------------------
wire  [31:0]  NPC;       
// wire  [31:0]  RD1; [reg]       
// wire  [31:0]  extend_out; [SE]
// wire  [25:0]  instr_index; [decoder]
// wire  [2:0]  bjpc_con; [decorder]   

// bjpc Outputs
wire  [31:0]  bjpc_out;
//------------------------------------------------------------

// others-----------------------------------------------------
wire [31:0] aludata1_wire,aludata2_wire;
wire allowin;
wire ready;
reg valid_r;

wire [31:0] if_to_id_Instruct_w ;
wire [31:0] wb_to_id_wdata_r ;
wire [3:0] wb_to_id_wen_r ;
wire [4:0] wb_to_id_wnum_r ;
wire [31:0] wb_to_id_PC_r ;

reg  [31:0] if_to_id_PC_r ;
reg  [31:0] if_to_id_NPC_r ;
reg  [31:0] if_to_id_NNPC_r ;
// wire [4:0] addrexc_con_wire; //control:地址例外选择子[decoder]
// wire [1:0]  lr_con_wire; //control:onehot模块选择子[decoder]
// wire [4:0] lubhw_con_id_wire;[decoder]
wire [31:0] ID_PC;
assign ID_PC = id_PC_out;
wire [4:0] regnum_id_wire;
wire change_ok = allowin&&if_valid_in;
reg [31:0] if_to_id_Instruct_r;
//------------------------------------------------------------

/*====================Function Code====================*/
always @(posedge clk ) begin
    if (!rst_n)begin
       valid_r <= 1'b0; 
    end
    else if (allowin) begin
        valid_r <= if_valid_in ; 
    end
end
assign allowin = !valid_r || (ready && exe_allowin_in);
assign id_allowin_out = allowin;
assign id_valid_out = valid_r && ready;
always @(posedge clk ) begin
    if (!rst_n) begin
        if_to_id_Instruct_r <= 32'b0;
    end
    else begin
        if_to_id_Instruct_r <= if_Instruct_in;       
    end
end
assign if_to_id_Instruct_w = (change_ok) ? if_to_id_Instruct_w : if_to_id_Instruct_r ;

assign wb_to_id_wdata_r = wb_wdata_in ;
assign wb_to_id_wen_r = wb_wen_in ;
assign wb_to_id_wnum_r = wb_wnum_in ;

always @(posedge clk) begin
    if (!rst_n||(allowin&&(!if_valid_in))) begin
        if_to_id_PC_r <= `ini_if_PC_in;
        if_to_id_NPC_r <= `ini_if_NPC_in;
        if_to_id_NNPC_r <= `ini_if_NNPC_in;
    end
    else if (allowin && if_valid_in) begin
        if_to_id_PC_r <= if_PC_in;
        if_to_id_NPC_r <= if_NPC_in;
        if_to_id_NNPC_r <= if_NNPC_in;
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
assign id_RD2_out = RD2;
signext  u_signext (
    .imm 		             ( imm		    ),
    .extend_con              ( extend_con   ),

    .extend_out              ( extend_out   ) 
);
decoder  u_decoder (
    .Instruct                ( Instruct        ),

    .rs                      ( rs              ),
    .rt                      ( rt              ),
    .rd                      ( rd              ),
    .imm                     ( imm             ),
    .instr_index             ( instr_index     ),
    .sa                      ( sa              ),
    .sel_wr_con              ( sel_wr_con      ),
    .sel_alud1_con           ( sel_alud1_con   ),
    .sel_alud2_con           ( sel_alud2_con   ),
    .extend_con              ( extend_con      ),
    .bjpc_con                ( bjpc_con        ),
    .brcal_con               ( brcal_con       ),
    .aluop                   ( aluop           ),
    .sbhw_con                ( sbhw_con        ),
    .sel_dm_con              ( sel_dm_con      ),
    .sel_wb_con              ( sel_wb_con      ),
    .addrexc_con             ( addrexc_con     ),
    .lr_con                  ( lr_con          ),
    .lubhw_con               ( lubhw_con       ),
    .read_type               ( read_type       ),
    .write_type              ( write_type      ),
    .mult_div_op             ( mult_div_op     ),
    .nop                     ( nop             )
);
assign id_sbhw_con_out = sbhw_con;
assign id_lr_con_out = lr_con;
assign id_sel_dm_out = sel_dm_con & {2{valid_r}};
assign id_addrexc_con_out = addrexc_con & {4{valid_r}};
assign id_lubhw_con_out = lubhw_con;
assign id_sel_wbdata_out = sel_wb_con & {5{valid_r}};
assign Instruct = if_to_id_Instruct_r;
assign id_aluop_out = aluop;
assign id_mult_div_op = mult_div_op;
brcal  u_brcal (
    .RD1                     ( RD1         ),
    .RD2                     ( RD2         ),
    .brcal_con               ( brcal_con   ),

    .brcal_out               ( brcal_out   )
);
assign id_brcal_res_out = brcal_out && (!nop) && (valid_r);
bjpc  u_bjpc (
    .NPC                     ( NPC           ),
    .RD1                     ( RD1           ),
    .extend_out              ( extend_out    ),
    .instr_index             ( instr_index   ),
    .bjpc_con                ( bjpc_con      ),

    .bjpc_out                ( bjpc_out      )
);
assign id_bjpc_res_out = bjpc_out;
assign NPC = if_to_id_NPC_r;
assign regnum_id_wire = sel_wr_con[0] ? rt:
			sel_wr_con[1] ? rd : 32'd31;
assign id_regnum_out = (regnum_id_wire  & {5{(!nop)&&valid_r}}) ;
assign aludata1_wire = sel_alud1_con[0] ? RD1 : {27'b0,sa}; //不支持位移负值
assign id_aludata1_out = aludata1_wire;
assign aludata2_wire = sel_alud2_con[0] ? RD2 : extend_out;
assign id_aludata2_out = aludata2_wire;	
assign RR1 = rs;
assign RR2 = rt;		
assign WD = wb_to_id_wdata_r;
assign id_PC_out = if_to_id_PC_r;
assign id_NNPC_out = if_to_id_NNPC_r;
assign reg_we = wb_to_id_wen_r & {4{valid_r}};
assign WR = wb_to_id_wnum_r;
assign id_write_type_out = write_type & {3{(!nop)&&valid_r}};
idready  u_idready (
    .exe_write_type          ( exe_write_type   ),
    .mem_write_type          ( mem_write_type   ),
    .wb_write_type           ( wb_write_type    ),
    .exe_wnum                ( exe_wnum         ),
    .mem_wnum                ( mem_wnum         ),
    .wb_wnum                 ( wb_wnum          ),
    .read_type               ( read_type        ),
    .RR1                     ( RR1              ),
    .RR2                     ( RR2              ),

    .ready                   ( ready            )
);
endmodule