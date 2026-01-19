module scan_codes_tb;

reg r_clk = 0;
initial begin
  r_clk = 0;
  forever #5 r_clk = ~r_clk;
end

reg r_rst_n = 0;
reg [15:0] r_code = 16'h0000;
reg r_status = 0;
wire w_control;
wire [3:0] w_num;

scan_codes dut(
  .i_clk(r_clk),
  .i_rst_n(r_rst_n),
  .i_code(r_code),
  .i_status(r_status),
  .o_control(w_control),
  .o_num(w_num)
);

reg [15:0] codes [0:9];
reg [3:0] vals [0:9];
integer i;

initial begin
  // prepare mapping (match module cases)
  codes[0] = 16'hF016; vals[0] = 4'd1;
  codes[1] = 16'hF01E; vals[1] = 4'd2;
  codes[2] = 16'hF026; vals[2] = 4'd3;
  codes[3] = 16'hF025; vals[3] = 4'd4;
  codes[4] = 16'hF02E; vals[4] = 4'd5;
  codes[5] = 16'hF036; vals[5] = 4'd6;
  codes[6] = 16'hF03D; vals[6] = 4'd7;
  codes[7] = 16'hF03E; vals[7] = 4'd8;
  codes[8] = 16'hF046; vals[8] = 4'd9;
  codes[9] = 16'hF045; vals[9] = 4'd0;

  $display("Scan Codes Test Started");

  // reset
  r_rst_n = 0;
  r_status = 0;
  r_code = 16'h0000;
  @(posedge r_clk);
  @(posedge r_clk);
  r_rst_n = 1;
  @(posedge r_clk);

  // verify reset state
  #1;
  if (w_control !== 0 || w_num !== 4'd0) begin
    $error("FAIL: not in reset state after deassert (control=%b num=%0d)", w_control, w_num);
    $finish;
  end

  // test each mapping: assert status for one cycle with code, check control pulse and number
  for (i = 0; i < 10; i = i + 1) begin
    r_code = codes[i];
    r_status = 1;
    @(posedge r_clk);
    #1;
    if (w_control !== 1 || w_num !== vals[i]) begin
      $error("FAIL: code %h expected num=%0d got control=%b num=%0d", codes[i], vals[i], w_control, w_num);
      $finish;
    end

    // drop status and ensure control returns low but number remains
    r_status = 0;
    @(posedge r_clk);
    #1;
    if (w_control !== 0) begin
      $error("FAIL: control did not return low after code %h", codes[i]);
      $finish;
    end
    if (w_num !== vals[i]) begin
      $error("FAIL: num changed unexpectedly after code %h (got %0d expected %0d)", codes[i], w_num, vals[i]);
      $finish;
    end
  end

  $display("PASS: scan_codes mapping and control pulse behavior verified");
  $finish;
end

endmodule

