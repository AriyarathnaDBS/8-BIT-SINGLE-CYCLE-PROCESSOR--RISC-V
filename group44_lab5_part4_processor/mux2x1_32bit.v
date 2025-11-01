module MUX2X1_32BIT(input1,input2,select,result);
    input [31:0] input1,input2;
    input select;
    output reg  [31:0] result;

    always @ (input1,input2,select) begin
        if(select==1'b1)begin
            result = input2;
        end
        else begin
            result =input1;
        end
    end

endmodule