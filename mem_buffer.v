`include "define.v"



module mem_buffer(
    input wire clk,
    input wire rst,
    input wire[`InstAddrBus] pc_addr_i,
    input wire[`ByteBus] read_data,
    input wire[`RamAddrBus] mem_read_addr,//or write
    input wire[`RegBus] mem_write_data,
    input wire[1:0] mem_read_req,
    input wire[1:0] mem_write_req,
    input wire pc_changed,

    output reg[`InstBus] inst_o,
    output reg inst_enable,
    output reg[`RegBus] mem_data_o,
    output reg mem_data_enable,
    output reg[`RamAddrBus] read_addr,
    output reg[`ByteBus] write_data,
    output reg mem_wr
);
reg[3:0] cnt;//000 001 010 011 100
reg[3:0] stage;
reg[`RamAddrBus] mem_addr;
reg[`RegBus] temp_inst;
reg[`RegBus] temp_mem_data;
reg mem_rd;
reg mem_write;

    always @ (posedge clk)
    begin
        if(rst == `RstEnable)
        begin
            stage <= `Empty;
        end
        else 
        begin
            stage <= cnt;
        end

       if(rst == `RstEnable)
        begin
           cnt <= `Empty;
        end
        else 
        begin
            if(pc_changed == 1'b1 && (stage == `Inst_2 || stage == `Inst_3 || stage == `Inst_4))
            begin
                cnt <= `Inst_1;
            end
            else if(mem_rd == 1'b1 && (stage == `Inst_1 || stage == `Inst_2 || 
                                        stage == `Inst_3 || stage == `Inst_4 || stage == `Inst_5))
            begin
                cnt <= `Mem_1;
            end
            else if(mem_write == 1'b1 && (stage == `Inst_1 || stage == `Inst_2 || 
                                        stage == `Inst_3 || stage == `Inst_4 || stage == `Inst_5))
            begin
                cnt <= `Write_1;
            end
            else if(stage == `Inst_5 && mem_rd == 1'b0 && mem_write == 1'b0)
            begin
                cnt <= `Inst_1;
            end
            else if((stage == `Mem_2 || stage == `Mem_3 || stage == `Mem_5) && mem_rd == 1'b0)
            begin
                cnt <= `Inst_1;
            end
            else if((stage == `Write_1 || stage == `Write_2 || stage == `Write_4) && mem_write == 1'b0)
            begin
                cnt <= `Inst_1;
            end
            else if(stage == `Empty)
            begin
                if(mem_rd == 1'b1)
                begin
                    cnt <= `Mem_1;
                end
                else if(mem_write == 1'b1)
                begin
                    cnt <= `Write_1;
                end
                else
                begin
                    cnt <= `Inst_1;
                end
            end
            else if(stage != `ELSE)
            begin
                cnt <= stage + 1;
            end
            else 
            begin
                cnt <= `Empty;
            end
        end
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
            mem_write <= 1'b0;
            temp_mem_data <= `ZeroWord;
        end
        else
        begin
            case (stage)
            `Empty:
            begin
                inst_o <= `ZeroWord;
                inst_enable <= 1'b0;
                read_addr <= 17'b0;
                mem_data_o <= `ZeroWord;
                mem_data_enable <= 1'b0;
                mem_wr <= 1'b1;
                write_data <= `ZeroWord;
            end
            `Inst_1:
            begin
                inst_enable <= 1'b0;
                inst_o <= `ZeroWord;
                read_addr <= pc_addr_i;
                mem_wr <= 1'b1;
                temp_inst <= `ZeroWord;
                if(mem_rd == 1'b0 && mem_read_req != 2'b00)
                begin
                    mem_rd <= 1'b1;
                    mem_addr <= mem_read_addr;
                    temp_mem_data <= `ZeroWord;
                end
                else
                if(mem_write == 1'b0 && mem_write_req != 2'b00)
                begin
                    mem_write <= 1'b1;
                    mem_addr <= mem_read_addr;
                    temp_mem_data <= mem_write_data;
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
                if(mem_rd == 1'b0 && mem_read_req != 2'b00)
                begin
                    mem_rd <= 1'b1;
                    mem_addr <= mem_read_addr;
                    temp_mem_data <= `ZeroWord;
                end
                else
                if(mem_write == 1'b0 && mem_write_req != 2'b00)
                begin
                    mem_write <= 1'b1;
                    mem_addr <= mem_read_addr;
                    temp_mem_data <= mem_write_data;
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
                if(mem_rd == 1'b0 && mem_read_req != 2'b00)
                begin
                    mem_rd <= 1'b1;
                    mem_addr <= mem_read_addr;
                    temp_mem_data <= `ZeroWord;
                end
                else
                if(mem_write == 1'b0 && mem_write_req != 2'b00)
                begin
                    mem_write <= 1'b1;
                    mem_addr <= mem_read_addr;
                    temp_mem_data <= mem_write_data;
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
                if(mem_rd == 1'b0 && mem_read_req != 2'b00)
                begin
                    mem_rd <= 1'b1;
                    mem_addr <= mem_read_addr;
                    temp_mem_data <= `ZeroWord;
                end
                else
                if(mem_write == 1'b0 && mem_write_req != 2'b00)
                begin
                    mem_write <= 1'b1;
                    mem_addr <= mem_read_addr;
                    temp_mem_data <= mem_write_data;
                end
                mem_data_enable <= 1'b0;
            end
            `Inst_5:
            begin
                inst_enable <= 1'b1;
                mem_wr <= 1'b1;
                inst_o <= {read_data,temp_inst[23:0]};
                if(mem_rd == 1'b0 && mem_read_req != 2'b00)
                begin
                    mem_rd <= 1'b1;
                    mem_addr <= mem_read_addr;
                    temp_mem_data <= `ZeroWord;
                end
                else
                if(mem_write == 1'b0 && mem_write_req != 2'b00)
                begin
                    mem_write <= 1'b1;
                    mem_addr <= mem_read_addr;
                    temp_mem_data <= mem_write_data;
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
                temp_mem_data <= `ZeroWord;
            end
            `Mem_2:
            begin
                inst_enable <= 1'b0;
                mem_wr <= 1'b1;
                inst_o <= `ZeroWord;
                if(mem_read_req == 2'b01)
                begin
                    mem_data_enable <= 1'b1;
                    mem_data_o <= {24'h000000,read_data};
                    mem_rd <= 1'b0;
                end
                else begin
                    mem_data_enable <= 1'b0;
                    read_addr <= mem_read_addr + 1;
                    temp_mem_data[7:0] <= read_data;
                end
            end
            `Mem_3:
            begin
                inst_enable <= 1'b0;
                mem_wr <= 1'b1;
                inst_o <= `ZeroWord;
                if(mem_read_req == 2'b10)
                begin
                    mem_data_enable <= 1'b1;
                    mem_data_o <= {16'h000000,read_data,temp_mem_data[7:0]};
                    mem_rd <= 1'b0;
                end
                else begin
                    mem_data_enable <= 1'b0;
                    read_addr <= mem_read_addr + 2;
                    temp_mem_data[15:8] <= read_data;
                end
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
                mem_rd <= 1'b0;
            end
            `Write_1:
            begin
                inst_enable <= 1'b0;
                mem_wr <= 1'b0;
                inst_o <= `ZeroWord;
                read_addr <= mem_read_addr;
                write_data <= temp_mem_data[7:0];
                if(mem_write_req == 2'b01)
                begin
                    mem_data_enable <= 1'b1;
                    mem_write <= 1'b0;
                end
                else
                begin
                    mem_data_enable <= 1'b0;
                end
            end
            `Write_2:
            begin
                inst_enable <= 1'b0;
                mem_wr <= 1'b0;
                inst_o <= `ZeroWord;
                read_addr <= mem_read_addr + 1;
                write_data <= temp_mem_data[15:8];
                if(mem_write_req == 2'b10)
                begin
                    mem_data_enable <= 1'b1;
                    mem_write <= 1'b0;
                end
                else
                begin
                    mem_data_enable <= 1'b0;
                end
            end
            `Write_3:
            begin
                inst_enable <= 1'b0;
                mem_wr <= 1'b0;
                inst_o <= `ZeroWord;
                mem_data_enable <= 1'b0;
                read_addr <= mem_read_addr + 2;
                write_data <= temp_mem_data[23:16];
            end
            `Write_4:
            begin
                inst_enable <= 1'b0;
                mem_wr <= 1'b0;
                inst_o <= `ZeroWord;
                mem_data_enable <= 1'b1;
                read_addr <= mem_read_addr + 3;
                write_data <= temp_mem_data[31:24];
                mem_write <= 1'b0;
            end            
            default:
            begin
                inst_o <= `ZeroWord;
                inst_enable <= 1'b0;
                read_addr <= 17'b0;
                mem_data_o <= `ZeroWord;
                mem_data_enable <= 1'b0;
                mem_wr <= 1'b1;
                write_data <= `ZeroWord;
            end   
            endcase 
        end
    end
endmodule