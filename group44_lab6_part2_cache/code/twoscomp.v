`timescale 1ns/100ps


module twoscomplement(in,out);
    input [7:0] in;
    output reg signed  [7:0] out;
    always @ (in) begin
        #1 out = ~in +1;
    end
endmodule

//or, assign out = ~in + 1;   //remove reg part from out