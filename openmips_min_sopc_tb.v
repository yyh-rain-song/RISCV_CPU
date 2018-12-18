`timescale 1ns/1ps
`include "define.v"
module openmips_min_sopc_tb();
reg CLOCK_50;
reg rst;
reg[1:0] halt;

initial begin
  CLOCK_50 = 1'b0;
  forever #10 CLOCK_50 = ~CLOCK_50;
end

initial begin
    rst = `RstEnable;
    #195 rst= `RstDisable;
    #10000 $stop;
end

initial begin
    halt = 2'b00;
   // #500 halt = 2'b11;
end

openmips_min_sopc openmips_min_sopc0(
    .clk(CLOCK_50),
    .rst(rst),
    .halt_req(halt)
);

endmodule