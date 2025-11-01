
`include "alufile.v"
`include "controlunit.v"
`include "mux2x1.v"
`include "pc.v"
`include "regfile.v"
`include "twoscomp.v"
`include "instruction.v"




module cpu(PC,INSTRUCTION, CLK, RESET);
    input [31:0] INSTRUCTION;
    input CLK,RESET;
    output [31:0] PC;

    

    wire [7:0] OPCODE,IMMEDIATE,OFFSET;
    wire [2:0] READREG1,READREG2,WRITEREG,ALUOP;
    wire WRITEENABLE,isregout,istwocomp;

    wire [7:0] ALURESULT,REGOUT1,REGOUT2,NREGOUT2;
    wire [7:0] m1out,m2out;
    wire branch,jump,ZERO;
    wire [31:0] target;
    wire flowresult;
    wire [31:0] PCCOUNT;

    //decode

    pc_unit mypc(CLK,RESET,PC,jump,branch,ZERO,OFFSET);
    instructiondecode indeco(INSTRUCTION,OPCODE,IMMEDIATE,READREG1,READREG2,WRITEREG,OFFSET);
    control_unit cpucontrol(OPCODE,WRITEENABLE,istwocomp,isregout,jump,branch,ALUOP);//
    reg_file cpuregfile(ALURESULT,REGOUT1,REGOUT2,WRITEREG,READREG1,READREG2, WRITEENABLE, CLK, RESET);//
    twoscomplement cputwoscomp(REGOUT2,NREGOUT2);//
    MUX2X1 mux1(REGOUT2,NREGOUT2,istwocomp,m1out);//
    MUX2X1 mux2(IMMEDIATE,m1out,isregout,m2out);//
    aluunit cpualu(REGOUT1,m2out,ALUOP,ALURESULT,ZERO);//
    
    
endmodule



