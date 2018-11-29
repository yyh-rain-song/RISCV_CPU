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
`define     AluOpBus        7:0 //运算子类型
`define     AluSelBus       2:0//运算类型
`define     InstInvalid     1'b0
`define     InstValid       1'b1
`define     True_v          1'b1
`define     False_v         1'b0
`define     ChipEnable      1'b1
`define     ChipDisable     1'b0

/*defines about instruction*/
`define     EXE_ORI         10'b0010011110
`define     EXE_NOP         10'b0000000000

`define     EXE_OR_OP       8'b00100101//or operand运算子类型
`define     EXE_NOP_OP      8'b00000000

`define     EXE_RES_LOGIC   3'b001//logic 运算类型
`define     EXE_RES_NOP     3'b000

/*与指令存储器ROM有关的宏定义*/
`define     InstAddrBus     31:0
`define     InstBus         31:0
`define     InstMemNum      131071
`define     InstMemNumLog2  17

/*与�?�用寄存器Regfile有关的宏定义*/
`define     RegAddrBus      4:0
`define     RegBus          31:0
`define     RegWidth        32
`define     DoubleRegWidth  64
`define     DoubleRegBus    63:0
`define     RegNum          32
`define     RegNumLog2      5
`define     NOPRegAddr      5'b00000

`endif
