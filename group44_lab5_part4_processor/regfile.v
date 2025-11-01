module reg_file(IN, OUT1, OUT2, INADDRESS, OUT1ADDRESS, OUT2ADDRESS, WRITE, CLK, RESET);
    input signed [7:0] IN;
    output signed [7:0] OUT1, OUT2;
    input [2:0] INADDRESS, OUT1ADDRESS, OUT2ADDRESS;
    input WRITE, CLK, RESET;

    reg signed [7:0] REGISTER [7:0]; // 8X8 register file
    integer i;

    always @ (posedge CLK ) begin
        if (RESET) begin
            #1
            for (i = 0; i < 8; i = i + 1) begin
                REGISTER[i] = 8'd0;
            end 
        end
        else if (WRITE) begin
            #1 REGISTER[INADDRESS] = IN;
        end
    end

    assign #2 OUT1 = REGISTER[OUT1ADDRESS];
    assign #2 OUT2 = REGISTER[OUT2ADDRESS];
    
endmodule