`timescale  1ns/100ps

module Mux_4x1 (I0, I1, I2, I3, sel, Y);
  //port declaration
  input [7:0] I0, I1, I2, I3; //8 bit inputs
  input[1:0] sel; //2 bit selector
  output reg [7:0] Y; //8 bit output

  //Modify Y, whenever inputs change
  always @(I0, I1, I2, I3, sel) begin
    case (sel)
      2'b00: #1 Y = I0;
      2'b01: #1  Y = I1; 
      2'b10: #1  Y = I2; 
      2'b11: #1  Y = I3; 
      // default: Y = 0;
    endcase
    
  end
endmodule