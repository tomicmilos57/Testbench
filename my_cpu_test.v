module my_cpu_test;
  localparam ADDR_WIDTH = 6;
  localparam DATA_WIDTH = 16;

  reg rst_n = 1;
  reg clk = 0;

  // period is 2
  always #1 clk = ~clk;

  wire we;
  wire [ADDR_WIDTH-1:0] addr;
  wire [DATA_WIDTH-1:0] data;
  wire [DATA_WIDTH-1:0] mem;

  reg [DATA_WIDTH-1:0] in = 8;
  reg control = 0;
  wire [DATA_WIDTH-1:0] out;
  wire [ADDR_WIDTH-1:0] pc;
  wire [ADDR_WIDTH-1:0] sp;

  my_memory #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) m0(
    .i_clk(clk),
    .i_rst_n(rst_n),
    .i_we(we),
    .i_addr(addr),
    .i_data(data),
    .o_out(mem)
  );

  cpu #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) cpu0(
    .i_clk(clk),
    .i_rst_n(rst_n),
    .o_addr(addr),
    .o_data(data),
    .o_we(we),
    .i_mem(mem),
    .i_in(in),
    .i_control(control),
    .o_status(status),
    .o_out(out),
    .o_pc(pc),
    .o_sp(sp)
  );

  always @(we, addr, data, mem) begin
    if (we)
      $display("[%0t] MEM WR: addr: %b data: %b", $time, addr, data);
    else
      $display("[%0t] MEM RE: addr: %b data: %b", $time, addr, mem);
  end

  always @(pc, sp) begin
    $display("[%0t] SP: %d PC: %d", $time, sp, pc);
  end

  always @(out) begin
    $display("[%0t] OUT: %b", $time, out);
  end

  initial begin
    // rst_n na pocetku
    rst_n = 0;
    repeat (2) @(posedge clk);
    rst_n = 1;
    // sistem je inicijalizovan

    $display("CPU jooj");

    @(posedge status);
    in = 7;
    control = 1;
    @(negedge status);
    control = 0;

    @(posedge status);
    in = 8;
    control = 1;
    @(negedge status);
    control = 0;

    //@(posedge status);
    //in = 8;
    //control = 1;
    //@(negedge status);
    //control = 0;

    #100;

    $finish;

  end

endmodule