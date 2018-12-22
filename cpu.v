// RISCV32I CPU top module
// port modification allowed for debugging purposes

module cpu(
    input  wire                 clk_in,			// system clock signal
    input  wire                 rst_in,			// reset signal
	  input  wire					        rdy_in,			// ready signal, pause cpu when low

    input  wire [ 7:0]          mem_din,		// data input bus
    output wire [ 7:0]          mem_dout,		// data output bus
    output wire [31:0]          mem_a,			// address bus (only 17:0 is used)
    output wire                 mem_wr,			// write/read signal (1 for write)

	output wire [31:0]			dbgreg_dout		// cpu register output (debugging demo)
);

// implementation goes here

// Specifications:
// - Pause cpu(freeze pc, registers, etc.) when rdy_in is low
// - Memory read takes 2 cycles(wait till next cycle), write takes 1 cycle(no need to wait)
// - Memory is of size 128KB, with valid address ranging from 0x0 to 0x20000
// - I/O port is mapped to address higher than 0x30000 (mem_a[17:16]==2'b11)
// - 0x30000 read: read a byte from input
// - 0x30000 write: write a byte to output (write 0x00 is ignored)
// - 0x30004 read: read clocks passed since cpu starts (in dword, 4 bytes)
// - 0x30004 write: indicates program stop (will output '\0' through uart tx)
wire[1:0] halt_req;
wire mem_wr_o;
assign halt_req = (rdy_in == 1'b1) ? 2'b00 : 2'b11;
assign mem_wr = ~mem_wr_o;
RISCV RISCV0(
  .clk(clk_in),  .rst(rst_in), 
  .rom_data_i(mem_din), .halt_req_i(halt_req),
  .rom_addr_o(mem_a), .rom_data_o(mem_dout),
  .rom_ce_o(), .mem_wr(mem_wr_o)
);
endmodule