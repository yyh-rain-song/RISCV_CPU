`include "define.v"
module inst_rom(
    input wire ce,
    input wire[`InstAddrBus] addr,
    output reg[`InstBus] inst
);

    reg[`InstBus] inst_mem[0:`InstMemNum-1];
    initial $readmemh ("D:/RISCV/compile/test.data", inst_mem);
    always @ (*) begin
        if(ce == `ChipDisable)
        begin
            inst <= `ZeroWord;
        end
        else
        begin
            inst <= inst_mem[addr[`InstMemNumLog2+1:2]];//没太看懂.jpg
        end
    end
endmodule