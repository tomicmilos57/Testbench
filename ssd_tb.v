module ssd_tb;

reg [3:0] r_in = 0;
wire [6:0] w_out;

ssd dut(
  .in(r_in),
  .out(w_out)
);

function [6:0] expect;
  input [3:0] v;
  begin
    case (v)
      4'h0: expect = 7'b1000000;
      4'h1: expect = 7'b1111001;
      4'h2: expect = 7'b0100100;
      4'h3: expect = 7'b0110000;
      4'h4: expect = 7'b0011001;
      4'h5: expect = 7'b0010010;
      4'h6: expect = 7'b0000010;
      4'h7: expect = 7'b1111000;
      4'h8: expect = 7'b0000000;
      4'h9: expect = 7'b0010000;
      4'hA: expect = 7'b0001000;
      4'hB: expect = 7'b0000011;
      4'hC: expect = 7'b1000110;
      4'hD: expect = 7'b0100001;
      4'hE: expect = 7'b0000110;
      4'hF: expect = 7'b0001110;
      default: expect = 7'b1111111;
    endcase
  end
endfunction

integer i;
initial begin
  $display("SSD Test Started");
  for (i = 0; i < 16; i = i + 1) begin
    r_in = i[3:0];
    #1;
    if (w_out !== expect(r_in)) begin
      $error("FAIL: in=%h got=%b expected=%b", r_in, w_out, expect(r_in));
      $finish;
    end
  end
  $display("PASS: ssd mapping correct for 0..F");
  $finish;
end

endmodule

