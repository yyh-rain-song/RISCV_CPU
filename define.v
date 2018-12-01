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

`define     EXE_OR_OP       8'b00000001//or operand运算子类型
`define     EXE_AND_OP      8'b00000010
`define     EXE_XOR_OP      8'b00000011
`define     EXE_SFTR_OP     8'b00000100
`define     EXE_SFTL_OP     8'b00000101
`define     EXE_SFTSY_OP    8'b00000110
`define     EXE_NOP_OP      8'b00000000

`define     EXE_RES_LOGIC   3'b001//logic 运算类型(and andi or ori xor xori) lui解码为ori imm x0
`define     EXE_RES_SHIFT   3'b010//shift 运算类型(sll slli srl srli sra srai)
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

`include "define.v"

module id(
    input wire              rst,
    input wire[`InstAddrBus]pc_i,
    input wire[`InstBus]    inst_i,//输入到id阶段的instruction

    input wire[`RegBus]     reg1_data_i,//regfile读端�???1的输出�??
    input wire[`RegBus]     reg2_data_i,//regfile读端�???2
    
    //whether the instruction running in ex need write register
    input wire              ex_wreg_i,
    input wire[`RegBus]     ex_wdata_i,
    input wire[`RegAddrBus] ex_wd_i,
    //whether the instruction running in mem need write register
    input wire              mem_wreg_i,
    input wire[`RegBus]     mem_wdata_i,
    input wire[`RegAddrBus] mem_wd_i,

    output reg              reg1_read_o,//是否�???要读regfile端口1
    output reg              reg2_read_o,//是否�???要读2
    output reg[`RegAddrBus] reg1_addr_o,//读rs1地址
    output reg[`RegAddrBus] reg2_addr_o,//读rs2地址

    output reg[`AluOpBus]   aluop_o,//运算子类�???
    output reg[`AluSelBus]  alusel_o,//运算类型
    output reg[`RegBus]     reg1_o,//源操作数1
    output reg[`RegBus]     reg2_o,//源操作数2
    output reg[`RegAddrBus] wd_o,//�???要写的寄存器地址
    output reg              wreg_o//这个指令是否�???要写寄存�???
);

wire[9:0] op  = {inst_i[6:0],inst_i[14:12]};//ori的opcode
wire[4:0] op2 = inst_i[10:6];
wire[5:0] op3 = inst_i[5:0];
wire[4:0] op4 = inst_i[20:16];//后面三个似乎ori用不�?

reg[`RegBus] imm;

reg instvalid;

//decode
always @ (*) begin
    aluop_o     <= `EXE_NOP_OP;
    alusel_o    <= `EXE_RES_NOP;
    wreg_o      <= `WriteDisable;
    reg1_read_o <= 1'b0;
    reg2_read_o <= 1'b0;
    imm         <= `ZeroWord;
    instvalid   <= `InstInvalid;

    if(rst == `RstEnable)
    begin 
        wd_o        <= `NOPRegAddr;       
        reg1_addr_o <= `NOPRegAddr;
        reg2_addr_o <= `NOPRegAddr;
    end
    else
    begin     
        wd_o        <= inst_i[11:7];
        reg1_addr_o <= inst_i[19:15];
        reg2_addr_o <= inst_i[24:20];

    case (op)    
        `EXE_XORI:
        begin
            wreg_o  <= `WriteEnable;
            aluop_o <= `EXE_XOR_OP;
            alusel_o <= `EXE_RES_LOGIC;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b0;
            imm     <= {20'h0, inst_i[31:20]};
            instvalid <= `InstValid;
        end
        `EXE_ORI:
        begin
            wreg_o  <= `WriteEnable;
            aluop_o <= `EXE_OR_OP;
            alusel_o <= `EXE_RES_LOGIC;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b0;
            imm     <= {20'h0, inst_i[31:20]};
            instvalid <= `InstValid;
        end
        `EXE_ANDI:
        begin
            wreg_o  <= `WriteEnable;
            aluop_o <= `EXE_AND_OP
            alusel_o <= `EXE_RES_LOGIC;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b0;
            imm     <= {20'h0, inst_i[31:20]};
            instvalid <= `InstValid;
        end
        `EXE_XOR:
        begin
            wreg_o <= `WriteEnable;
            aluop_o <= `EXE_XOR_OP;
            alusel_o <= `EXE_RES_LOGIC;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b1;
            imm <= `ZeroWord;
            instvalid <= `InstValid;
        end
        `EXE_OR:
        begin
            wreg_o <= `WriteEnable;
            aluop_o <= `EXE_OR_OP;
            alusel_o <= `EXE_RES_LOGIC;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b1;
            imm <= `ZeroWord;
            instvalid <= `InstValid;
        end
        `EXE_AND:
        begin
            wreg_o <= `WriteEnable;
            aluop_o <= `EXE_AND_OP;
            alusel_o <= `EXE_RES_LOGIC;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b1;
            imm <= `ZeroWord;
            instvalid <= `InstValid;
        end
        `EXE_SLLI:
        begin
            wreg_o  <= `WriteEnable;
            aluop_o <= `EXE_SFTL_OP;
            alusel_o <= `EXE_RES_SHIFT;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b0;
            imm     <= {27'h0, inst_i[24:20]};
            instvalid <= `InstValid;
        end
        `EXE_SRLI:
        begin
            wreg_o  <= `WriteEnable;
            alusel_o <= `EXE_RES_SHIFT;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b0;
            imm     <= {27'h0, inst_i[24:20]};
            instvalid <= `InstValid;
            if(inst_i[31:25] == 7'b0000000)
            begin
            aluop_o <= `EXE_SFTR_OP;
            end
            else if(inst_i[31:25] == 7'b0100000)
            begin
            aluop_o <= `EXE_SFTSY_OP;
            end
            else begin
                instvalid = `InstInvalid
            end
        end
        `EXE_SLL:
        begin
            wreg_o  <= `WriteEnable;
            aluop_o <= `EXE_SFTL_OP;
            alusel_o <= `EXE_RES_SHIFT;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b1;
            imm     <= `ZeroWord;
            instvalid <= `InstValid;
        end
        `EXE_SRL:
        begin
            wreg_o  <= `WriteEnable;
            alusel_o <= `EXE_RES_SHIFT;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b1;
            imm     <= `ZeroWord;
            instvalid <= `InstValid;
            if(inst_i[31:25] == 7'b0000000)
            begin
            aluop_o <= `EXE_SFTR_OP;
            end
            else if(inst_i[31:25] == 7'b0100000)
            begin
            aluop_o <= `EXE_SFTSY_OP;
            end
            else begin
                instvalid = `InstInvalid
            end
        end
        default:
        begin
        end
    endcase//end case op
    end//end else
end//end always

//decode operator1
always @ (*) 
begin
    if(rst == `RstEnable)
    begin
        reg1_o <= `ZeroWord;
    end
    else if((reg1_read_o == 1'b1)&&(ex_wreg_i == 1'b1)&&(ex_wd_i == reg1_addr_o))
    begin
        reg1_o <= ex_wdata_i;
    end
    else if((reg1_read_o == 1'b1)&&(mem_wreg_i == 1'b1)&&(mem_wd_i == reg1_addr_o))
    begin
        reg1_o <= mem_wdata_i;
    end
    else if(reg1_read_o == 1'b1)
    begin
        reg1_o <= reg1_data_i;//regfile read1 output
    end
    else if(reg1_read_o == 1'b0)
    begin
        reg1_o <= imm;//immediate number
    end
    else 
    begin
        reg1_o <= `ZeroWord;
    end
end//end always

//decode operator2
always @ (*) 
begin
    if(rst == `RstEnable)
    begin
        reg2_o <= `ZeroWord;
    end
    else if((reg2_read_o == 1'b1)&&(ex_wreg_i == 1'b1)&&(ex_wd_i == reg2_addr_o))
    begin
        reg2_o <= ex_wdata_i;
    end
    else if((reg2_read_o == 1'b1)&&(mem_wreg_i == 1'b1)&&(mem_wd_i == reg2_addr_o))
    begin
        reg2_o <= mem_wdata_i;
    end
    else if(reg2_read_o == 1'b1)
    begin
        reg2_o <= reg2_data_i;//regfile read2
    end
    else if(reg2_read_o == 1'b0)
    begin
        reg2_o <= imm;//immediate number
    end
    else 
    begin
        reg2_o <= `ZeroWord;
    end
end//end always

endmodule