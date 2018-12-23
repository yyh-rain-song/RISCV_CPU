
//undo
module cache(
    input wire clk,
    input wire rst,

    input wire[`RamAddrBus] raddr,
    input wire rd,
    output reg[`RegBus] rd_data,
    output reg miss//1 for missed

    input wire wt,
    input wire[1:0] bit_select,//01:byte, 10:half, 11:word
    input wire[`RamAddrBus] waddr,
    input wire[`RegBus] wt_data
);

reg [`ByteBus] ram [131071:0];
reg enable[131071:0];

always @ (posedge clk)
begin
    if(rst == `RstDisable)
    begin
        if(wt == 1'b0)
        begin
            case (bit_select)
            2'b01:
            begin
                ram[waddr] <= wt_data[7:0];
                enable[waddr] <= 1'b1;
            end
            2'b10:
            begin
                ram[waddr] <= wt_data[7:0];
                enable[waddr] <= 1'b1;
                ram[waddr+1] <= wt_data[15:8];
                enable[waddr+1] <= 1'b1;
            end
            2'b11:
            begin
                ram[waddr] <= wt_data[7:0];
                enable[waddr] <= 1'b1;
                ram[waddr+1] <= wt_data[15:8];
                enable[waddr+1] <= 1'b1;
                ram[waddr+2] <= wt_data[23:16];
                enable[waddr+2] <= 1'b1;
                ram[waddr+3] <= wt_data[31:24];
                enable[waddr+3] <= 1'b1;
            end
        end
    end
end

always @ (*)
begin
    if(rst == `RstEnable)
    begin
        rd_data <= `ZeroWord;
        miss <= 1'b0;
    end
    else if((waddr == raddr)&&(rd == 1'b1)&&(wt = 1'b1))
    begin
        rd_data <= wt_data;
        miss <= 1'b0;
    end
    else if((rd == 1'b1)&&(enable[raddr] == 1'b1))
    begin
        rd_data <= {ram[raddr+3],ram[raddr+2],ram[raddr+1],ram[raddr]};
        
    end
end