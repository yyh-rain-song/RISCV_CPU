`include "define.v"
module if_id(
    input wire                  clk,
    input wire                  rst,
    input wire[`InstAddrBus]    if_pc,
    input wire[`InstBus]        if_inst,
    input wire                  IFID_discard_i,
    input wire[1:0]             halt_type,

    output reg[`InstAddrBus]    id_pc,
    output reg[`InstBus]        id_inst
);
    always @ (posedge clk)
    begin
        if((rst == `RstEnable) || IFID_discard_i == 1'b1)
        begin
            id_pc <= `ZeroWord;
            id_inst <= `ZeroWord;
        end
        else if(halt_type == 2'b00)
        begin
            id_pc <= if_pc;
            id_inst <= if_inst;
        end
        else if(halt_type == 2'b01)
        begin
            id_pc <= `ZeroWord;
            id_inst <= `ZeroWord;
        end
    end
endmodule