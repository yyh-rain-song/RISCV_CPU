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
        reg1_o <= `ZeroWord;
    end
end//end always

endmodule