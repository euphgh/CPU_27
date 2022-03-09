`include "defines.vh"
/*====================Ports Declaration====================*/
module CP0 (
    input wire clk, rst_n,
    input wire mem_to_wb_exception_r,
    input wire mem_to_wb_bd_r,
    input wire [4:0] mem_to_wb_ExcCode_r,
    input wire [5:0] mem_to_wb_cp0_addr_r,
    input wire [31:0] mem_to_wb_mtc0_data_r,mem_to_wb_PC_r,mem_to_wb_error_VAddr_r,
    input wire mem_to_wb_eret_r,
    input wire mem_to_wb_mtc0_op_r,
    input wire valid_r,

    output wire [31:0] cp0_res,//若csj信号为1，则res中为跳转的pc，否则为mfc0de值
    output wire ClrStpJmp//指示发生中断、例外和eret时都要进行的stopwrite，clearpileline、jump的行为
    );
/*====================Variable Declaration====================*/
wire [5:0] cp0_addr;
wire [31:0] error_VAddr,mtc0_data;
wire exception;
wire ExcCode,eret_op;
// cp0_EPC Inputs---------------------------------
// wire  clk;[port]
// wire  rst_n;[port]
// wire  mtc0_we;[port]
// wire  exception;[port]
wire  EXL;
wire  BD;
// wire  [31:0]  mem_to_wb_PC_r;[port]
// wire  [5:0]  cp0_addr;       [port]
// wire  [31:0]  mct0_data;     [port]

// cp0_EPC Outputs
wire  [31:0]  cp0_EPC_data;
//-------------------------------------------------

// cp0_Cause Inputs  ------------------------------
// wire  clk;[port]
// wire  rst_n;[port]
// wire  mtc0_we;[port]
// wire  exception; [port]
// wire  eret_op;[port]
// wire  bd;[port]
wire  equal;
wire  [4:0]  int_in;
// wire  [4:0]  ExcCode;[port]   
// wire  [5:0]  cp0_addr;[port]  
// wire  [31:0]  mct0_data;[port]

// cp0_Cause Outputs
wire  [31:0]  cp0_Cause_data;
//-------------------------------------------------

// cp0_Status Inputs ------------------------------
// wire  clk;[port]
// wire  rst_n;[port]
// wire  mtc0_we;[port]
// wire  exception;[port]        
// wire  eret_op;[port]       
// wire  [5:0]  cp0_addr;[port]  
// wire  [31:0]  mct0_data;[port]
// cp0_Status Outputs
wire  [31:0]  cp0_Status_data;
//-------------------------------------------------

// cp0_Compare Inputs -----------------------------
// wire  clk;[port]
// wire  rst_n;[port]
// wire  exception;[port]
// wire  mtc0_we;[port]
// wire  [31:0]  mtc0_data;[port]
// wire  [5:0]  cp0_addr;  [port]

// cp0_Compare Outputs
wire  [31:0]  cp0_Compare_data;
//-------------------------------------------------
// cp0_Count Inputs -------------------------------
// wire  clk;[port]
// wire  rst_n;[port]
// wire  exception;        [port]
// wire  mtc0_we;[port]
// wire  [31:0]  mtc0_data;[port]
// wire  [5:0]  cp0_addr;  [port]

// cp0_Count Outputs
wire  [31:0]  cp0_Count_data;
//-------------------------------------------------
// cp0_BadVAddr Inputs ----------------------------
// wire  clk;[port]
// wire  rst_n;[port]
// wire  exception;[port]
// wire  [31:0]  error_VAddr;[port]
// wire  [4:0]  ExcCode;     [port]

// cp0_BadVAddr Outputs
wire  [31:0]  cp0_BadVAddr_data;
//-------------------------------------------------
wire mtc0_we;
assign mtc0_we = (!exception) && valid_r && mem_to_wb_mtc0_op_r;
/*====================Function Code====================*/
cp0_Status  u_cp0_Status (
    .clk                     ( clk               ),
    .rst_n                   ( rst_n             ),
    .mtc0_we                 ( mtc0_we           ),
    .exception               ( exception         ),
    .eret_op                 ( eret_op           ),
    .cp0_addr                ( cp0_addr          ),
    .mct0_data               ( mct0_data         ),

    .cp0_Status_data         ( cp0_Status_data   )
);
cp0_Cause  u_cp0_Cause (
    .clk                     ( clk              ),
    .rst_n                   ( rst_n            ),
    .mtc0_we                 ( mtc0_we          ),
    .exception               ( exception        ),
    .eret_op                 ( eret_op          ),
    .bd                      ( bd               ),
    .equal                   ( equal            ),
    .int_in                  ( int_in           ),
    .ExcCode                 ( ExcCode          ),
    .cp0_addr                ( cp0_addr         ),
    .mct0_data               ( mct0_data        ),

    .cp0_Cause_data          ( cp0_Cause_data   )
);
assign bd = mem_to_wb_bd_r;
cp0_EPC  u_cp0_EPC (
    .clk                     ( clk              ),
    .rst_n                   ( rst_n            ),
    .mtc0_we                 ( mtc0_we          ),
    .exception               ( exception        ),
    .EXL                     ( EXL              ),
    .BD                      ( BD               ),
    .mem_to_wb_PC_r          ( mem_to_wb_PC_r   ),
    .cp0_addr                ( cp0_addr         ),
    .mct0_data               ( mct0_data        ),

    .cp0_EPC_data            ( cp0_EPC_data     )
);
assign BD = cp0_Cause_data[`BD];
assign EXL = cp0_Status_data[`EXL];
cp0_Compare  u_cp0_Compare (
    .clk                     ( clk                ),
    .rst_n                   ( rst_n              ),
    .exception               ( exception          ),
    .mtc0_we                 ( mtc0_we            ),
    .mtc0_data               ( mtc0_data          ),
    .cp0_addr                ( cp0_addr           ),

    .cp0_Compare_data        ( cp0_Compare_data   )
);
cp0_Count  u_cp0_Count (
    .clk                     ( clk              ),
    .rst_n                   ( rst_n            ),
    .exception               ( exception        ),
    .mtc0_we                 ( mtc0_we          ),
    .mtc0_data               ( mtc0_data        ),
    .cp0_addr                ( cp0_addr         ),

    .cp0_Count_data          ( cp0_Count_data   )
);
cp0_BadVAddr  u_cp0_BadVAddr (
    .clk                     ( clk                 ),
    .rst_n                   ( rst_n               ),
    .exception               ( exception           ),
    .error_VAddr             ( error_VAddr         ),
    .ExcCode                 ( ExcCode             ),

    .cp0_BadVAddr_data       ( cp0_BadVAddr_data   )
);
wire [31:0] exc_jump_inst;
wire [31:0] mft0;
assign cp0_addr = mem_to_wb_cp0_addr_r;
assign error_VAddr = mem_to_wb_error_VAddr_r;
assign mtc0_data = mem_to_wb_mtc0_data_r;
assign ClrStpJmp = exception||eret_op;
assign exception = mem_to_wb_exception_r || int_in;
assign exc_jump_inst = eret_op ? cp0_EPC_data : 32'hbfc00380;
assign int_in = (cp0_Cause_data[`IP]&cp0_Status_data[`IM]!=8'h00)&&cp0_Status_data[`IE]&&(!cp0_Status_data[`EXL]);
assign ExcCode = {5{!int_in}} && mem_to_wb_ExcCode_r;
assign eret_op = mem_to_wb_eret_r;
assign mft0 =   ({32{cp0_addr==`cp0addr_Status}} & cp0_Status_data )|
                ({32{cp0_addr==`cp0addr_Cause}} & cp0_Cause_data )|
                ({32{cp0_addr==`cp0addr_EPC}} & cp0_EPC_data )|
                ({32{cp0_addr==`cp0addr_Compare}} & cp0_Compare_data )|
                ({32{cp0_addr==`cp0addr_Count}} & cp0_Count_data )|
                ({32{cp0_addr==`cp0addr_BadVAddr}} & cp0_BadVAddr_data) ;
assign cp0_res = ClrStpJmp ? exc_jump_inst : mft0;
endmodule