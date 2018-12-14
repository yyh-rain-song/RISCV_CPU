`include "define.v"
module ctrl(
    input wire rst,
    input wire if_rq,
    input wire mem_rq,
    input wire out_rq,

    output reg[1:0] halt_type
);

always @ (*)
begin
    if(rst == `RstEnable)
    begin
        halt_type <= 2'b00;
    end
    else if(if_rq == 1'b1)
    begin
        halt_type <= 2'b01;
    end
    else if(mem_rq == 1'b1)
    begin
        halt_type <= 2'b10;
    end
    else if(out_rq == 1'b1)
    begin
        halt_type <= 2'b11;
    end
end

endmodule