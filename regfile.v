module regfile(
    input wire              clk,
    input wire              rst,
    input wire              we,//write enable
    input wire['RegAddrBus] waddr,
    input wire['RegBus]     wdata,

    input wire              re1,
    input wire['RegAddrBus] raddr1,
    output reg['RegBus]     rdata1,

    input wire              re1,
    input wire['RegAddrBus] raddr1,
    output reg['RegBus]     rdata1,
)

reg['RegBus] regs[0:RegNum-1];

    always @ (posedge clk)
    begin
        if(rst == 'RstDisable)
        begin
            if((we == 'WriteEnable)&&(waddr != RegNumLog2'h0))
            begin
                regs[waddr] <= wdata;
            end
        end
    end

    always @ (*)
    begin
        if(rs == 'RstEnable)
        begin
            rdata1 <= 'ZeroWord;
        end
        else if(raddr1 == RegNumLog2'h0)
        begin
            rdata1 <= 'ZeroWord;
        end
        else if((raddr1 == waddr)&&(re1 == 'ReadEnable)&&(we == 'WriteEnable))//同一周期中如果有读有写则先写再读，读的就是写的
        begin
            rdata1 <= wdata;
        end
        else if(re1 == 'ReadEnable)
        begin
            rdata1 <= regs[raddr1];
        end
        else begin
             rdata1 <= 'ZeroWord;
             end
    end

    always @ (*)
    begin
        if(rs == 'RstEnable)
        begin
            rdata2 <= 'ZeroWord;
        end
        else if(raddr2 == RegNumLog2'h0)
        begin
            rdata2 <= 'ZeroWord;
        end
        else if((raddr2 == waddr)&&(re2 == 'ReadEnable)&&(we == 'WriteEnable))//同一周期中如果有读有写则先写再读，读的就是写的
        begin
            rdata2 <= wdata;
        end
        else if(re2 == 'ReadEnable)
        begin
            rdata2 <= regs[raddr2];
        end
        else begin
             rdata2 <= 'ZeroWord;
             end
    end
endmodule