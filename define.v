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

module RISCV(
    input wire clk,
    input wire rst,
    input wire['RegBus] rom_data_i,//从rom中取出的数据
    output wire['RegBus] rom_addr_o,//读rom的地址
    output wire rom_ce_o//cpu是否可用
);

wire['InstAddrBus] pc;
wire['InstAddrBus] id_pc_i;
wire['InstBus] id_inst_i;

wire['AluOpBus] id_aluop_o;
wire['AluSelBus] id_alusel_o;
wire['RegBus] id_reg1_o;
wire['RegBus] id_reg2_o;
wire id_wreg_o;
wire['RegAddrBus] id_wd_o;

wire['AluOpBus] ex_aluop_i;
wire['AluSelBus] ex_alusel_i;
wire['RegBus] ex_reg1_i;
wire['RegBus] ex_reg2_i;
wire ex_wreg_i;
wire['RegAddrBus] ex_wd_i;

wire ex_wreg_o;
wire['RegAddrBus] ex_wd_o;
wire['RegBus] ex_wdata_o;

wire mem_wreg_i;
wire['RegAddrBus] mem_wd_i;
wire['RegBus] mem_wdata_i;

wire mem_wreg_o;
wire['RegAddrBus] mem_wd_o;
wire['RegBus] mem_wdata_o;

wire wb_wreg_i;
wire['RegAddrBus] wb_wd_i;
wire['RegBus] wb_wdata_i;

wire reg1_read;
wire reg2_read;
wire['RegBus] reg1_data;
wire['RegBus] reg2_data;
wire['RegAddrBus] reg1_addr;
wire['RegAddrBus] reg2_addr;

\\pc_reg实例化
pc_reg pc_reg0(
        .clk(clk),  .rst(rst),  .pc(pc) .ce(rom_ce_o)    
);

assign rom_addr_o = pc;

if_id if_id0(
    .clk(clk),  .rst(rst),  .if_pc(pc),
    .if_inst(rom_data_i),  .id_pc(id_pc_i),
    .id_inst(id_inst_i)
);

id id0(
    .rst(rst),  .pc_i(id_pc_i), .inst_i(id_inst_i),
    //来自regfile的输入
    .reg1_data_i(reg1_data),  .reg2_data_i(reg2_data),

    //送到regfile的信息
    .reg1_read_o(reg1_read),  .reg2_read_o(reg2_read),
    .reg1_addr_o(reg1_addr),  .reg2_addr_o(reg2_addr),

    //送到id_ex的信息
    .aluop_o(id_aluop_o),  .alusel_o(id_alusel_o),
    .reg1_o(id_reg1_o),  .reg2_o(id_reg2_o),
    .wd_o(id_wd_o),  .wreg_o(id_wreg_o)
);

regfile regfile1(
    .clk(clk),  .rst(rst),
    .we(wb_wreg_i),  .waddr(wb_wd_i),  .wdata(wb_wdata_i),  
    .re1(reg1_read),  .raddr1(reg1_addr),  .rdata1(reg1_data),
    .re2(reg2_read),  .raddr2(reg2_addr),  .rdata2(reg2_data),
);

