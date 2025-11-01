
module Forwardunit(DATA2,RESULT);
    input signed [7:0] DATA2;
    output wire signed [7:0] RESULT;

    assign #1 RESULT =DATA2;

endmodule

module ADDunit(DATA1,DATA2,RESULT);
    input [7:0] DATA1,DATA2;
    output wire [7:0] RESULT;

    assign #2 RESULT= DATA1+DATA2;
endmodule

module ANDunit(DATA1,DATA2,RESULT);
    input [7:0] DATA1,DATA2;
    output wire [7:0] RESULT;

    assign #1 RESULT = DATA1 & DATA2;
endmodule


module ORunit(DATA1,DATA2,RESULT);
    input [7:0] DATA1,DATA2;
    output wire [7:0] RESULT;

    assign #1 RESULT = DATA1 | DATA2;
endmodule

module MUX4X1(I0,I1,I2,I3,SELECT,RESULT);
    input signed  [7:0] I0,I1,I2,I3;
    input [2:0] SELECT;
    output reg signed [7:0] RESULT;

    always @ (I0,I1,I2,I3,SELECT) begin
        case(SELECT)
            3'b000 : RESULT = I0; //fdout
            3'b001 : RESULT = I1; //addout
            3'b010 : RESULT = I2; //andout
            3'b011 : RESULT = I3; //orout
            //default :RESULT = 8'b00000000;
        endcase
    end
endmodule

module aluunit(DATA1, DATA2, SELECT,RESULT,ZERO);
    input signed [7:0] DATA1,DATA2;
    input [2:0] SELECT;
    output signed [7:0] RESULT;
    output reg ZERO;

    output signed [7:0] fdout,andout,addout,orout;

    Forwardunit FORWARD(DATA2,fdout);
    ADDunit ADD(DATA1,DATA2,addout);
    ANDunit AND(DATA1,DATA2,andout);
    ORunit OR(DATA1,DATA2,orout);
    MUX4X1 MUX(fdout,addout,andout,orout,SELECT,RESULT);

    always @(*) begin
        if ((RESULT == 8'b00000000)) begin
            ZERO = 1'b1;
        end
        else begin
            ZERO = 1'b0;
        end
    end


endmodule