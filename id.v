`include "define.v"
module id(
    input wire              rst,
    input wire[`InstAddrBus]pc_i,
    input wire[`InstBus]    inst_i,

    input wire[`RegBus]     reg1_data_i,
    input wire[`RegBus]     reg2_data_i,
    
    //whether the instruction running in ex need write register
    input wire              ex_wreg_i,
    input wire[`RegBus]     ex_wdata_i,
    input wire[`RegAddrBus] ex_wd_i,
    //whether the instruction running in mem need write register
    input wire              mem_wreg_i,
    input wire[`RegBus]     mem_wdata_i,
    input wire[`RegAddrBus] mem_wd_i,

    output reg              reg1_read_o,
    output reg              reg2_read_o,
    output reg[`RegAddrBus] reg1_addr_o,
    output reg[`RegAddrBus] reg2_addr_o,

    output reg[`AluOpBus]   aluop_o,
    output reg[`AluSelBus]  alusel_o,
    output reg[`RegBus]     reg1_o,
    output reg[`RegBus]     reg2_o,
    output reg[`RegAddrBus] wd_o,
    output reg              wreg_o,

    output reg[`InstAddrBus]link_pc_o,
    output reg[31:0]        branch_offset_o
);

wire[4:0] op  = inst_i[6:2];
wire[2:0] op2 = inst_i[14:12];

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
    else 
    begin
        case (op)
        `EXE_ORI_OP1:
        begin
        wd_o        <= inst_i[11:7];
        reg1_addr_o <= inst_i[19:15];
        reg2_addr_o <= inst_i[24:20];
            case(op2)
            `EXE_ADDI_OP2:
            begin
                wreg_o <= `WriteEnable;
                alusel_o <= `EXE_RES_MATH;
                aluop_o <= `EXE_ADD_OP;
                reg1_read_o <= 1'b1;
                reg2_read_o <= 1'b0;
                imm <= {{20{inst_i[31]}},inst_i[31:20]};
                instvalid <= `InstValid;
                link_pc_o <= `ZeroWord;
                branch_offset_o <= `ZeroWord;
            end
            `EXE_SLTI_OP2:
            begin
                wreg_o <= `WriteEnable;
                alusel_o <= `EXE_RES_MATH;
                aluop_o <= `EXE_LES_OP;
                reg1_read_o <= 1'b1;
                reg2_read_o <= 1'b0;
                imm <= {{20{inst_i[31]}},inst_i[31:20]};
                instvalid <= `InstValid;
                link_pc_o <= `ZeroWord;
                branch_offset_o <= `ZeroWord;
            end
            `EXE_SLTIU_OP2:
            begin
                wreg_o <= `WriteEnable;
                alusel_o <= `EXE_RES_MATH;
                aluop_o <= `EXE_LESU_OP;
                reg1_read_o <= 1'b1;
                reg2_read_o <= 1'b0;
                imm <= {{20{inst_i[31]}},inst_i[31:20]};
                instvalid <= `InstValid;
                link_pc_o <= `ZeroWord;
                branch_offset_o <= `ZeroWord;
            end
            `EXE_XORI_OP2:
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
            `EXE_ORI_OP2:
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
            `EXE_ANDI_OP2:
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
            `EXE_SLLI_OP2:
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
            `EXE_SRLI_OP2:
            begin
                wreg_o  <= `WriteEnable;
                alusel_o <= `EXE_RES_SHIFT;
                reg1_read_o <= 1'b1;
                reg2_read_o <= 1'b0;
                imm     <= {27'h0, inst_i[24:20]};
                instvalid <= `InstValid;
                link_pc_o <= `ZeroWord;
                branch_offset_o <= `ZeroWord;
                if(inst_i[30] == 1'b0)
                begin
                    aluop_o <= `EXE_SFTR_OP;
                end
                else
                begin
                    aluop_o <= `EXE_SFTSY_OP;
                end
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
            endcase
        end
        `EXE_SLL_OP1:
        begin
        wd_o        <= inst_i[11:7];
        reg1_addr_o <= inst_i[19:15];
        reg2_addr_o <= inst_i[24:20];
            case(op2)
            `EXE_ADD_OP2:
            begin
                wreg_o <= `WriteEnable;
                alusel_o <= `EXE_RES_MATH;
                reg1_read_o <= 1'b1;
                reg2_read_o <= 1'b1;
                imm <= {{20{inst_i[31]}},inst_i[31:20]};
                instvalid <= `InstValid;
                link_pc_o <= `ZeroWord;
                branch_offset_o <= `ZeroWord;
                if(inst_i[30]==1'b0)
                begin
                    aluop_o <= `EXE_ADD_OP;
                end
                else
                begin
                    aluop_o <= `EXE_SUB_OP;
                end
            end
            `EXE_SLL_OP2:
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
            `EXE_SLT_OP2:
            begin
                wreg_o <= `WriteEnable;
                alusel_o <= `EXE_RES_MATH;
                aluop_o <= `EXE_LES_OP;
                reg1_read_o <= 1'b1;
                reg2_read_o <= 1'b0;
                imm <= {{20{inst_i[31]}},inst_i[31:20]};
                instvalid <= `InstValid;
                link_pc_o <= `ZeroWord;
                branch_offset_o <= `ZeroWord;
            end
            `EXE_SLTU_OP2:
            begin
                wreg_o <= `WriteEnable;
                alusel_o <= `EXE_RES_MATH;
                aluop_o <= `EXE_LESU_OP;
                reg1_read_o <= 1'b1;
                reg2_read_o <= 1'b0;
                imm <= {20'h00000,inst_i[31:20]};
                instvalid <= `InstValid;
                link_pc_o <= `ZeroWord;
                branch_offset_o <= `ZeroWord;
            end
            `EXE_XOR_OP2:
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
            `EXE_SRL_OP2:
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
                    instvalid <= `InstInvalid;
                end
            end
            `EXE_OR_OP2:
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
            `EXE_AND_OP2:
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
            endcase
        end
        `EXE_LUI_OP1:
        begin
            wd_o        <= inst_i[11:7];
            wreg_o <= `WriteEnable;
            aluop_o <= `EXE_OR_OP;
            alusel_o <= `EXE_RES_LOGIC;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b0;
            imm <= {inst_i[31:12],12'h000};
            instvalid <= `InstValid;
            reg1_addr_o <= `NOPRegAddr;
            branch_offset_o <= `ZeroWord;
        end
        `EXE_JAL_OP1:
        begin
            wreg_o <= `WriteEnable;
            wd_o <= inst_i[11:7];
            reg1_read_o <= 1'b0;
            reg2_read_o <= 1'b0;
            aluop_o <= `EXE_JAL_OP;
            alusel_o <= `EXE_RES_JUMP;
            imm <= {{12{inst_i[31]}},inst_i[31],inst_i[19:12],inst_i[20],inst_i[30:21]};
            instvalid <= `InstValid;
            link_pc_o <= pc_i + 4;
            branch_offset_o <= `ZeroWord;
        end
        `EXE_JALR_OP1:
        begin
            wd_o        <= inst_i[11:7];
            reg1_addr_o <= inst_i[19:15];
            reg2_addr_o <= inst_i[24:20];
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
        `EXE_AUIPC_OP1:
        begin
            wreg_o <= `WriteEnable;
            wd_o <= inst_i[11:7];
            reg1_read_o <= 1'b0;
            reg2_read_o <= 1'b0;
            aluop_o <= `EXE_AUIPC_OP;
            alusel_o <= `EXE_RES_MATH;
            imm <= {inst_i[31:12], 12'h000};
            instvalid <= `InstValid;
            link_pc_o <= pc_i + 4;
            branch_offset_o <= `ZeroWord;
        end
        `EXE_BEQ_OP1:
        begin
        wd_o        <= inst_i[11:7];
        reg1_addr_o <= inst_i[19:15];
        reg2_addr_o <= inst_i[24:20];        
            case(op2)
            `EXE_BEQ_OP2:
            begin
                wreg_o <= `WriteDisable;
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
            `EXE_BNE_OP2:
            begin
                wreg_o <= `WriteDisable;
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
            `EXE_BLT_OP2:
            begin
                wreg_o <= `WriteDisable;
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
            `EXE_BGE_OP2:
            begin
                wreg_o <= `WriteDisable;
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
            `EXE_BLTU_OP2:
            begin
                wreg_o <= `WriteDisable;
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
            `EXE_BGEU_OP2:
            begin
                wreg_o <= `WriteDisable;
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
            endcase
        end
        `EXE_LW_OP1:
        begin
            if(inst_i[1:0] == 2'b00)
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
            else
            begin
            wd_o        <= inst_i[11:7];
            reg1_addr_o <= inst_i[19:15];
            reg2_addr_o <= inst_i[24:20];
            case(op2)
            `EXE_LW_OP2:
            begin
                aluop_o <= `EXE_LW_OP;
                alusel_o <= `EXE_RES_LS;
                wreg_o <= `WriteEnable;
                reg1_read_o <= 1'b1;
                reg2_read_o <= 1'b0;
                imm <= {{20{inst_i[31]}},inst_i[31:20]};
                instvalid <= `InstValid;
                link_pc_o <= `ZeroWord;
                branch_offset_o <= `ZeroWord;
            end
            `EXE_LH_OP2:
            begin
                aluop_o <= `EXE_LH_OP;
                alusel_o <= `EXE_RES_LS;
                wreg_o <= `WriteEnable;
                reg1_read_o <= 1'b1;
                reg2_read_o <= 1'b0;
                imm <= {{20{inst_i[31]}},inst_i[31:20]};
                instvalid <= `InstValid;
                link_pc_o <= `ZeroWord;
                branch_offset_o <= `ZeroWord;
            end
            `EXE_LB_OP2:
            begin
                aluop_o <= `EXE_LB_OP;
                alusel_o <= `EXE_RES_LS;
                wreg_o <= `WriteEnable;
                reg1_read_o <= 1'b1;
                reg2_read_o <= 1'b0;
                imm <= {{20{inst_i[31]}},inst_i[31:20]};
                instvalid <= `InstValid;
                link_pc_o <= `ZeroWord;
                branch_offset_o <= `ZeroWord;
            end
            `EXE_LBU_OP2:
            begin
                aluop_o <= `EXE_LBU_OP;
                alusel_o <= `EXE_RES_LS;
                wreg_o <= `WriteEnable;
                reg1_read_o <= 1'b1;
                reg2_read_o <= 1'b0;
                imm <= {{20{inst_i[31]}},inst_i[31:20]};
                instvalid <= `InstValid;
                link_pc_o <= `ZeroWord;
                branch_offset_o <= `ZeroWord;
            end
            `EXE_LHU_OP2:
            begin
                aluop_o <= `EXE_LHU_OP;
                alusel_o <= `EXE_RES_LS;
                wreg_o <= `WriteEnable;
                reg1_read_o <= 1'b1;
                reg2_read_o <= 1'b0;
                imm <= {{20{inst_i[31]}},inst_i[31:20]};
                instvalid <= `InstValid;
                link_pc_o <= `ZeroWord;
                branch_offset_o <= `ZeroWord;
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
            endcase
            end
        end
        `EXE_SW_OP1:
        begin
        wd_o        <= inst_i[11:7];
        reg1_addr_o <= inst_i[19:15];
        reg2_addr_o <= inst_i[24:20];
            case(op2)
            `EXE_SW_OP2:
            begin
                aluop_o <= `EXE_SW_OP;
                alusel_o <= `EXE_RES_LS;
                wreg_o <= `WriteDisable;
                reg1_read_o <= 1'b1;
                reg2_read_o <= 1'b1;
                imm <= `ZeroWord;
                instvalid <= `InstValid;
                link_pc_o <= `ZeroWord;
                branch_offset_o <= {{20{inst_i[31]}},inst_i[31:25],inst_i[11:7]};
            end
            `EXE_SH_OP2:
            begin
                aluop_o <= `EXE_SH_OP;
                alusel_o <= `EXE_RES_LS;
                wreg_o <= `WriteDisable;
                reg1_read_o <= 1'b1;
                reg2_read_o <= 1'b1;
                imm <= `ZeroWord;
                instvalid <= `InstValid;
                link_pc_o <= `ZeroWord;
                branch_offset_o <= {{20{inst_i[31]}},inst_i[31:25],inst_i[11:7]};
            end
            `EXE_SB_OP2:
            begin
                aluop_o <= `EXE_SB_OP;
                alusel_o <= `EXE_RES_LS;
                wreg_o <= `WriteDisable;
                reg1_read_o <= 1'b1;
                reg2_read_o <= 1'b1;
                imm <= `ZeroWord;
                instvalid <= `InstValid;
                link_pc_o <= `ZeroWord;
                branch_offset_o <= {{20{inst_i[31]}},inst_i[31:25],inst_i[11:7]};
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
            endcase
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
        endcase
    end
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