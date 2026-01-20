module clk_div_tb;

reg r_clk = 0;
initial begin
  r_clk = 0;
  forever #5 r_clk = ~r_clk;
end

reg r_rst_n = 0;
wire w_out;

localparam DIV = 8;
clk_div #(.DIVISOR(DIV)) dut(
  .clk(r_clk),
  .rst_n(r_rst_n),
  .out(w_out)
);

integer i;
integer expected;
initial begin
  $display("Manual Clk Div Test Started (DIV=%0d)", DIV);

  expected = (DIV >> 1) + 1; // number of posedges between toggles

  // apply reset
  r_rst_n = 0;
  @(posedge r_clk);
  @(posedge r_clk);
  r_rst_n = 1;

  for (i = 0; i < expected; i = i + 1) begin
    @(posedge r_clk);
    #1;
    if (i < expected-1) begin
      if (w_out !== 0) begin
        $error("FAIL: output dropped early during high period at cycle %0d", i);
        $finish;
      end
    end else begin
      // on the final cycle it should toggle to 0
      if (w_out !== 1) begin
        $error("FAIL: output did not toggle low after %0d cycles (expected=%0d)", expected, expected);
        $finish;
      end
    end
  end

  for (i = 0; i < expected; i = i + 1) begin
    @(posedge r_clk);
    #1;
    if (i < expected-1) begin
      if (w_out !== 1) begin
        $error("FAIL: output rose early during low period at cycle %0d", i);
        $finish;
      end
    end else begin
      // final cycle should toggle back to 1
      if (w_out !== 0) begin
        $error("FAIL: output did not toggle high after low period");
        $finish;
      end
    end
  end

  $display("PASS: clk_div produced %0d-cycle high and low periods", expected);
  $finish;
end

endmodule

