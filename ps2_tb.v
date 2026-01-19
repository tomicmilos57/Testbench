`timescale 1ns/1ps

module ps2_tb;

reg r_clk = 0;
initial begin
  r_clk = 0;
  forever #5 r_clk = ~r_clk; // 100MHz-ish
end

reg r_rst_n = 0;
reg r_ps2_clk = 1; // idle high
reg r_ps2_data = 1; // idle high
reg r_control = 0;
wire [15:0] w_code;

ps2 dut(
  .i_clk(r_clk),
  .i_rst_n(r_rst_n),
  .i_ps2_clk(r_ps2_clk),
  .i_ps2_data(r_ps2_data),
  .i_control(r_control),
  .o_code(w_code)
);

// Helper task: send a PS/2 byte LSB first with start(0), 8 data bits, parity (ignored), stop(1)
// Each half-cycle is held stable for many i_clk cycles so the debouncer inside the DUT
// can settle and produce clean debounced edges.
task send_byte;
  input [7:0] b;
  integer i;
  integer hold;
  begin
    hold = 12; // number of r_clk posedges to hold each level (>= debouncer threshold)

    // start bit (0)
    r_ps2_data = 0;
    r_ps2_clk = 0; repeat (hold) @(posedge r_clk);
    r_ps2_clk = 1; repeat (hold) @(posedge r_clk); // posedge occurs here

    // data bits LSB first
    for (i = 0; i < 8; i = i + 1) begin
      r_ps2_data = b[i];
      r_ps2_clk = 0; repeat (hold) @(posedge r_clk);
      r_ps2_clk = 1; repeat (hold) @(posedge r_clk);
    end

    // parity (drive 1)
    r_ps2_data = 1;
    r_ps2_clk = 0; repeat (hold) @(posedge r_clk);
    r_ps2_clk = 1; repeat (hold) @(posedge r_clk);

    // stop bit (1)
    r_ps2_data = 1;
    r_ps2_clk = 0; repeat (hold) @(posedge r_clk);
    r_ps2_clk = 1; repeat (hold) @(posedge r_clk);
  end
endtask

initial begin
  $display("PS2 Test Started");

  // reset
  r_rst_n = 0;
  r_ps2_clk = 1; r_ps2_data = 1; r_control = 0;
  repeat(2) @(posedge r_clk);
  r_rst_n = 1;
  @(posedge r_clk);

  // send byte 0x16 (example scancode low byte matching module comments 0xF016 expects 0x16)
  send_byte(8'h16);
  // allow time for stop->update
  repeat(4) @(posedge r_clk);
  #1;
  if (w_code[7:0] !== 8'h16) begin
    $error("FAIL: expected low byte 0x16, got %02h", w_code[7:0]);
    $finish;
  end

  $display("PASS: ps2 basic receive and shift behavior");
  $finish;
end

endmodule

