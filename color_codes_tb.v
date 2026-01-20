module color_codes_tb;

reg [5:0] r_num = 0;
wire [23:0] w_code;

color_codes dut(
  .num(r_num),
  .code(w_code)
);

function [11:0] map12;
  input [3:0] d;
  begin
    case (d)
      4'd0: map12 = 12'h000;
      4'd1: map12 = 12'hF00;
      4'd2: map12 = 12'hF80;
      4'd3: map12 = 12'hFF0;
      4'd4: map12 = 12'h0F0;
      4'd5: map12 = 12'h0FF;
      4'd6: map12 = 12'h08F;
      4'd7: map12 = 12'h00F;
      4'd8: map12 = 12'hF0F;
      4'd9: map12 = 12'hFFF;
      default: map12 = 12'h000;
    endcase
  end
endfunction

integer i;
reg [23:0] expected;

initial begin
  $display("Color Codes Test Started");
  for (i = 0; i < 10; i = i + 1) begin
    r_num = i;
    #1;
    expected = {map12((i/10)%10), map12(i%10)};
    if (w_code !== expected) begin
      $error("FAIL: input=%0d got=%06h expected=%06h", i, w_code, expected);
      $finish;
    end
  end
  $display("PASS: color_codes mapping correct for 0..9");
  $finish;
end

endmodule

