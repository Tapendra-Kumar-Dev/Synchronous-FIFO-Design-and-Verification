module fifo_assertion #(
    parameter DATA_WIDTH=8,
    parameter FIFO_DEPTH=8
)(
    input clk,
    input rst,
    input rd,
    input wr,
    input full,
    input empty,
    input overflow,
    input underflow
);

always @(posedge clk)
begin
    if(rst)
    begin
        if(wr && !full && overflow)
            $error("Unexpected overflow during valid write.");

        if(rd && !empty && underflow)
            $error("Unexpected underflow during valid read.");

        if(full && empty)
            $error("FIFO cannot be full and empty at the same time.");

        if(overflow && !full)
            $error("Overflow asserted when FIFO was not full.");

        if(underflow && !empty)
            $error("Underflow asserted when FIFO was not empty.");

        if(wr && rd && !full && !empty)
        begin
            if(overflow || underflow)
                $error("Unexpected overflow/underflow during simultaneous read/write.");
        end
    end
end

endmodule
