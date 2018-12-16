`include "define.v"

module pc_reg(
    input wire                  clk,
    input wire                  rst,
    input wire                  pc_branch_i,
    input wire[`InstAddrBus]    branch_addr_i,
    input wire[1:0]             halt_type,
    
    output reg[`InstAddrBus]    pc,
    output reg                  ce,
    output reg                  pc_changed
);
    always @ (posedge clk)
    begin
        if(rst == `RstEnable)
            begin
            ce <= `ChipDisable;
            end
        else begin 
             ce <= `ChipEnable; 
             end
    end

    always @ (posedge clk)
    begin
        if(ce == `ChipDisable)
            begin
            pc <= `ZeroWord;
            pc_changed <= 1'b0;
            end
        else if(pc_branch_i == 1'b1)
        begin
            pc <= branch_addr_i;
            pc_changed <= 1'b1;
        end
        else if (halt_type == 2'b00)
        begin
            pc <= pc + 4'h4;
            pc_changed <= 1'b1;
        end
        else
        begin
            pc_changed <= 1'b0;
        end
    end
endmodule