`include "define.v"
module IF(
    input wire rst,
    input wire[`InstAddrBus] pc,
    input wire inst_enable_i,
    input wire[`InstBus] inst_i,

    output reg[`InstBus] inst_o,
    output reg[`InstAddrBus] pc_o,
    output reg halt_req
);

    always @ (*)
    begin
        if(rst == `RstEnable)
        begin
            inst_o <= `ZeroWord;
            pc_o <= `ZeroWord;
            halt_req <= 1'b0;
        end
        else if(inst_enable_i == 1'b0)
        begin
            inst_o <= `ZeroWord;
            halt_req <= 1'b1;
            //if inst disable, then halt (wait until fetch complete)
            //leave pc unchange
        end
        else
        begin
            inst_o <= inst_i;
            pc_o <= pc;
            halt_req <= 1'b0;
        end
    end

endmodule