`include "RISCV.v"
`include "inst_rom.v"

module openmips_min_sopc(
    input wire clk,
    input wire rst,
    input wire[1:0] halt_req
);
    wire[`InstAddrBus] inst_addr;
    wire[7:0] inst;
    wire rom_ce;
    wire mem_wr;

    RISCV RISCV0(
        .clk(clk),  .rst(rst),
        .rom_data_i(inst), .halt_req_i(halt_req),
        
        .rom_addr_o(inst_addr),  .rom_ce_o(rom_ce),
        .mem_wr(mem_wr)
    );

    ram ram0(
        .clk_in(clk),  .en_in(rom_ce),
        .r_nw_in(mem_wr),  .a_in(inst_addr),
        
        .d_out(inst)
    );

    endmodule