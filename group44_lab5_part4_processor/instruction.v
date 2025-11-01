module instructiondecode(INSTRUCTION,OPCODE,IMMEDIATE,READREG1,READREG2,WRITEREG,OFFSET);
    input [31:0] INSTRUCTION;
    output reg [7:0] OPCODE,IMMEDIATE,OFFSET;
    output reg [2:0] READREG1,READREG2,WRITEREG;   
    
    always @ (INSTRUCTION) begin

        OPCODE = INSTRUCTION[31:24];
        IMMEDIATE= INSTRUCTION[7:0];
        READREG1=INSTRUCTION[10:8]; // use 3 bit valu for store reg
        READREG2=INSTRUCTION[2:0];
        WRITEREG=INSTRUCTION[18:16];
        OFFSET = INSTRUCTION[23:16];
    end
endmodule