/*
** 2018/11/26 by yyh
** define
*/

/*全局宏定义*/
'define     RstEnable       1'b1           
'define     RstDisable      1'b0
'define     ZeroWord        32'h00000000
'define     WriteEnable     1'b1
'define     WriteDisable    1'b0
'define     ReadEnable      1'b1
'define     ReadDisable     1'b0
'define     AluOpBus        7:0 //划定运算子类型分类的宽度
'define     AluSelBus       2:0//划定运算类型分类的宽度
'define     InstInvalid     1'b0
'define     InstValid       1'b1
'define     True_v          1'b1
'define     False_v         1'b0
'define     ChipEnable      1'b1
'define     ChipDisable     1'b0

/*与指令相关的宏定义*/
'define     EXE_ORI         6'b001101
'define     EXE_NOP         6'B000000

'define     EXE_OR_OP       8'b00100101
'define     EXE_NOP_OP      8'b00000000

'define     EXE_RES_LOGIC   3'b001
'define     EXE_RES_NOP     3'b000

/*与指令存储器ROM有关的宏定义*/
'define     InstAddrBus     31:0
'define     InstBus         31:0
'define     InstMemNum      131071
'define     InstMemNumLog2  17

/*与通用寄存器Regfile有关的宏定义*/
'define     RegAddrBus      4:0
'define     RegBus          31:0
'define     RegWidth        32
'define     DoubleRegWidth  64
'define     DoubleRegBus    63:0
'define     RegNum          32
'define     RegNumLog2      5//register 索引的宽度 2^5=32
'define     NOPRegAddr      5'b00000
