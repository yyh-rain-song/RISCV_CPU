`include "define.v"

module pc_reg(
    input wire                  clk,
    input wire                  rst,
    input wire                  pc_branch_i,
    input wire[`InstAddrBus]    branch_addr_i,
    input wire[1:0]             halt_type,
    
    output reg[`InstAddrBus]    pc,
    output reg                  ce
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
            end
        else if (halt_type == 2'b00)
        begin
            if(pc_branch_i == 1'b1)
            begin
                pc <= branch_addr_i;
            end
            else begin
                pc <= pc + 4'h4;
            end
        end
    end
endmodule