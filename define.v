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
`define     AluOpBus        4:0 //运算子类�????
`define     AluSelBus       2:0//运算类型
`define     InstInvalid     1'b0
`define     InstValid       1'b1
`define     True_v          1'b1
`define     False_v         1'b0
`define     ChipEnable      1'b1
`define     ChipDisable     1'b0

/*defines about instruction*/
`define     EXE_ORI_OP1         5'b00100
`define     EXE_SLL_OP1         5'b01100
`define     EXE_LUI_OP1         5'b01101
`define     EXE_JAL_OP1         5'b11011
`define     EXE_JALR_OP1        5'b11001
`define     EXE_AUIPC_OP1       5'b00101
`define     EXE_BEQ_OP1         5'b11000
`define     EXE_LW_OP1          5'b00000
`define     EXE_SW_OP1          5'b01000
`define     EXE_ORI_OP2         3'b110
`define     EXE_XORI_OP2        3'b100
`define     EXE_ANDI_OP2        3'b111
`define     EXE_SLLI_OP2        3'b001
`define     EXE_SRLI_OP2        3'b101
`define     EXE_SLL_OP2         3'b001
`define     EXE_XOR_OP2         3'b100
`define     EXE_SRL_OP2         3'b101
`define     EXE_OR_OP2          3'b110
`define     EXE_AND_OP2         3'b111
`define     EXE_ADDI_OP2        3'b000
`define     EXE_SLTI_OP2        3'b010
`define     EXE_SLTIU_OP2       3'b011
`define     EXE_ADD_OP2         3'b000//also EXE_SUB
`define     EXE_SLT_OP2         3'b010
`define     EXE_SLTU_OP2        3'b011
`define     EXE_BEQ_OP2         3'b000
`define     EXE_BNE_OP2         3'b001
`define     EXE_BLT_OP2         3'b100
`define     EXE_BGE_OP2         3'b101
`define     EXE_BLTU_OP2        3'b110
`define     EXE_BGEU_OP2        3'b111
`define     EXE_LW_OP2          3'b010
`define     EXE_LH_OP2          3'b001
`define     EXE_LB_OP2          3'b000
`define     EXE_LBU_OP2         3'b100
`define     EXE_LHU_OP2         3'b101
`define     EXE_SW_OP2          3'b010
`define     EXE_SH_OP2          3'b001
`define     EXE_SB_OP2          3'b000


`define     EXE_OR_OP       5'b00001//or operand运算子类�????
`define     EXE_AND_OP      5'b00010
`define     EXE_XOR_OP      5'b00011
`define     EXE_SFTR_OP     5'b00100
`define     EXE_SFTL_OP     5'b00101
`define     EXE_SFTSY_OP    5'b00110
`define     EXE_ADD_OP      5'b00111
`define     EXE_LES_OP      5'b01000
`define     EXE_SUB_OP      5'b01001
`define     EXE_LESU_OP     5'b01010
`define     EXE_JAL_OP      5'b01011
`define     EXE_BEQ_OP      5'b01100
`define     EXE_BNE_OP      5'b01101
`define     EXE_BLT_OP      5'b01110
`define     EXE_BGE_OP      5'b01111
`define     EXE_BLTU_OP     5'b10000
`define     EXE_BGEU_OP     5'b10001
`define     EXE_JALR_OP     5'b10010
`define     EXE_LW_OP       5'b10011
`define     EXE_AUIPC_OP    5'b10100
`define     EXE_LH_OP       5'b10101
`define     EXE_LB_OP       5'b10110
`define     EXE_LBU_OP      5'b10111
`define     EXE_LHU_OP      5'b11000
`define     EXE_SW_OP       5'b11001
`define     EXE_SH_OP       5'b11010
`define     EXE_SB_OP       5'b11011
`define     EXE_NOP_OP      5'b00000
   
`define     EXE_RES_LOGIC   3'b001//logic 运算类型(and andi or ori xor xori) lui解码为ori imm x0
`define     EXE_RES_SHIFT   3'b010//shift 运算类型(sll slli srl srli sra srai)
`define     EXE_RES_MATH    3'b011//数学 运算类型(add addi stl stli sltu sltiu)
`define     EXE_RES_JUMP    3'b100//jump and branch 运算类型(jal jalr beq bne blt bge bltu bgeu)
`define     EXE_RES_LS      3'b101//load and store
`define     EXE_RES_NOP     3'b000

/*defines about mem_buffer state*/

`define     Inst_1          4'b0000
`define     Inst_2          4'b0001
`define     Inst_3          4'b0010
`define     Inst_4          4'b0011
`define     Inst_5          4'b0100
`define     Mem_1           4'b0101
`define     Mem_2           4'b0110
`define     Mem_3           4'b0111
`define     Mem_4           4'b1000
`define     Mem_5           4'b1001
`define     Write_1         4'b1010
`define     Write_2         4'b1011
`define     Write_3         4'b1100
`define     Write_4         4'b1101

/*与指令存储器ROM有关的宏定义*/
`define     RamAddrBus      16:0
`define     ZeroRamAddr     17'b00000000000000000
`define     InstBus         31:0
`define     InstAddrBus     31:0
`define     InstMemNum      131071
`define     InstMemNumLog2  17

/*与�?�用寄存器Regfile有关的宏定义*/
`define     RegAddrBus      4:0
`define     RegBus          31:0
`define     ByteBus         7:0
`define     RegWidth        32
`define     RegNum          32
`define     RegNumLog2      5
`define     NOPRegAddr      5'b00000

`endif