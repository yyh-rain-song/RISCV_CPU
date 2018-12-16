`include "id.v"
`include "id_ex.v"
`include "ex.v"
`include "ex_mem.v"
`include "mem.v"
`include "mem_wb.v"
`include "pc_reg.v"
`include "regfile.v"
module RISCV(
    input wire clk,
    input wire rst,
    input wire[7:0] rom_data_i,//从rom中取出的数据
    input wire[1:0] halt_req_i,
    output wire[16:0] rom_addr_o,//读rom的地�???????
    output wire rom_ce_o,//cpu是否可用
    output wire mem_wr
);

wire[`InstAddrBus] pc;
wire pc_changed;
wire[`InstBus] if_inst_i;
wire[`InstBus] if_inst_o;
wire[`InstAddrBus] if_pc_o;

wire if_halt_req;
wire mem_halt_req;

wire[1:0] halt_ctrl_o;

wire inst_enable;
wire[`InstAddrBus] id_pc_i;
wire[`InstBus] id_inst_i;

wire[`AluOpBus] id_aluop_o;
wire[`AluSelBus] id_alusel_o;
wire[`RegBus] id_reg1_o;
wire[`RegBus] id_reg2_o;
wire id_wreg_o;
wire[`RegAddrBus] id_wd_o;

wire[`InstAddrBus] id_link_pc_o;
wire[`InstAddrBus] ex_link_pc_i;
wire[31:0] id_branch_offset_o;
wire[31:0] ex_branch_offset_i;
wire ex_pc_branch_o;
wire ex_IFID_discard_o;
wire ex_IDEX_discard_o;
wire[`InstAddrBus] ex_branch_addr_o;

wire[`AluOpBus] ex_aluop_i;
wire[`AluSelBus] ex_alusel_i;
wire[`RegBus] ex_reg1_i;
wire[`RegBus] ex_reg2_i;
wire ex_wreg_i;
wire[`RegAddrBus] ex_wd_i;

wire ex_wreg_o;
wire[`RegAddrBus] ex_wd_o;
wire[`RegBus] ex_wdata_o;

wire mem_wreg_i;
wire[`RegAddrBus] mem_wd_i;
wire[`RegBus] mem_wdata_i;

wire mem_wreg_o;
wire[`RegAddrBus] mem_wd_o;
wire[`RegBus] mem_wdata_o;

wire wb_wreg_i;
wire[`RegAddrBus] wb_wd_i;
wire[`RegBus] wb_wdata_i;

wire reg1_read;
wire reg2_read;
wire[`RegBus] reg1_data;
wire[`RegBus] reg2_data;
wire[`RegAddrBus] reg1_addr;
wire[`RegAddrBus] reg2_addr;

//pc_reg实例�???????
pc_reg pc_reg0(
        .clk(clk),  .rst(rst),  
        .pc_branch_i(ex_pc_branch_o),
        .branch_addr_i(ex_branch_addr_o),
        .halt_type(halt_ctrl_o),
        
        .pc(pc), .ce(rom_ce_o), .pc_changed(pc_changed)   
);

mem_buffer mem_buffer0(
    .clk(clk),  .rst(rst),
    .pc_addr_i(pc), .read_data(rom_data_i),
    .pc_changed(pc_changed),

    .inst_o(if_inst_i), .inst_enable(inst_enable),
    .read_addr(rom_addr_o), .mem_wr(mem_wr)
);

ctrl ctrl0(
    .rst(rst),  .if_rq(if_halt_req),
    .mem_rq(mem_halt_req), 
    .out_rq(halt_req_i),

    .halt_type(halt_ctrl_o)
);

IF IF0(
    .rst(rst),  .pc(pc),
    .inst_enable_i(inst_enable),
    .inst_i(if_inst_i),

    .inst_o(if_inst_o), .pc_o(if_pc_o),
    .halt_req(if_halt_req)
);

if_id if_id0(
    .clk(clk),  .rst(rst),  .if_pc(pc),
    .if_inst(if_inst_o), .IFID_discard_i(ex_IFID_discard_o),
    .halt_type(halt_ctrl_o),

    .id_pc(id_pc_i), .id_inst(id_inst_i)
);

id id0(
    .rst(rst),  .pc_i(id_pc_i), .inst_i(id_inst_i),
    //input from regfile
    .reg1_data_i(reg1_data),  .reg2_data_i(reg2_data),

    //input from ex
    .ex_wreg_i(ex_wreg_o),  .ex_wdata_i(ex_wdata_o),
    .ex_wd_i(ex_wd_o),

    //input from mem
    .mem_wreg_i(mem_wreg_o),  .mem_wdata_i(mem_wdata_o),
    .mem_wd_i(mem_wd_o),
    
    //output to regfile
    .reg1_read_o(reg1_read),  .reg2_read_o(reg2_read),
    .reg1_addr_o(reg1_addr),  .reg2_addr_o(reg2_addr),

    //output to id_ex
    .aluop_o(id_aluop_o),  .alusel_o(id_alusel_o),
    .reg1_o(id_reg1_o),  .reg2_o(id_reg2_o),
    .wd_o(id_wd_o),  .wreg_o(id_wreg_o),
    .link_pc_o(id_link_pc_o), .branch_offset_o(id_branch_offset_o)
);

regfile regfile1(
    .clk(clk),  .rst(rst),

    .we(wb_wreg_i),  .waddr(wb_wd_i),  .wdata(wb_wdata_i),  
    .re1(reg1_read),  .raddr1(reg1_addr),  .rdata1(reg1_data),
    .re2(reg2_read),  .raddr2(reg2_addr),  .rdata2(reg2_data)
);

id_ex id_ex0(
    .clk(clk),  .rst(rst),

    .id_aluop(id_aluop_o),  .id_alusel(id_alusel_o),
    .id_reg1(id_reg1_o),  .id_reg2(id_reg2_o),
    .id_wd(id_wd_o),  .id_wreg(id_wreg_o),
    .id_link_pc(id_link_pc_o),
    .id_branch_offset(id_branch_offset_o),
    .IDEX_discard_i(ex_IDEX_discard_o),
    .halt_type(halt_ctrl_o),

    .ex_aluop(ex_aluop_i), .ex_alusel(ex_alusel_i),
    .ex_reg1(ex_reg1_i),  .ex_reg2(ex_reg2_i),
    .ex_wd(ex_wd_i),  .ex_wreg(ex_wreg_i),
    .ex_link_pc(ex_link_pc_i),
    .ex_branch_offset(ex_branch_offset_i)
);

ex ex0(
    .rst(rst),

    .aluop_i(ex_aluop_i), .alusel_i(ex_alusel_i),
    .reg1_i(ex_reg1_i), .reg2_i(ex_reg2_i),
    .wd_i(ex_wd_i), .wreg_i(ex_wreg_i),
    .link_pc_i(ex_link_pc_i),
    .branch_offset_i(ex_branch_offset_i),

    .wd_o(ex_wd_o),  .wreg_o(ex_wreg_o),
    .wdata_o(ex_wdata_o),
    .pc_branch_o(ex_pc_branch_o),
    .branch_addr_o(ex_branch_addr_o),
    .IFID_discard_o(ex_IFID_discard_o),
    .IDEX_discard_o(ex_IDEX_discard_o)
    );

ex_mem ex_mem0(
    .clk(clk),  .rst(rst),
    .ex_wd(ex_wd_o),  .ex_wreg(ex_wreg_o),
    .ex_wdata(ex_wdata_o),
    .halt_type(halt_ctrl_o),

    .mem_wd(mem_wd_i),  .mem_wreg(mem_wreg_i),
    .mem_wdata(mem_wdata_i)
);

mem mem0(
    .rst(rst),

    .wd_i(mem_wd_i), .wreg_i(mem_wreg_i),
    .wdata_i(mem_wdata_i),

    .wd_o(mem_wd_o),  .wreg_o(mem_wreg_o),
    .wdata_o(mem_wdata_o)
);

mem_wb mem_wb0(
    .clk(clk),  .rst(rst),

    .mem_wd(mem_wd_o),  .mem_wreg(mem_wreg_o),
    .mem_wdata(mem_wdata_o),
    .halt_type(halt_ctrl_o),

    .wb_wd(wb_wd_i),  .wb_wreg(wb_wreg_i),
    .wb_wdata(wb_wdata_i)
);

endmodule