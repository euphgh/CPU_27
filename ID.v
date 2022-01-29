/*====================Ports Declaration====================*/
module ID(
	input wire clk,rst_n,
 	input wire [31:0] Instruct, //data
	input wire [31:0] PC,NPC, //address
	input wire [31:0] wbdata, //data
	input wire [3:0] reg_we, //control
	output reg [1:0] sel_pcback_exe, //control:在ID阶段PC选择器选择信号
	output reg [1:0] sel_wbdata, //control
	output reg [0:0] sel_dmin, //control
	output reg [0:0] sel_pcback_id, //control:在ID阶段PC选择器选择信号
	output reg [31:0] RD1, //data
	output reg [31:0] RD2, //data
	output reg aluop, //Warning:no bit in excel! control
	output reg [31:0] aludata1, //data
	output reg [31:0] aludata2, //data
	output reg [25:0] instr_index //data:指令后26位
	);

/*====================Variable Declaration====================*/
wire [1:0] sel_aludata1_con; //control
wire [0:0] sel_wr_con; //control
wire [0:0] sel_aludata2_con; //control
wire sbh_con; //Warning:no bit in excel! control
wire brcal_con; //Warning:no bit in excel! control
wire bjpc_con; //Warning:no bit in excel! control

//reg Inputs
wire [4:0]  RR1;   
wire [4:0]  RR2;   
wire [4:0]  WR;    
wire [31:0]  WD;


// signext Inputs       
wire   [15:0]  extend_in;
wire   [2:0]  extend_con; //control:选择:imm的符号扩展-0/imm的0扩展-1/off的左移两位扩展-2

// signext Outputs
wire  [31:0]  extend_out;
/*====================Function Code====================*/
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
    .extend_in               ( extend_in    ),
    .extend_con              ( extend_con   ),

    .extend_out              ( extend_out   ) 
);

endmodule