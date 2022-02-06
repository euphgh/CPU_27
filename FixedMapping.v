/*====================Ports Declaration====================*/
module FixedMapping (
    input wire [31:0] VAddr,
    output wire [31:0] PAddr
    );
/*====================Variable Declaration====================*/
wire [2:0] head;
/*====================Function Code====================*/
assign head = (VAddr[31]&&(!VAddr[30])) ? 3'b000 : VAddr[31:29]; 
assign PAddr = {head,VAddr[28:0]};
endmodule