`include "define.v"
module if_id(
    input wire                  clk,
    input wire                  rst,
    input wire[`InstAddrBus]    if_pc,
    input wire[`InstBus]        if_inst,
    input wire                  IFID_discard_i,
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
        else begin
             id_pc <= if_pc;
             id_inst <= {if_inst[7:0],if_inst[15:8],if_inst[23:16],if_inst[31:24]};
             end
    end
endmodule