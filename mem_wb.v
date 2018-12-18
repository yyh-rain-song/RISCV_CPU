`include "define.v"
module mem_wb(
    input wire clk,
    input wire rst,

    input wire[`RegAddrBus] mem_wd,
    input wire mem_wreg,
    input wire[`RegBus] mem_wdata,
    input wire[1:0] halt_type,

    output reg[`RegAddrBus] wb_wd,
    output reg wb_wreg,
    output reg[`RegBus] wb_wdata
);

always @ (posedge clk)
begin
    if(rst == `RstEnable)
    begin
        wb_wd <= `NOPRegAddr;
        wb_wreg <= `WriteDisable;
        wb_wdata <= `ZeroWord;
    end
    else if(halt_type == 2'b00 || halt_type == 2'b01 || halt_type == 2'b10)
    begin
         wb_wd <= mem_wd;
         wb_wreg <= mem_wreg;
         wb_wdata <= mem_wdata;
    end
    else
    begin
        wb_wd <= `NOPRegAddr;
        wb_wreg <= `WriteDisable;
        wb_wdata <= `ZeroWord;
    end
end

endmodule