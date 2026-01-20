module red_tb;

reg r_clk = 0;

initial begin
  r_clk = 0;
  forever #5 r_clk = ~r_clk;
end


reg r_test = 0;
wire w_result;
red dut(
  .clk(r_clk),
  .rst_n(1),
  .in(r_test),
  .out(w_result)
);

initial begin
  $display("Rising Edge Detector Test Started");
  r_test = 0;
  @(posedge r_clk);
  #1 r_test = 1;
  #1 if (w_result == 1) begin
    $error("FAIL: Got result too early");
    $finish;
  end

  @(negedge r_clk);
  #1 if(w_result == 1) begin
    $error("FAIL: Got result on neg clockedge");
    $finish;
  end

  @(posedge r_clk);
  #1 if (w_result == 1)
    $display("PASS");
  else begin
    $error("FAIL");
    $finish;
  end

  $finish;
end

endmodule
