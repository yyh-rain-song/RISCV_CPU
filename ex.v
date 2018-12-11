`include "define.v"
module ex(
    input wire rst,
    input wire[`AluOpBus] aluop_i,
    input wire[`AluSelBus] alusel_i,
    input wire[`RegBus] reg1_i,
    input wire[`RegBus] reg2_i,
    input wire[`RegAddrBus] wd_i,//要写的寄存器的地�????
    input wire wreg_i,//是否要写寄存�????
    input wire[`InstAddrBus] link_pc_i,
    input wire[31:0] branch_offset_i,

    output reg[`RegAddrBus] wd_o,
    output reg wreg_o,
    output reg[`RegBus] wdata_o,
    output reg pc_branch_o,
    output reg[`InstAddrBus] branch_addr_o,
    output reg IFID_discard_o,
    output reg IDEX_discard_o,
);
reg[`RegBus] logicout;
reg[`RegBus] shiftres;
reg[`RegBus] arithmatic;
reg[`RegBus] link_addr;


wire[`RegBus] reg2_i_mux;
wire reg1_les_reg2;
wire[`RegBus] result_sum;

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
                shiftres <= ({32{reg1_i[31]}}<<(6'd32-{1'b0,reg2_i[4:0]}))
                            | reg1_i >> reg2_i[4:0];
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

assign reg2_i_mux = ((aluop_i == `EXE_SUB_OP) || 
                     (aluop_i == `EXE_LES_OP))?
                    (~reg2_i)+1 : reg2_i;

assign result_sum = reg1_i + reg2_i_mux;

assign reg1_les_reg2 = ((aluop_i == `EXE_LES_OP) || 
                        (aluop_i == `EXE_BLT_OP) ||
                        (aluop_i == `EXE_BGE_OP))?
                       ((reg1_i[31] && !reg2_i[31]) ||
                        (!reg1_i[31] && !reg2_i[31] && result_sum[31]) ||
                        (reg1_i[31] && reg2_i[31] && result_sum[31]))
                      :(reg1_i < reg2_i);

always @ (*)
begin
    if(rst == `RstEnable)
    begin
        arithmatic <= `ZeroWord;
    end
    else
    begin
        case (aluop_i)
            `EXE_ADD_OP, `EXE_SUB_OP:
            begin
                arithmatic <= result_sum;
            end
            `EXE_LES_OP, `EXE_LESU_OP:
            begin
                arithmatic <= reg1_les_reg2;
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
            branch_addr_o <= (reg1_i + reg2_i)&{{31{1}},0};
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
            if(reg1_les_reg2)
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
            if(!reg1_les_reg2)
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
            if(reg1_les_reg2)
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
            if(!reg1_les_reg2)
            begin
                pc_branch_o <= 1'b1;
                IFID_discard_o <= 1'b1;
                IDEX_discard_o <= 1'b1;
                branch_addr_o <= (branch_offset_i << 1) + link_pc_i - 4;
            end
        end
        default:
        begin
            link_addr <= `ZeroWord;
        end
        endcase
    end
    else begin
        link_addr <= `ZeroWord;
    end
end//end always

always @ (*)
begin
    wd_o <= wd_i;
    wreg_o <= wreg_i;
    case (alusel_i)
        `EXE_RES_LOGIC:
        begin
            wdata_o <= logicout;
            pc_branch_o <= 1'b0;
            branch_addr_o <= `ZeroWord;
            IFID_discard_o <= 1'b0;
            IDEX_discard_o <= 1'b0;
        end
        `EXE_RES_SHIFT:
        begin
            wdata_o <= shiftres;
            pc_branch_o <= 1'b0;
            branch_addr_o <= `ZeroWord;
            IFID_discard_o <= 1'b0;
            IDEX_discard_o <= 1'b0;
        end
        `EXE_RES_MATH:
        begin
            wdata_o <= arithmatic;
            pc_branch_o <= 1'b0;
            branch_addr_o <= `ZeroWord;
            IFID_discard_o <= 1'b0;
            IDEX_discard_o <= 1'b0;
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