module cpu_test_tb;

wire [9:0] w_led;
reg r_clk;
top #(
  .DIVISOR(1),
  .FILE_NAME("mem_init.hex"),
  .ADDR_WIDTH(6),
  .DATA_WIDTH(16)
) top_inst (
  .clk(r_clk),
  .rst_n(1'b1),
  .kbd({1'b1, r_clk}),
  .btn(3'b0),
  .sw(10'b1000001000),
  .mnt(),
  .led(w_led),
  .ssd()
);

initial begin
  r_clk = 0;
  forever #5 r_clk = ~r_clk;
end

initial begin
  #10000000
  $display("TestBench Finished");
  $finish;
end

endmodule
