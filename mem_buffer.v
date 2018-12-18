`include "define.v"

module mem_buffer(
    input wire clk,
    input wire rst,
    input wire[`InstAddrBus] pc_addr_i,
    input wire[`ByteBus] read_data,
    input wire[`RamAddrBus] mem_read_addr,
    input wire mem_read_req,
    input wire pc_changed,

    output reg[`InstBus] inst_o,
    output reg inst_enable,
    output reg[`RegBus] mem_data_o,
    output reg mem_data_enable,
    output reg[`RamAddrBus] read_addr,
    output reg mem_wr
);
reg[3:0] cnt;//000 001 010 011 100
reg[`RamAddrBus] mem_addr;
reg[`RegBus] temp_inst;
reg[`RegBus] temp_mem_data;
reg mem_rd;

    always @ (posedge clk)
    begin
        if(rst == `RstEnable)
        begin
           cnt <= `Mem_5;
        end
        else 
        begin
            if(cnt == `Mem_5 || pc_changed == 1'b1)
            begin
                cnt <= `Inst_1;
            end 
            else if(cnt == `Inst_5 && mem_rd == 1'b0)
            begin
                cnt <= `Inst_1;
            end else
            begin
                cnt <= cnt + 1;
            end
        end
    end
    
    always @ (*)
    begin
        if(rst == `RstEnable)
        begin
            inst_o <= `ZeroWord;
            inst_enable <= 1'b0;
            read_addr <= `ZeroRamAddr;
            mem_data_o <= `ZeroWord;
            mem_data_enable <= 1'b0;
            mem_wr <= 1'b1;
            temp_inst <= `ZeroWord;
            mem_rd <= 1'b0;
            temp_mem_data <= `ZeroWord;
        end else
        begin
            case (cnt)
            `Inst_1:
            begin
                inst_enable <= 1'b0;
                inst_o <= `ZeroWord;
                read_addr <= pc_addr_i;
                mem_wr <= 1'b1;
                temp_inst <= 32'b0;
                if(mem_rd == 1'b0 && mem_read_req == 1'b1)
                begin
                    mem_rd <= 1'b1;
                    mem_addr <= mem_read_addr;
                    temp_mem_data <= `ZeroWord;
                end
                mem_data_enable <= 1'b0;
            end
            `Inst_2:
            begin
                inst_enable <= 1'b0;
                inst_o <= `ZeroWord;
                read_addr <= pc_addr_i + 1;
                mem_wr <= 1'b1;
                temp_inst[7:0] <= read_data;
                if(mem_rd == 1'b0 && mem_read_req == 1'b1)
                begin
                    mem_rd <= 1'b1;
                    mem_addr <= mem_read_addr;
                    temp_mem_data <= `ZeroWord;
                end
                mem_data_enable <= 1'b0;
            end
            `Inst_3:
            begin
                inst_enable <= 1'b0;
                inst_o <= `ZeroWord;
                read_addr <= pc_addr_i + 2;
                mem_wr <= 1'b1;
                temp_inst[15:8] <= read_data;
                if(mem_rd == 1'b0 && mem_read_req == 1'b1)
                begin
                    mem_rd <= 1'b1;
                    mem_addr <= mem_read_addr;
                    temp_mem_data <= `ZeroWord;
                end
                mem_data_enable <= 1'b0;
            end
            `Inst_4:
            begin
                inst_enable <= 1'b0;
                inst_o <= `ZeroWord;
                read_addr <= pc_addr_i + 3;
                mem_wr <= 1'b1;
                temp_inst[23:16] <= read_data;
                if(mem_rd == 1'b0 && mem_read_req == 1'b1)
                begin
                    mem_rd <= 1'b1;
                    mem_addr <= mem_read_addr;
                    temp_mem_data <= `ZeroWord;
                end
                mem_data_enable <= 1'b0;
            end
            `Inst_5:
            begin
                inst_enable <= 1'b1;
                mem_wr <= 1'b1;
                inst_o <= {read_data,temp_inst[23:0]};
                if(mem_rd == 1'b0 && mem_read_req == 1'b1)
                begin
                    mem_rd <= 1'b1;
                    mem_addr <= mem_read_addr;
                    temp_mem_data <= `ZeroWord;
                end
                mem_data_enable <= 1'b0;
            end
            `Mem_1:
            begin
                inst_enable <= 1'b0;
                mem_wr <= 1'b1;
                inst_o <= `ZeroWord;
                mem_data_enable <= 1'b0;
                read_addr <= mem_read_addr;
            end
            `Mem_2:
            begin
                inst_enable <= 1'b0;
                mem_wr <= 1'b1;
                inst_o <= `ZeroWord;
                mem_data_enable <= 1'b0;
                read_addr <= mem_read_addr + 1;
                temp_mem_data[7:0] <= read_data;
            end
            `Mem_3:
            begin
                inst_enable <= 1'b0;
                mem_wr <= 1'b1;
                inst_o <= `ZeroWord;
                mem_data_enable <= 1'b0;
                read_addr <= mem_read_addr + 2;
                temp_mem_data[15:8] <= read_data;
            end
            `Mem_4:
            begin
                inst_enable <= 1'b0;
                mem_wr <= 1'b1;
                inst_o <= `ZeroWord;
                mem_data_enable <= 1'b0;
                read_addr <= mem_read_addr + 3;
                temp_mem_data[23:16] <= read_data;
            end
            `Mem_5:
            begin
                inst_enable <= 1'b0;
                mem_wr <= 1'b1;
                inst_o <= `ZeroWord;
                mem_data_enable <= 1'b1;
                temp_mem_data[31:24] <= read_data;
                mem_data_o <= {read_data, temp_mem_data[23:0]};
            end            
            default:
            begin
                inst_o <= `ZeroWord;
                inst_enable <= 1'b1;
                read_addr <= 17'b0;
                mem_data_o <= `ZeroWord;
                mem_data_enable <= 1'b0;
                mem_wr <= 1'b1;
            end   
            endcase 
        end
    end
endmodule