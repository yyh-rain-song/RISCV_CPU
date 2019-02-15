// testbench top module file
// for simulation only

`timescale 1ns/1ps
module testbench;

reg clk_1;
reg clk_2;
reg rst;

riscv_top #(.SIM(1)) top(
    .CLOCK_P(clk_1),
    .CLOCK_N(clk_2),
    .btnC(rst),
    .Tx(),
    .Rx(),
    .led()
);

initial begin
  clk_1=0;
  clk_2=1;
  rst=1;
#500
  rst=0; 
end

always #10 clk_1=!clk_1;
always #10 clk_2=!clk_2;

endmodule