`include "define.v"
module mem(
    input wire rst,
    input wire[`RegAddrBus] wd_i,
    input wire wreg_i,
    input wire[`RegBus] wdata_i,
    input wire[`AluOpBus] aluop_i,
    input wire[`RamAddrBus] ex_mem_addr_i,
    input wire[`RegBus] ex_mem_data_i,
    input wire ex_mem_wr_i,

    input wire[`RegBus] ram_data_i,
    input wire ram_data_enable_i,

    output reg[`RegAddrBus] wd_o,
    output reg wreg_o,
    output reg[`RegBus] wdata_o,

    output reg[`RamAddrBus] ram_addr_o,
    output reg[`RegBus] ram_data_o,
    output reg halt_req,
    output reg[1:0] mem_read_req,
    output reg[1:0] mem_write_req
);
reg[`RegBus] ram_data;
always @ (*)
begin
    if(rst == `RstEnable)
    begin
        wd_o <= `NOPRegAddr;
        wreg_o <= `WriteDisable;
        wdata_o <= `ZeroWord;
        ram_addr_o <= `ZeroRamAddr;
        ram_data_o <= `ZeroWord;
        halt_req <= 1'b0;
        mem_read_req <= 2'b00;
        mem_write_req <= 2'b00;
    end
    else if(ex_mem_wr_i)
    begin
        case(aluop_i)
        `EXE_LW_OP:
        begin
            ram_addr_o <= ex_mem_addr_i;
            halt_req <= ~ram_data_enable_i;
            ram_data <= ram_data_i;
            wdata_o <= ram_data;
            wd_o <= wd_i;
            wreg_o <= wreg_i;
            mem_read_req <= 2'b11;
            mem_write_req <= 2'b00;
        end
        `EXE_LH_OP:
        begin
            ram_addr_o <= ex_mem_addr_i;
            halt_req <= ~ram_data_enable_i;
            ram_data <= ram_data_i;
            wdata_o <= {{16{ram_data[15]}},ram_data[15:0]};
            wd_o <= wd_i;
            wreg_o <= wreg_i;
            mem_read_req <= 2'b10;
            mem_write_req <= 2'b00;
        end
        `EXE_LB_OP:
        begin
            ram_addr_o <= ex_mem_addr_i;
            halt_req <= ~ram_data_enable_i;
            ram_data <= ram_data_i;
            wdata_o <= {{24{ram_data[7]}},ram_data[7:0]};
            wd_o <= wd_i;
            wreg_o <= wreg_i;
            mem_read_req <= 2'b01;
            mem_write_req <= 2'b00;
        end
        `EXE_LBU_OP:
        begin
            ram_addr_o <= ex_mem_addr_i;
            halt_req <= ~ram_data_enable_i;
            ram_data <= ram_data_i;
            wdata_o <= {24'h000000,ram_data[7:0]};           
            wd_o <= wd_i;
            wreg_o <= wreg_i;
            mem_read_req <= 2'b01;
            mem_write_req <= 2'b00;
        end
        `EXE_LHU_OP:
        begin
            ram_addr_o <= ex_mem_addr_i;
            halt_req <= ~ram_data_enable_i;
            ram_data <= ram_data_i;
            wdata_o <= {16'h0000,ram_data[15:0]};           
            wd_o <= wd_i;
            wreg_o <= wreg_i;
            mem_read_req <= 2'b10;
            mem_write_req <= 2'b00;
        end
        `EXE_SW_OP:
        begin
            ram_addr_o <= ex_mem_addr_i;
            halt_req <= ~ram_data_enable_i;
            ram_data_o <= ex_mem_data_i;
            wd_o <= wd_i;
            wreg_o <= wreg_i;
            if(ram_data_enable_i == 1'b0)
            begin
                mem_write_req <= 2'b11;
            end
            else begin
                mem_write_req <= 2'b00;
            end
            mem_read_req <= 2'b00;
        end
        `EXE_SH_OP:
        begin
            ram_addr_o <= ex_mem_addr_i;
            halt_req <= ~ram_data_enable_i;
            ram_data_o <= ex_mem_data_i;
            wd_o <= wd_i;
            wreg_o <= wreg_i;
            if(ram_data_enable_i == 1'b0)
            begin
                mem_write_req <= 2'b10;
            end
            else begin
                mem_write_req <= 2'b00;
            end
            mem_read_req <= 2'b00;
        end
        `EXE_SB_OP:
        begin
            ram_addr_o <= ex_mem_addr_i;
            halt_req <= ~ram_data_enable_i;
            ram_data_o <= ex_mem_data_i;
            wd_o <= wd_i;
            wreg_o <= wreg_i;
            mem_write_req <= 2'b01;
            mem_read_req <= 2'b00;
        end
        default:
        begin
            ram_addr_o <= 17'b0;
            halt_req <= 1'b0;
            ram_data <= `ZeroWord;
            wdata_o <=`ZeroWord;
            wd_o <= `ZeroWord;
            wreg_o <= 1'b0;
            mem_read_req <= 2'b00;
            mem_write_req <= 2'b00;
        end
        endcase
    end
    else
    begin
        wd_o <= wd_i;
        wreg_o <= wreg_i;
        wdata_o <= wdata_i;
        halt_req <= 1'b0;
        mem_read_req <= 2'b00;
        mem_write_req <= 2'b00;
    end
end

endmodule