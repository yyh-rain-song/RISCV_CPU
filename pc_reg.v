/* 2018/11/24 by yyh
** this module enables pc pointer add one each time the clock goes its posedge
** input wire clk (clock time), 
      wire rst (reset option, when rst == 1, move pc to zero)
** output reg[5:0] pc (pc pointer)
       reg ce (if reset on, ce = 1, else ce = 0) */

module pc_reg(
    input wire                  clk,
    input wire                  rst,
    output reg['InstAddrBus]    pc,
    output reg                  ce
);
    always @ (posedge clk)
    begin
        if(rst == RstEnable)
            begin
            ce <= ChipDisable;
            end
        else begin 
             ce <= ChipEnable; 
             end
    end

    always @ (posedge clk)
    begin
        if(ce == ChipDisable)
            begin
            pc <= ZeroWord;
            end
        else begin
             pc <= pc + 4'h4;
             end
    end
endmodule