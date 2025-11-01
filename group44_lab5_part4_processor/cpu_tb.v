`include "cpu.v"

module cpu_tb;

    reg CLK, RESET;
    wire [31:0] PC;
    reg [31:0] INSTRUCTION;
    
    /* 
    ------------------------
     SIMPLE INSTRUCTION MEM
    ------------------------
    */
    
    // Declare an array of registers (8x1024) named 'instr_mem' to be used as instruction memory
    reg [7:0] instr_mem [1023:0]; // Declares an array of 1024 8-bit registers

    // Create combinational logic to support CPU instruction fetching, given the Program Counter(PC) value 
    // (make sure you include the delay for instruction fetching here)
    always @(PC) begin
        // Combining the 8-bit registers into a 32-bit word
        #2 INSTRUCTION = {instr_mem[PC+3], instr_mem[PC+2], instr_mem[PC+1], instr_mem[PC+0]};
    end

    initial begin
        // Initialize instruction memory with the set of instructions you need execute on CPU
        
        // METHOD 1: manually loading instructions to instr_mem
        //{instr_mem[10'd3], instr_mem[10'd2], instr_mem[10'd1], instr_mem[10'd0]} = 32'b00000000000001000000000000000101;
        //{instr_mem[10'd7], instr_mem[10'd6], instr_mem[10'd5], instr_mem[10'd4]} = 32'b00000000000000100000000000001009;
        //{instr_mem[10'd11], instr_mem[10'd10], instr_mem[10'd9], instr_mem[10'd8]} = 32'b00000010000001100000010000000010;
        
        // METHOD 2: loading instr_mem content from instr_mem.mem file
        $readmemb("instr_mem.mem", instr_mem);
        // $readmemb("instr_mem.mem", instr_mem, 0, 10);

    end
    
    /* 
    -----
     CPU
    -----
    */
    cpu mycpu(PC, INSTRUCTION, CLK, RESET);

    initial begin
        CLK = 1'b0;
        RESET = 1'b0;
        
        // Reset the CPU (by giving a pulse to RESET signal) to start the program execution
        #2
        RESET = 1'b1;
        #4
        RESET = 1'b0;

        // finish simulation after some time
        #500
        $finish;
    end
    
    // clock signal generation
    always
        #4 CLK = ~CLK;


    integer i;
    initial begin
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("cpu_wavedata.vcd");
        $dumpvars(0, cpu_tb);

        // To dump the register file values
        for (i = 0; i < 8; i = i + 1) begin
            $dumpvars(1, cpu_tb.mycpu.cpuregfile.REGISTER[i]);
        end
    end
endmodule
