module shiftandsign(OFFSET, NOFFSET);
    input [7:0] OFFSET;
    output [31:0] NOFFSET;
    

    
    wire [31:0] extended_offset;
    assign extended_offset = {{24{OFFSET[7]}}, OFFSET};

    // Multiply the extended offset by 4 (equivalent to left-shifting by 2 bits)
    
    assign NOFFSET = extended_offset << 2;

endmodule