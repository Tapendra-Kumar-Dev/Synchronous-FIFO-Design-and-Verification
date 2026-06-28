`timescale 1ns/1ps

module syn_fifo_tb;

parameter DATA_WIDTH=8;
parameter FIFO_DEPTH=8;

reg clk,rst;
reg wr,rd;

reg [DATA_WIDTH-1:0] data_in;
wire [DATA_WIDTH-1:0] data_out;

wire full,empty;
wire overflow,underflow;

syn_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .FIFO_DEPTH(FIFO_DEPTH)
)dut(
    .clk(clk),
    .rst(rst),
    .wr(wr),
    .rd(rd),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty),
    .overflow(overflow),
    .underflow(underflow)
);

fifo_assertion #(
    .DATA_WIDTH(DATA_WIDTH),
    .FIFO_DEPTH(FIFO_DEPTH)
)assertion_inst(
    .clk(clk),
    .rst(rst),
    .wr(wr),
    .rd(rd),
    .full(full),
    .empty(empty),
    .overflow(overflow),
    .underflow(underflow)
);

always #5 clk=~clk;

initial
begin
    clk=0;
    rst=0;
    wr=0;
    rd=0;
    data_in=0;

    #20;
    rst=1;

    repeat(9)
    begin
        @(posedge clk);
        wr=1;
        data_in=data_in+1;
    end

    @(posedge clk);
    wr=0;

    repeat(9)
    begin
        @(posedge clk);
        rd=1;
    end

    @(posedge clk);
    rd=0;

    repeat(4)
    begin
        @(posedge clk);
        wr=1;
        data_in=data_in+1;
    end

    @(posedge clk);
    wr=0;

    @(posedge clk);
    wr=1;
    rd=1;
    data_in=data_in+1;

    @(posedge clk);
    wr=0;
    rd=0;

    #20;
    $finish;
end

initial
begin
    $monitor("Time=%0t wr=%b rd=%b data_in=%0d data_out=%0d full=%b empty=%b overflow=%b underflow=%b",
             $time,wr,rd,data_in,data_out,full,empty,overflow,underflow);
end

initial
begin
    $dumpfile("fifo.vcd");
    $dumpvars(0,syn_fifo_tb);
end

endmodule