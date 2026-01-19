module debouncer_tb;

reg r_clk = 0;
initial begin
  r_clk = 0;
  forever #5 r_clk = ~r_clk;
end

reg r_rst_n = 0;
reg r_in = 0;
wire w_out;

debouncer dut(
  .i_clk(r_clk),
  .i_rst_n(r_rst_n),
  .i_in(r_in),
  .o_out(w_out)
);

localparam SIZE = 3;
localparam THRESH = (1<<SIZE) - 1; // counter target (all ones)

integer i;
initial begin
  $display("Debouncer Test Started");

  // apply reset
  r_rst_n = 0;
  r_in = 0;
  repeat(2) @(posedge r_clk);
  r_rst_n = 1;
  @(posedge r_clk);

  if (w_out !== 0) begin
    $error("FAIL: output not 0 after reset: %0b", w_out);
    $finish;
  end

  // short noisy toggles (shorter than threshold) should NOT change output
  for (i = 0; i < (THRESH/2); i = i + 1) begin
    @(posedge r_clk);
    r_in = ~r_in;
  end
  @(posedge r_clk); #1;
  if (w_out !== 0) begin
    $error("FAIL: output changed during short bounce");
    $finish;
  end

  // hold input high for long enough to pass threshold -> output should go high
  for (i = 0; i <= THRESH + 1; i = i + 1) begin
    @(posedge r_clk);
    r_in = 1;
  end
  @(posedge r_clk); #1;
  if (w_out !== 1) begin
    $error("FAIL: output did not go high after stable period");
    $finish;
  end

  // short bounce to low should not immediately clear output
  for (i = 0; i < (THRESH/2); i = i + 1) begin
    @(posedge r_clk);
    r_in = ~r_in;
  end
  @(posedge r_clk); #1;
  if (w_out !== 1) begin
    $error("FAIL: output changed during short bounce to low");
    $finish;
  end

  // hold input low long enough -> output should clear
  for (i = 0; i <= THRESH + 1; i = i + 1) begin
    @(posedge r_clk);
    r_in = 0;
  end
  @(posedge r_clk); #1;
  if (w_out !== 0) begin
    $error("FAIL: output did not clear after stable low period");
    $finish;
  end

  $display("PASS: debouncer behavior correct");
  $finish;
end

endmodule

