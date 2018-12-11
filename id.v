`include "define.v"

module id(
    input wire              rst,
    input wire[`InstAddrBus]pc_i,
    input wire[`InstBus]    inst_i,//输入到id阶段的instruction

    input wire[`RegBus]     reg1_data_i,//regfile读端�?????????1的输出�??
    input wire[`RegBus]     reg2_data_i,//regfile读端�?????????2
    
    //whether the instruction running in ex need write register
    input wire              ex_wreg_i,
    input wire[`RegBus]     ex_wdata_i,
    input wire[`RegAddrBus] ex_wd_i,
    //whether the instruction running in mem need write register
    input wire              mem_wreg_i,
    input wire[`RegBus]     mem_wdata_i,
    input wire[`RegAddrBus] mem_wd_i,

    output reg              reg1_read_o,//是否�?????????要读regfile端口1
    output reg              reg2_read_o,//是否�?????????要读2
    output reg[`RegAddrBus] reg1_addr_o,//读rs1地址
    output reg[`RegAddrBus] reg2_addr_o,//读rs2地址

    output reg[`AluOpBus]   aluop_o,//运算子类�?????????
    output reg[`AluSelBus]  alusel_o,//运算类型
    output reg[`RegBus]     reg1_o,//源操作数1
    output reg[`RegBus]     reg2_o,//源操作数2
    output reg[`RegAddrBus] wd_o,//�?????????要写的寄存器地址
    output reg              wreg_o,//这个指令是否�?????????要写寄存�?????????

    output reg[`InstAddrBus]link_pc_o,
    output reg[31:0]        branch_offset_o
);

wire[9:0] op  = {inst_i[6:0],inst_i[14:12]};//ori的opcode
wire[4:0] op2 = inst_i[10:6];
wire[5:0] op3 = inst_i[5:0];
wire[4:0] op4 = inst_i[20:16];//后面三个似乎ori用不�???????

reg[`RegBus] imm;

reg instvalid;//not used yet？？

//decode
always @ (*) begin
    if(rst == `RstEnable)
    begin 
        reg1_read_o <= 1'b0;
        reg2_read_o <= 1'b0;
        reg1_addr_o <= `NOPRegAddr;
        reg2_addr_o <= `NOPRegAddr;
        wreg_o <= 1'b0;
        wd_o <= `NOPRegAddr;
        aluop_o <= `EXE_NOP_OP;
        alusel_o <= `EXE_RES_NOP;
        link_pc_o <= `ZeroWord;
        branch_offset_o <= `ZeroWord;
    end
    else if({op[9:3],3'h000} == `EXE_LUI)
    begin
        wd_o        <= inst_i[11:7];
        wreg_o <= `WriteEnable;
        aluop_o <= `EXE_OR_OP;
        alusel_o <= `EXE_RES_LOGIC;
        reg1_read_o <= 1'b1;
        reg2_read_o <= 1'b0;
        imm <= {inst_i[31:12],12'h0};
        instvalid <= `InstValid;
        reg1_addr_o <= `NOPRegAddr;
        branch_offset_o <= `ZeroWord;
    end
    else if({op[9:3],3'h000} == `EXE_JAL)
    begin
        wreg_o <= `WriteEnable;
        wd_o <= inst_i[11:7];
        reg1_read_o <= 1'b0;
        reg2_read_o <= 1'b0;
        aluop_o <= `EXE_JAL_OP;
        alusel_o <= `EXE_RES_JUMP;
        imm <= {{10{inst_i[31]}},inst_i[31],inst_i[19:12],inst_i[20],inst_i[30:21]};
        instvalid <= `InstValid;
        link_pc_o <= pc_i + 4;
        branch_offset_o <= `ZeroWord;
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
            link_pc_o <= `ZeroWord;
            branch_offset_o <= `ZeroWord;
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
            link_pc_o <= `ZeroWord;
            branch_offset_o <= `ZeroWord;
        end
        `EXE_ANDI:
        begin
            wreg_o  <= `WriteEnable;
            aluop_o <= `EXE_AND_OP;
            alusel_o <= `EXE_RES_LOGIC;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b0;
            imm     <= {20'h0, inst_i[31:20]};
            instvalid <= `InstValid;
            link_pc_o <= `ZeroWord;
            branch_offset_o <= `ZeroWord;
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
            link_pc_o <= `ZeroWord;
            branch_offset_o <= `ZeroWord;
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
            link_pc_o <= `ZeroWord;
            branch_offset_o <= `ZeroWord;
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
            link_pc_o <= `ZeroWord;
            branch_offset_o <= `ZeroWord;
        end
        `EXE_SLLI:
        begin
            if(inst_i[31:25] != 7'b0000000)
            begin
                instvalid <= `InstInvalid;
            end
            else
            begin
            wreg_o  <= `WriteEnable;
            aluop_o <= `EXE_SFTL_OP;
            alusel_o <= `EXE_RES_SHIFT;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b0;
            imm     <= {27'h0, inst_i[24:20]};
            instvalid <= `InstValid;
            link_pc_o <= `ZeroWord;
            branch_offset_o <= `ZeroWord;
            end
        end
        `EXE_SRLI:
        begin
            wreg_o  <= `WriteEnable;
            alusel_o <= `EXE_RES_SHIFT;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b0;
            imm     <= {27'h0, inst_i[24:20]};
            instvalid <= `InstValid;
            link_pc_o <= `ZeroWord;
            branch_offset_o <= `ZeroWord;
            if(inst_i[31:25] == 7'b0000000)
            begin
            aluop_o <= `EXE_SFTR_OP;
            end
            else if(inst_i[31:25] == 7'b0100000)
            begin
            aluop_o <= `EXE_SFTSY_OP;
            end
            else begin
                instvalid = `InstInvalid;
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
            link_pc_o <= `ZeroWord;
            branch_offset_o <= `ZeroWord;
        end
        `EXE_SRL:
        begin
            wreg_o  <= `WriteEnable;
            alusel_o <= `EXE_RES_SHIFT;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b1;
            imm     <= `ZeroWord;
            instvalid <= `InstValid;
            link_pc_o <= `ZeroWord;
            branch_offset_o <= `ZeroWord;
            if(inst_i[31:25] == 7'b0000000)
            begin
            aluop_o <= `EXE_SFTR_OP;
            end
            else if(inst_i[31:25] == 7'b0100000)
            begin
            aluop_o <= `EXE_SFTSY_OP;
            end
            else begin
                instvalid = `InstInvalid;
            end
        end
        `EXE_ADDI:
        begin
            wreg_o <= `WriteEnable;
            alusel_o <= `EXE_RES_MATH;
            aluop_o <= `EXE_ADD_OP;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b0;
            imm <= {{12{inst_i[31]}},inst_i[31:20]};
            instvalid <= `InstValid;
            link_pc_o <= `ZeroWord;
            branch_offset_o <= `ZeroWord;
        end
        `EXE_SLTI:
        begin
            wreg_o <= `WriteEnable;
            alusel_o <= `EXE_RES_MATH;
            aluop_o <= `EXE_LES_OP;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b0;
            imm <= {{12{inst_i[31]}},inst_i[31:20]};
            instvalid <= `InstValid;
            link_pc_o <= `ZeroWord;
            branch_offset_o <= `ZeroWord;
        end
        `EXE_SLTIU:
        begin
            wreg_o <= `WriteEnable;
            alusel_o <= `EXE_RES_MATH;
            aluop_o <= `EXE_LESU_OP;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b0;
            imm <= {{12{inst_i[31]}},inst_i[31:20]};
            instvalid <= `InstValid;
            link_pc_o <= `ZeroWord;
            branch_offset_o <= `ZeroWord;
        end
        `EXE_ADD:
        begin
            wreg_o <= `WriteEnable;
            alusel_o <= `EXE_RES_MATH;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b1;
            imm <= {{12{inst_i[31]}},inst_i[31:20]};
            instvalid <= `InstValid;
            link_pc_o <= `ZeroWord;
            branch_offset_o <= `ZeroWord;
            if(inst_i[31:25]==7'b0000000)
            begin
                aluop_o <= `EXE_ADD_OP;
            end
            else if(inst_i[31:25]==7'b0100000)
            begin
                aluop_o <= `EXE_SUB_OP;
            end
            else
            begin
                instvalid <= `InstInvalid;
            end
        end
        `EXE_SLT:
        begin
            wreg_o <= `WriteEnable;
            alusel_o <= `EXE_RES_MATH;
            aluop_o <= `EXE_LES_OP;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b0;
            imm <= {{12{inst_i[31]}},inst_i[31:20]};
            instvalid <= `InstValid;
            link_pc_o <= `ZeroWord;
            branch_offset_o <= `ZeroWord;
        end
        `EXE_SLTU:
        begin
            wreg_o <= `WriteEnable;
            alusel_o <= `EXE_RES_MATH;
            aluop_o <= `EXE_LESU_OP;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b0;
            imm <= {{12{0}},inst_i[31:20]};
            instvalid <= `InstValid;
            link_pc_o <= `ZeroWord;
            branch_offset_o <= `ZeroWord;
        end
        `EXE_JALR:
        begin
            wreg_o <= `WriteEnable;
            alusel_o <= `EXE_RES_JUMP;
            aluop_o <= `EXE_JALR_OP;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b0;
            imm <= {{20{inst_i[31]}},inst_i[31:20]};
            instvalid <= `InstValid;
            link_pc_o <= pc_i + 4;
            branch_offset_o <= `ZeroWord;
        end
        `EXE_BEQ:
        begin
            wreg_o <= `WriteEnable;
            alusel_o <= `EXE_RES_JUMP;
            aluop_o <= `EXE_BEQ_OP;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b1;
            branch_offset_o <= {{20{inst_i[31]}},
            inst_i[31],inst_i[7],inst_i[30:25],inst_i[11:8]};
            imm <= `ZeroWord;
            instvalid <= `InstValid;
            link_pc_o <= pc_i + 4;
        end
        `EXE_BNE:
        begin
            wreg_o <= `WriteEnable;
            alusel_o <= `EXE_RES_JUMP;
            aluop_o <= `EXE_BNE_OP;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b1;
            branch_offset_o <= {{20{inst_i[31]}},
            inst_i[31],inst_i[7],inst_i[30:25],inst_i[11:8]};
            imm <= `ZeroWord;
            instvalid <= `InstValid;
            link_pc_o <= pc_i + 4;
        end
        `EXE_BLT:
        begin
            wreg_o <= `WriteEnable;
            alusel_o <= `EXE_RES_JUMP;
            aluop_o <= `EXE_BLT_OP;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b1;
            branch_offset_o <= {{20{inst_i[31]}},
            inst_i[31],inst_i[7],inst_i[30:25],inst_i[11:8]};
            imm <= `ZeroWord;
            instvalid <= `InstValid;
            link_pc_o <= pc_i + 4;
        end
        `EXE_BGE:
        begin
            wreg_o <= `WriteEnable;
            alusel_o <= `EXE_RES_JUMP;
            aluop_o <= `EXE_BGE_OP;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b1;
            branch_offset_o <= {{20{inst_i[31]}},
            inst_i[31],inst_i[7],inst_i[30:25],inst_i[11:8]};
            imm <= `ZeroWord;
            instvalid <= `InstValid;
            link_pc_o <= pc_i + 4;
        end
        `EXE_BLTU:
        begin
            wreg_o <= `WriteEnable;
            alusel_o <= `EXE_RES_JUMP;
            aluop_o <= `EXE_BLTU_OP;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b1;
            branch_offset_o <= {{20{inst_i[31]}},
            inst_i[31],inst_i[7],inst_i[30:25],inst_i[11:8]};
            imm <= `ZeroWord;
            instvalid <= `InstValid;
            link_pc_o <= pc_i + 4;
        end
        `EXE_BGEU:
        begin
            wreg_o <= `WriteEnable;
            alusel_o <= `EXE_RES_JUMP;
            aluop_o <= `EXE_BGEU_OP;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b1;
            branch_offset_o <= {{20{inst_i[31]}},
            inst_i[31],inst_i[7],inst_i[30:25],inst_i[11:8]};
            imm <= `ZeroWord;
            instvalid <= `InstValid;
            link_pc_o <= pc_i + 4;
        end
        default:
        begin
            aluop_o     <= `EXE_NOP_OP;
            alusel_o    <= `EXE_RES_NOP;
            wreg_o      <= `WriteDisable;
            reg1_read_o <= 1'b0;
            reg2_read_o <= 1'b0;
            imm         <= `ZeroWord;
            instvalid   <= `InstInvalid;
            link_pc_o <= `ZeroWord;
            branch_offset_o <= `ZeroWord;
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