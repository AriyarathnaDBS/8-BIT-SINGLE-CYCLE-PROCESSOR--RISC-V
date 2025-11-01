## CO224 – Computer Architecture
# Lab 5 – Building a Simple 8-bit Single-Cycle Processor

This repository contains the Verilog implementation and testbenches for Lab 5: Building a Simple Processor in CO224 – Computer Architecture, Department of Computer Engineering, University of Peradeniya.
The lab guides the development of a simple 8-bit single-cycle processor that supports arithmetic, logical, move, load-immediate, jump, and branch-equal instructions. The processor is built in four parts: ALU, Register File, CPU Integration, and Flow Control Instructions, with an optional extended ISA.

## Project Overview
The processor follows a single-cycle architecture, executing each instruction within one clock cycle (8 time units). Instructions follow a 32-bit fixed-length format:
- [31–24] OP-CODE  
- [23–16] RD / IMM  
- [15–8]  RT  
- [7–0]   RS / IMM  

## Supported Instructions
- Arithmetic & Logic: add, sub, and, or
- Move & Immediate: mov, loadi
- Control Flow: j, beq
- Extended instructions: mult, sll, srl, sra, ror
  
## Part 1 – ALU 
Implements an 8-bit ALU supporting:
Features
- Three-bit control signal SELECT (ALUOP).
- Separate modules for each functional unit.
- Realistic hardware delays (#1 or #2).
- MUX-based result selection.
- Thoroughly tested with Verilog testbench and GTKWave.

## Part 2 – Register File 
Implements an 8×8 register file:
8 registers × 8 bits each
Ports:
  - IN (8-bit write data)
  - OUT1, OUT2 (8-bit read outputs)
  - INADDRESS, OUT1ADDRESS, OUT2ADDRESS (3-bit selectors)
  - WRITE control signal
  - CLK, RESET

Features:
  - Asynchronous register read (#2 delay)
  - Synchronous write (#1 delay)
  - Synchronous reset (#1 delay)
  - Thorough testing using a custom testbench + GTKWave

## Part 3 – CPU Integration
Integrates ALU + Register File + Control Logic to form a working CPU.
Components
  - Instruction Fetching using hardcoded memory array (in testbench)
Program Counter (PC) with:
  - PC update delay: #1
  - PC + 4 adder delay: #1
  - Instruction Decode (#1 delay)
  - Two’s complement unit for subtraction (#1 delay)
Full control logic
  - ALU and register file timing coordination
  - Support for: add, sub, and, or, mov, loadi
Programs assembled using the CO224Assembler and loaded into testbench memory.

## Part 4 – Flow Control Instructions 
Adds microarchitectural support for:
- jump (j)
- branch if equal (beq)
- Additions
- ALU updated with ZERO flag
- Added branch/jump target adder (#2 delay)
- Modified control logic for PC redirection

## Part 5 – Extended ISA (Optional Bonus 20 marks)
Optional implementation of additional instructions such as:
- mult, sll, srl, sra, ror, bne
Requirements:
- Must share ALU functional units
- Must complete within 8 time units
- Custom function units — no built-in shift/multiply operators
- Must provide documentation and timing assumptions

## How to Run Simulations

1. Compile Verilog Files

Using Icarus Verilog:

iverilog -o alu_tb part1_alu/*.v
vvp alu_tb

2. View Waveforms
gtkwave dump.vcd

3. Run CPU Programs
iverilog -o cpu_tb part3_cpu/*.v
vvp cpu_tb

Instruction memory must be defined in the testbench (256 instructions max).

## Tools Used
- Verilog HDL
- Icarus Verilog / ModelSim
- GTKWave – waveform viewer
- CO224Assembler – converts assembly → machine code
