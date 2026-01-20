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

integer current_test = 0;
initial forever begin
  #10;
  case (current_test)
    0: begin
      if (top_inst.m_memory.mem[1] == 8) begin
        $display("IN A: mem[1] = 8 PASS");
        current_test = current_test + 1;
      end
    end
    1: begin
      if (top_inst.m_memory.mem[2] == 8) begin
        $display("MOV B, A: mem[2] = 8 PASS");
        current_test = current_test + 1;
      end
    end
    2: begin
      if (top_inst.m_memory.mem[3] == 16) begin
        $display("ADD C, A, B: mem[3] = 16 PASS");
        current_test = current_test + 1;
      end
    end
    3: begin
      if (top_inst.m_memory.mem[4] == 8) begin
        $display("IN D: mem[4] = 8 PASS");
        current_test = current_test + 1;
      end
    end
    4: begin
      if (top_inst.m_memory.mem[3] == 8) begin
        $display("SUB C, C, D: mem[3] = 16 - 8 = 8 PASS");
        current_test = current_test + 1;
      end
    end
    5: begin
      if (top_inst.m_memory.mem[5] == 8) begin
        $display("MOV E, C: mem[5] = 8 PASS");
        current_test = current_test + 1;
      end
    end
    6: begin
      if (top_inst.m_memory.mem[5] == 64) begin
        $display("MUL E, E, C: mem[5] = 64 PASS");
        current_test = current_test + 1;
      end
    end
    2: begin
      if (top_inst.m_memory.mem[3] == 16) begin
        $display("ADD C, A, B: mem[3] = 16 PASS");
        current_test = current_test + 1;
      end
    end
    default: begin
    end
  endcase
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
