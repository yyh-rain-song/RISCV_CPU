`include "define.v"
module mem_buffer(
    input wire clk,
    input wire rst,
    input wire[`InstAddrBus] pc_addr_i,
    input wire[`ByteBus] read_data,
    input wire pc_changed,

    output reg[`InstBus] inst_o,
    output reg inst_enable,
    output reg[16:0] read_addr,
    output reg mem_wr
);
reg[2:0] cnt;//000 001 010 011 100
reg[31:0] temp_inst;
    always @ (posedge clk)
    begin
        if(rst == `RstEnable)
        begin
           cnt = 3'b100;
        end
        else 
        begin
            if(cnt == 3'b100 || pc_changed == 1'b1)
            begin
                cnt = 3'b000;
            end 
            else
            begin
                cnt = cnt + 1;
            end
        end
    end
    
    always @ (*)
    begin
        if(rst == `RstEnable)
        begin
            inst_o <= `ZeroWord;
            inst_enable <= 1'b0;
            read_addr <= 17'b0;
            mem_wr <= 1'b1;
            temp_inst <= 32'b0;
        end else
        begin
            case (cnt)
            3'b000:
            begin
                inst_enable <= 1'b0;
                inst_o <= `ZeroWord;
                read_addr <= pc_addr_i;
                mem_wr <= 1'b1;
                temp_inst <= 32'b0;
            end
            3'b001:
            begin
                inst_enable <= 1'b0;
                inst_o <= `ZeroWord;
                read_addr <= pc_addr_i + 1;
                mem_wr <= 1'b1;
                temp_inst[7:0] <= read_data;
            end
            3'b010:
            begin
                inst_enable <= 1'b0;
                inst_o <= `ZeroWord;
                read_addr <= pc_addr_i + 2;
                mem_wr <= 1'b1;
                temp_inst[15:8] <= read_data;
            end
            3'b011:
            begin
                inst_enable <= 1'b0;
                inst_o <= `ZeroWord;
                read_addr <= pc_addr_i + 3;
                mem_wr <= 1'b1;
                temp_inst[23:16] <= read_data;
            end
            3'b100:
            begin
                inst_enable <= 1'b1;
                mem_wr <= 1'b1;
                inst_o <= {read_data,temp_inst[23:0]};
            end    
            endcase 
        end
    end
endmodule