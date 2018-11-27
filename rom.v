/* 2018/11/24 by yyh 
** this module enables instruction fetch from rom.
** input wire ce(reset option. if ce == 1, output inst = 0)
         wire addr(pc pointer)
** output reg[31:0] inst(instruction)
*/
module rom(
    input wire ce,
    input wire[5:0] addr,
    output reg[31:0] inst
);
reg[31:0] rom[63:0];
always @ (*) begin
    if (ce == 1'b0)
    begin
        inst <= 32'h0;
    end
    else
    begin
        inst <= rom[addr];
    end
end