
module fifo_sync_tb;

  // Parameters
  parameter DATA_WIDTH = 8;
  parameter FIFO_DEPTH = 16;
  parameter ADDR_WIDTH = 4; // log2(FIFO_DEPTH) = 4

  // Signals
  reg clk;
  reg rst_n;
  reg wr_en;
  reg rd_en;
  reg [DATA_WIDTH-1:0] din;
  wire [DATA_WIDTH-1:0] dout;
  wire full;
  wire empty;

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk; // 10ns period clock

  // Instantiate FIFO (Assume you have a module fifo_sync)
  fifo_sync #(
    .DATA_WIDTH(DATA_WIDTH),
    .FIFO_DEPTH(FIFO_DEPTH)
  ) dut (
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .din(din),
    .dout(dout),
    .full(full),
    .empty(empty)
  );

  // Stimulus
  initial begin
    // Initialize inputs
    rst_n = 0; wr_en = 0; rd_en = 0; din = 0;
    #20 rst_n = 1; // Release reset after 20ns
    
    // Write some data into FIFO
    repeat(18) begin
      @(posedge clk);
      if (!full) begin
        din = din+8'h11;
        wr_en = 1;
      end else begin
        wr_en = 0;
      end
    end
    wr_en = 0; // Stop writing

    // Read data from FIFO
    repeat(18) begin
      @(posedge clk);
      if (!empty) begin
        rd_en = 1;
      end else begin
        rd_en = 0;
      end
    end
    rd_en = 0;

    #100;
    $stop;
  end

endmodule
