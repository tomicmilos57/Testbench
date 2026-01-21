module cpu_indirect_tb;

wire [9:0] w_led;
reg r_clk;
top #(
  .DIVISOR(1),
  .FILE_NAME("mem_init_indirect.hex"),
  .ADDR_WIDTH(6),
  .DATA_WIDTH(16)
) top_inst (
  .clk(r_clk),
  .rst_n(1'b1),
  .kbd(),
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
  @(top_inst.m_memory.mem[33] === 8) $display("IN A: mem[1] = 8 PASS");
  
  @(top_inst.m_cpu.r_out === 8) $display("OUT A: out = 8 PASS");

  @(top_inst.m_memory.mem[34] === 8) $display("MOV B, A: mem[2] = 8 PASS");
  
  @(top_inst.m_memory.mem[35] === 16) $display("ADD C, A, B: mem[3] = 16 PASS");

  @(top_inst.m_cpu.r_out === 16) $display("OUT C: out = 16 PASS");
  
  @(top_inst.m_memory.mem[36] === 8) $display("IN D: mem[4] = 8 PASS");
  
  @(top_inst.m_memory.mem[35] === 8) $display("SUB C, C, D: mem[3] = 16 - 8 = 8 PASS");
  
  @(top_inst.m_memory.mem[37] === 8) $display("MOV E, C: mem[5] = 8 PASS");
  
  @(top_inst.m_cpu.r_out === 16) $display("OUT E: out = 16 PASS");
  
  @(top_inst.m_memory.mem[37] === 64) $display("MUL E, E, C: mem[5] = 64 PASS");

  @(top_inst.m_cpu.r_out === 64) $display("OUT E: out = 64 PASS");
  
  #0; 
end

initial begin
  #100000
  if (top_inst.m_cpu.r_out == 64)
    $display("PASS: TestBench Finished - PASSED, result = %d", top_inst.m_cpu.r_out);
  else
    $display("FAIL: TestBench Finished - FAILED, result = %d (expected 64)", top_inst.m_cpu.r_out);
  $finish;
end

endmodule
