`timescale 1ns/100ps


module MUX2X1(input1,input2,select,result);
    input [7:0] input1,input2;
    input select;
    output reg  [7:0] result;

    always @ (input1,input2,select) begin
        if(select)begin
            result = input2;
        end
        else begin
            result =input1;
        end
    end

endmodule

/*always @(I0, I1, sel) begin
    case (sel)
      1'b0: Y = I0;
      1'b1: Y = I1; 
      default: Y = 0;
    endcase
    
  end*/
  