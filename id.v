`include "define.v"
module id(
    input wire              rst,
    input wire[`InstAddrBus]pc_i,
    input wire[`InstBus]    inst_i,//输入到id阶段的instruction

    input wire[`RegBus]     reg1_data_i,//regfile读端�??1的输出�??
    input wire[`RegBus]     reg2_data_i,//regfile读端�??2

    output reg              reg1_read_o,//是否�??要读regfile端口1
    output reg              reg2_read_o,//是否�??要读2
    output reg[`RegAddrBus] reg1_addr_o,//读rs1地址
    output reg[`RegAddrBus] reg2_addr_o,//读rs2地址

    output reg[`AluOpBus]   aluop_o,//运算子类�??
    output reg[`AluSelBus]  alusel_o,//运算类型
    output reg[`RegBus]     reg1_o,//源操作数1
    output reg[`RegBus]     reg2_o,//源操作数2
    output reg[`RegAddrBus] wd_o,//�??要写的寄存器地址
    output reg              wreg_o//这个指令是否�??要写寄存�??
);

wire[5:0] op  = inst_i[31:26];//ori的opcode
wire[4:0] op2 = inst_i[10:6];
wire[5:0] op3 = inst_i[5:0];
wire[4:0] op4 = inst_i[20:16];//对应rt的序�??

reg[`RegBus] imm;

reg instvalid;

//译码
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
        wd_o        <= inst_i[15:11];
        reg1_addr_o <= inst_i[25:21];
        reg2_addr_o <= inst_i[20:16];

    case (op)
        `EXE_ORI:
        begin
            wreg_o  <= `WriteEnable;
            aluop_o <= `EXE_OR_OP;
            alusel_o <= `EXE_RES_LOGIC;
            reg1_read_o <= 1'b1;
            reg2_read_o <= 1'b0;
            imm     <= {16'h0, inst_i[15:0]};
            wd_o    <= inst_i[20:16];
            instvalid <= `InstValid;
        end
        default:
        begin
        end
    endcase//end case op
    end//end else
end//end always

//确定源操作数1
always @ (*) 
begin
    if(rst == `RstEnable)
    begin
        reg1_o <= `ZeroWord;
    end
    else if(reg1_read_o == 1'b1)
    begin
        reg1_o <= reg1_data_i;//regfile读端�??1的输出�??
    end
    else if(reg1_read_o == 1'b0)
    begin
        reg1_o <= imm;//立即�??
    end
    else 
    begin
        reg1_o <= `ZeroWord;
    end
end//end always

//确定源操作数2
always @ (*) 
begin
    if(rst == `RstEnable)
    begin
        reg2_o <= `ZeroWord;
    end
    else if(reg2_read_o == 1'b1)
    begin
        reg2_o <= reg2_data_i;//regfile读端�??2的输出�??
    end
    else if(reg2_read_o == 1'b0)
    begin
        reg2_o <= imm;//立即�??
    end
    else 
    begin
        reg1_o <= `ZeroWord;
    end
end//end always

endmodule