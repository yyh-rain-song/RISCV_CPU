`include "define.v"
module ex(
    input wire rst,
    input wire[`AluOpBus] aluop_i,
    input wire[`AluSelBus] alusel_i,
    input wire[`RegBus] reg1_i,
    input wire[`RegBus] reg2_i,
    input wire[`RegAddrBus] wd_i,
    input wire wreg_i,
    input wire[`InstAddrBus] link_pc_i,
    input wire[31:0] branch_offset_i,

    output reg[`RegAddrBus] wd_o,
    output reg wreg_o,
    output reg[`RegBus] wdata_o,
    output reg pc_branch_o,
    output reg[`InstAddrBus] branch_addr_o,
    output reg IFID_discard_o,
    output reg IDEX_discard_o,
    
    output reg[`RamAddrBus] mem_addr,
    output reg[`RegBus] mem_write_data,
    output reg[`AluOpBus] aluop_o,
    output reg mem_rw//if need mem operation, mem_rw = 1, else = 0;
);
reg[`RegBus] logicout;
reg[`RegBus] shiftres;
reg[`RegBus] arithmatic;
reg[`RegBus] link_addr;

always @ (*)
begin
    if(rst == `RstEnable)
    begin
        logicout <= `ZeroWord;
    end
    else
    begin
        if(alusel_i == `EXE_RES_LOGIC)
        begin
            case (aluop_i)
            `EXE_OR_OP:
            begin
                logicout <= reg1_i|reg2_i;
            end
            `EXE_AND_OP:
            begin
                logicout <= reg1_i&reg2_i;
            end
            `EXE_XOR_OP:
                logicout <= reg1_i^reg2_i;
            default:
            begin
                logicout <= `ZeroWord;
            end
            endcase
        end
        else begin
            logicout <= `ZeroWord;
        end
    end
end//end always

always @ (*)
begin
    if(rst == `RstEnable)
    begin
        shiftres <= `ZeroWord;
    end
    else
    begin
        if(alusel_i == `EXE_RES_SHIFT)
        begin
            case (aluop_i)
            `EXE_SFTR_OP:
            begin
                shiftres <= reg1_i >> reg2_i[4:0];
            end
            `EXE_SFTL_OP:
            begin
                shiftres <= reg1_i << reg2_i[4:0];
            end
            `EXE_SFTSY_OP:
            begin
                shiftres <= ($signed(reg1_i)) >>> reg2_i[4:0];
            end
            default:
            begin
                shiftres <= `ZeroWord;
            end
            endcase
        end
        else begin
            shiftres <= `ZeroWord;
        end
    end//end else
end//end always

always @ (*)
begin
    if(rst == `RstEnable)
    begin
        arithmatic <= `ZeroWord;
    end
    else
    begin
        case (aluop_i)
            `EXE_ADD_OP:
            begin
                arithmatic <= reg1_i + reg2_i;
            end
            `EXE_SUB_OP:
            begin
                arithmatic <= reg1_i - reg2_i;
            end
            `EXE_LES_OP:
            begin
                arithmatic <= ($signed(reg1_i)) < ($signed(reg2_i));
            end
            `EXE_LESU_OP:
            begin
                arithmatic <= reg1_i < reg2_i;
            end
            `EXE_AUIPC_OP:
            begin
                arithmatic <= reg1_i + link_pc_i - 4;
            end
        default
        begin
            arithmatic <= `ZeroWord;
        end
        endcase
    end
end//end always

always @ (*)
begin
    if(alusel_i == `EXE_RES_JUMP)
    begin
        case(aluop_i)
        `EXE_JAL_OP:
        begin
            link_addr <= link_pc_i;
            pc_branch_o <= 1'b1;
            IFID_discard_o <= 1'b1;
            IDEX_discard_o <= 1'b1;
            branch_addr_o <= (link_pc_i - 4) + (reg1_i<<1);
        end
        `EXE_JALR_OP:
        begin
            link_addr <= link_pc_i;
            pc_branch_o <= 1'b1;
            IFID_discard_o <= 1'b1;
            IDEX_discard_o <= 1'b1;
            branch_addr_o <= (reg1_i + reg2_i)&(-2);
        end
        `EXE_BEQ_OP:
        begin
            link_addr <= `ZeroWord;
            if(reg1_i == reg2_i)
            begin
                pc_branch_o <= 1'b1;
                IFID_discard_o <= 1'b1;
                IDEX_discard_o <= 1'b1;
                branch_addr_o <= (branch_offset_i << 1) + link_pc_i - 4;
            end
        end
        `EXE_BNE_OP:
        begin
            link_addr <= `ZeroWord;
            if(reg1_i != reg2_i)
            begin
                pc_branch_o <= 1'b1;
                IFID_discard_o <= 1'b1;
                IDEX_discard_o <= 1'b1;
                branch_addr_o <= (branch_offset_i << 1) + link_pc_i - 4;
            end
        end
        `EXE_BLT_OP:
        begin
            link_addr <= `ZeroWord;
            if($signed(reg1_i) < $signed(reg2_i))
            begin
                pc_branch_o <= 1'b1;
                IFID_discard_o <= 1'b1;
                IDEX_discard_o <= 1'b1;
                branch_addr_o <= (branch_offset_i << 1) + link_pc_i - 4;
            end
        end
        `EXE_BGE_OP:
        begin
            link_addr <= `ZeroWord;
            if($signed(reg1_i) >= $signed(reg2_i))
            begin
                pc_branch_o <= 1'b1;
                IFID_discard_o <= 1'b1;
                IDEX_discard_o <= 1'b1;
                branch_addr_o <= (branch_offset_i << 1) + link_pc_i - 4;
            end
        end
        `EXE_BLTU_OP:
        begin
            link_addr <= `ZeroWord;
            if(reg1_i < reg2_i)
            begin
                pc_branch_o <= 1'b1;
                IFID_discard_o <= 1'b1;
                IDEX_discard_o <= 1'b1;
                branch_addr_o <= (branch_offset_i << 1) + link_pc_i - 4;
            end
        end
        `EXE_BGEU_OP:
        begin
            link_addr <= `ZeroWord;
            if(reg1_i >= reg2_i)
            begin
                pc_branch_o <= 1'b1;
                IFID_discard_o <= 1'b1;
                IDEX_discard_o <= 1'b1;
                branch_addr_o <= (branch_offset_i << 1) + link_pc_i - 4;
            end
        end
        default:
        begin
            pc_branch_o <= 1'b0;
            IFID_discard_o <= 1'b0;
            IDEX_discard_o <= 1'b0;
            link_addr <= `ZeroWord;
            branch_addr_o <= `ZeroWord;
        end
        endcase
    end
    else begin
        pc_branch_o <= 1'b0;
        IFID_discard_o <= 1'b0;
        IDEX_discard_o <= 1'b0;
        link_addr <= `ZeroWord;
        branch_addr_o <= `ZeroWord;
    end
end//end always

always @ (*)
begin
    if(alusel_i == `EXE_RES_LS)
    begin
        case(aluop_i)
        `EXE_LW_OP:
        begin
            mem_addr <= reg1_i + reg2_i;
            mem_write_data <= `ZeroWord;
            mem_rw <= 1'b1;
        end
        `EXE_LH_OP:
        begin
            mem_addr <= reg1_i + reg2_i;
            mem_write_data <= `ZeroWord;
            mem_rw <= 1'b1;
        end
        `EXE_LB_OP:
        begin
            mem_addr <= reg1_i + reg2_i;
            mem_write_data <= `ZeroWord;
            mem_rw <= 1'b1;
         end
        `EXE_LHU_OP:
        begin
             mem_addr <= reg1_i + reg2_i;
             mem_write_data <= `ZeroWord;
             mem_rw <= 1'b1;
         end
        `EXE_LBU_OP:
        begin
            mem_addr <= reg1_i + reg2_i;
            mem_write_data <= `ZeroWord;
            mem_rw <= 1'b1;
        end
        `EXE_SW_OP:
        begin
            mem_addr <= reg1_i + branch_offset_i;
            mem_write_data <= reg2_i;
            mem_rw <= 1'b1;
        end
        `EXE_SH_OP:
        begin
            mem_addr <= reg1_i + branch_offset_i;
            mem_write_data <= reg2_i;
            mem_rw <= 1'b1;
        end
        `EXE_SB_OP:
        begin
            mem_addr <= reg1_i + branch_offset_i;
            mem_write_data <= reg2_i;
            mem_rw <= 1'b1;
        end
        default:
        begin
            mem_addr <= `ZeroRamAddr;
            mem_write_data <= `ZeroWord;
            mem_rw <= 1'b0;
        end
        endcase
    end
    else
    begin
        mem_addr <= `ZeroRamAddr;
        mem_write_data <= `ZeroWord;
        mem_rw <= 1'b0;
    end
end


always @ (*)
begin
    wd_o <= wd_i;
    wreg_o <= wreg_i;
    aluop_o <= aluop_i;
    case (alusel_i)
        `EXE_RES_LOGIC:
        begin
            wdata_o <= logicout;
        end
        `EXE_RES_SHIFT:
        begin
            wdata_o <= shiftres;
        end
        `EXE_RES_MATH:
        begin
            wdata_o <= arithmatic;
        end
        `EXE_RES_JUMP:
        begin
            wdata_o <= link_addr;
        end
        default:
        begin
            wdata_o <= `ZeroWord;
        end
    endcase
end

endmodule