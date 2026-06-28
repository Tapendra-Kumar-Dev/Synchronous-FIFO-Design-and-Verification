module syn_fifo #(

    parameter DATA_WIDTH=8,
    parameter FIFO_DEPTH=8

)(
    input wire clk,rst,
    input wire wr,rd,

    input wire [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,

    output wire full,empty,

    output reg underflow,
    output reg overflow

);

localparam PTR_WIDTH=$clog2(FIFO_DEPTH);

reg [DATA_WIDTH-1:0] fifo_mem[0:FIFO_DEPTH-1];
reg [PTR_WIDTH:0] write_ptr;
reg [PTR_WIDTH:0] read_ptr;


assign empty= (write_ptr==read_ptr);
assign full=(write_ptr[PTR_WIDTH]!=read_ptr[PTR_WIDTH]) &&
            (write_ptr[PTR_WIDTH-1:0]==read_ptr[PTR_WIDTH-1:0]);


always @(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        write_ptr <=0;
        read_ptr <=0;
        data_out <=0;
        overflow <=0;
        underflow <=0;
    end
    else
    begin

        overflow <=0;
        underflow <=0;

        if(wr && !full)
        begin
            fifo_mem[write_ptr[PTR_WIDTH-1:0]] <=data_in;
            write_ptr <=write_ptr+1;
        end

        else if(wr && full)
        begin
            overflow <=1'b1;
        end

        if(rd && !empty)
        begin  
            data_out <=fifo_mem[read_ptr[PTR_WIDTH-1:0]];
            read_ptr <=read_ptr+1;
        end
        
        else if(rd && empty)
        begin
            underflow <=1'b1;
        end
    end
end
endmodule


