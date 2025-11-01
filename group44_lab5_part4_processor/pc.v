`include "mux2x1_32bit.v"
`include "flowcontrol.v"
`include "signandshift.v"

module pc_unit(CLK,RESET,PC,jump,branch ,ZERO,OFFSET);
    input CLK,RESET;
    output reg [31:0] PC;
    input jump,branch,ZERO;
    wire flowresult;
    input [7:0] OFFSET;
    wire [31:0] NOFFSET;
    wire [31:0] PC_4,PC_TARGET,PCNEXT;
    
    flowcontrol fcontrol(jump,branch,ZERO,flowresult);
    shiftandsign exbit(OFFSET, NOFFSET);
    assign #1 PC_4 = PC+4;
    assign #2 PC_TARGET = (PC+4) + NOFFSET;

    MUX2X1_32BIT mux32(PC_4,PC_TARGET,flowresult,PCNEXT);


    
    always @(posedge CLK) begin
        if (RESET==1'b1) begin
            #1 PC =0;
        end
        else begin
            #1 PC = PCNEXT;
        end
        
    end
endmodule