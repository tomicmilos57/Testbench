module bcd_tb;

reg [5:0] r_in;
wire [3:0] w_ones;
wire [3:0] w_tens;

bcd dut(
  .in(r_in),
  .ones(w_ones),
  .tens(w_tens)
);

integer i;
initial begin
  $display("BCD Test Started");
  for (i = 0; i < 64; i = i + 1) begin
    r_in = i;
    #1;
    if (w_ones !== (i % 10) || w_tens !== (i / 10)) begin
      $error("FAIL: input=%0d ones=%0d expected=%0d tens=%0d expected=%0d", i, w_ones, (i % 10), w_tens, (i / 10));
      $finish;
    end
  end
  $display("PASS: all values 0..63 correct");
  $finish;
end

endmodule
