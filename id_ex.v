`include "define.v"
module id_ex(
    input wire clk,
    input wire rst,

    input wire[`AluOpBus] id_aluop,
    input wire[`AluSelBus] id_alusel,
    input wire[`RegBus] id_reg1,
    input wire[`RegBus] id_reg2,
    input wire[`RegAddrBus] id_wd,
    input wire  id_wreg,
    input wire[`InstAddrBus] id_link_pc,
    input wire[31:0] id_branch_offset,
    input wire IDEX_discard_i,

    output reg[`AluOpBus] ex_aluop,
    output reg[`AluSelBus] ex_alusel,
    output reg[`RegBus] ex_reg1,
    output reg[`RegBus] ex_reg2,
    output reg[`RegAddrBus] ex_wd,
    output reg ex_wreg
    output reg[`InstAddrBus] ex_link_pc;
    output reg[31:0] ex_branch_offset;
);

always @ (posedge clk)
begin
    if((rst == `RstEnable) || (IDEX_discard_i == 1'b1))
    begin
        ex_aluop <= `EXE_NOP_OP;
        ex_alusel <= `EXE_RES_NOP;
        ex_reg1 <= `ZeroWord;
        ex_reg2 <= `ZeroWord;
        ex_wd <= `NOPRegAddr;
        ex_wreg <= `WriteDisable;
        ex_link_pc <= `ZeroWord;
        ex_branch_offset <= `ZeroWord;
    end
    else
    begin
        ex_aluop <= id_aluop;
        ex_alusel <= id_alusel;
        ex_reg1 <= id_reg1;
        ex_reg2 <= id_reg2;
        ex_wd <= id_wd;
        ex_wreg <= id_wreg;
        ex_link_pc <= id_link_pc;
        ex_branch_offset <= id_branch_offset;
    end
end

endmodule