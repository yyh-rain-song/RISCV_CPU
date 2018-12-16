/*
** 2018/11/26 by yyh
** define
*/

/*global define*/
`ifdef      DEFINE_HEAD
//do nothing
`else
`define      DEFINE_HEAD

`define     RstEnable       1'b1           
`define     RstDisable      1'b0
`define     ZeroWord        32'h00000000
`define     WriteEnable     1'b1
`define     WriteDisable    1'b0
`define     ReadEnable      1'b1
`define     ReadDisable     1'b0
`define     AluOpBus        7:0 //运算子类�?
`define     AluSelBus       2:0//运算类型
`define     InstInvalid     1'b0
`define     InstValid       1'b1
`define     True_v          1'b1
`define     False_v         1'b0
`define     ChipEnable      1'b1
`define     ChipDisable     1'b0

/*defines about instruction*/
`define     EXE_ORI         10'b0010011110
`define     EXE_XORI        10'b0010011100
`define     EXE_ANDI        10'b0010011111
`define     EXE_SLLI        10'b0010011001
`define     EXE_SRLI        10'b0010011101
`define     EXE_NOP         10'b0000000000
`define     EXE_SLL         10'b0110011001
`define     EXE_XOR         10'b0110011100
`define     EXE_SRL         10'b0110011101
`define     EXE_OR          10'b0110011110
`define     EXE_AND         10'b0110011111
`define     EXE_LUI         10'b0110111000
`define     EXE_ADDI        10'b0010011000
`define     EXE_SLTI        10'b0010011010
`define     EXE_SLTIU       10'b0010011011
`define     EXE_ADD         10'b0110011000//also EXE_SUB
`define     EXE_SLT         10'b0110011010
`define     EXE_SLTU        10'b0110011011
`define     EXE_JAL         10'b1101111000
`define     EXE_JALR        10'b1100111000
`define     EXE_BEQ         10'b1100011000
`define     EXE_BNE         10'b1100011001
`define     EXE_BLT         10'b1100011100
`define     EXE_BGE         10'b1100011101
`define     EXE_BLTU        10'b1100011110
`define     EXE_BGEU        10'b1100011111

`define     EXE_OR_OP       8'b00000001//or operand运算子类�?
`define     EXE_AND_OP      8'b00000010
`define     EXE_XOR_OP      8'b00000011
`define     EXE_SFTR_OP     8'b00000100
`define     EXE_SFTL_OP     8'b00000101
`define     EXE_SFTSY_OP    8'b00000110
`define     EXE_ADD_OP      8'b00000111
`define     EXE_LES_OP      8'b00001000
`define     EXE_SUB_OP      8'b00001001
`define     EXE_LESU_OP     8'b00001010
`define     EXE_JAL_OP      8'b00001011
`define     EXE_BEQ_OP      8'b00001100
`define     EXE_BNE_OP      8'b00001101
`define     EXE_BLT_OP      8'b00001110
`define     EXE_BGE_OP      8'b00001111
`define     EXE_BLTU_OP     8'b00010000
`define     EXE_BGEU_OP     8'b00010001
`define     EXE_JALR_OP     8'b00010010
`define     EXE_NOP_OP      8'b00000000

   

`define     EXE_RES_LOGIC   3'b001//logic 运算类型(and andi or ori xor xori) lui解码为ori imm x0
`define     EXE_RES_SHIFT   3'b010//shift 运算类型(sll slli srl srli sra srai)
`define     EXE_RES_MATH    3'b011//数学 运算类型(add addi stl stli sltu sltiu)
`define     EXE_RES_JUMP    3'b100//jump and branch 运算类型(jal jalr beq bne blt bge bltu bgeu)
`define     EXE_RES_NOP     3'b000

/*与指令存储器ROM有关的宏定义*/
`define     InstAddrBus     31:0
`define     InstBus         31:0
`define     InstMemNum      131071
`define     InstMemNumLog2  17

/*与�?�用寄存器Regfile有关的宏定义*/
`define     RegAddrBus      4:0
`define     RegBus          31:0
`define     ByteBus         7:0
`define     RegWidth        32
`define     DoubleRegWidth  64
`define     DoubleRegBus    63:0
`define     RegNum          32
`define     RegNumLog2      5
`define     NOPRegAddr      5'b00000

`endif