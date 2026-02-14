module ps2_kbd_model #(
  parameter [15:0] CODE  = 16'h3EF0, //1111 0000 0011 1110
  parameter [31:0] DIVISOR = 5000,
  parameter [31:0] DELAY  = 32'd20000
) (
  input  wire i_clk,
  input  wire i_rst_n,
  input  wire i_request,
  output wire o_ps2_clk,
  output wire o_ps2_data,
  output reg  o_done
);


reg [31:0] r_counter = 0;
reg r_out_clk = 0;

reg [31:0] r_khz_counter = 0;
reg [31:0] r_send_state = 0;
reg r_main_signal = 0;
assign o_ps2_data = r_main_signal;
assign o_ps2_clk = r_out_clk;
always @(posedge r_out_clk) begin
  r_main_signal <= 0;
  o_done <= 0;
  if (r_khz_counter < DELAY) begin
    r_main_signal <= 1;
    r_khz_counter <= r_khz_counter + 1;
    r_send_state <= 0;
  end
  else begin
    o_done <= 1;
    case (r_send_state)
      0: begin
         r_main_signal <= 0;
      end
      1: begin
         r_main_signal <= CODE[0];
      end
      2: begin
         r_main_signal <= CODE[1];
      end
      3: begin
         r_main_signal <= CODE[2];
      end
      4: begin
         r_main_signal <= CODE[3];
      end
      5: begin
         r_main_signal <= CODE[4];
      end
      6: begin
         r_main_signal <= CODE[5];
      end
      7: begin
         r_main_signal <= CODE[6];
      end
      8: begin
         r_main_signal <= CODE[7];
      end
      9: begin
         r_main_signal <= 0; //parity unnecessary
      end
      10: begin
         r_main_signal <= 1; //stop
      end
      11: begin
         r_main_signal <= 1; //just in case
      end
      12: begin
         r_main_signal <= 1; //just in case
      end
      13: begin
         r_main_signal <= 1; //just in case
      end
      //2nd part of the code
      14: begin
         r_main_signal <= 0;
      end
      15: begin
         r_main_signal <= CODE[8];
      end
      16: begin
         r_main_signal <= CODE[9];
      end
      17: begin
         r_main_signal <= CODE[10];
      end
      18: begin
         r_main_signal <= CODE[11];
      end
      19: begin
         r_main_signal <= CODE[12];
      end
      20: begin
         r_main_signal <= CODE[13];
      end
      21: begin
         r_main_signal <= CODE[14];
      end
      22: begin
         r_main_signal <= CODE[15];
      end
      23: begin
         r_main_signal <= 0; //parity unnecessary
      end
      24: begin
         r_main_signal <= 1; //stop
         r_khz_counter <= 0;
      end
    default: begin
    end
    endcase

    r_send_state = r_send_state + 1;
  end

end



always @(posedge i_clk or negedge i_rst_n) begin
  if (!i_rst_n) begin
    r_counter <= 0;
    r_out_clk <= 0;
  end
  else begin
    if (r_counter == (DIVISOR >> 1)) begin
      r_out_clk <= ~r_out_clk;
      r_counter <= 0;
    end
    else begin
      r_counter <= r_counter + 1;
    end
  end
end


endmodule
