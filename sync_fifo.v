module sync_fifo #(parameter DEPTH=8, DWIDTH=16) (
   input clk, rstn,
   input wr_en, rd_en,
   input [DWIDTH-1:0] din,
   output reg [DWIDTH-1:0] dout,
   output full, empty
);
   reg [$clog2(DEPTH)-1:0] wptr, rptr;
   reg [DWIDTH-1:0] fifo [0:DEPTH-1];
  //write logic
   always @(posedge clk) begin
       if (!rstn) 
            wptr <= 0;
       else if (wr_en && !full) begin
           fifo[wptr] <= din;
           wptr <= wptr + 1;
       end
   end
   //read logic
   always @(posedge clk) begin
       if (!rstn) 
            rptr <= 0;
       else if (rd_en && !empty) begin
           dout <= fifo[rptr];
           rptr <= rptr + 1;
       end
   end
   assign full = ((wptr + 1) == rptr);
   assign empty = (wptr == rptr);
endmodule
