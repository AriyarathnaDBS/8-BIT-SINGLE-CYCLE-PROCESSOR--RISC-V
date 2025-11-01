module control_unit(OPCODE,WRITEENABLE,istwocomp,isregout,jump,branch,ALUOP);
    input [7:0] OPCODE;
    output reg WRITEENABLE,istwocomp,isregout;
    output reg [2:0] ALUOP;
    output reg jump,branch;

    /* OP-CODE DEIFINITIONS
	Change these according to op-codes assigned in your processor architecture 
	************************************************************************
	char *op_loadi 	= "00000000";
	char *op_add 	= "00000001";
	char *op_mov 	= "00000010";
	char *op_sub 	= "00000011";
	char *op_and 	= "00000100";
	char *op_or 	= "00000101";
	char *op_j		= "00000110";
	char *op_beq	= "00000111";
	char *op_lwd 	= "00001000";
	char *op_lwi 	= "00001001";
	char *op_swd 	= "00001010";
	char *op_swi 	= "00001011";
	************************************************************************/
	

  always @ (OPCODE) begin
    case(OPCODE)
        //loadi
        8'b00000000: begin
            WRITEENABLE = 1'b1;
            istwocomp = 1'b0;
            isregout = 1'b0; 
            ALUOP = 3'b000;
            jump = 1'b0;
            branch = 1'b0;
        end

        

        //add
        8'b00000001: begin
            
            WRITEENABLE = 1'b1;
            istwocomp = 1'b0;
            isregout = 1'b1; 
            ALUOP = 3'b001;
            jump = 1'b0;
            branch = 1'b0;
        end

        //mov
        8'b00000010: begin
            WRITEENABLE = 1'b1;
            istwocomp = 1'b0;
            isregout = 1'b1; 
            ALUOP = 3'b000;
            jump = 1'b0;
            branch = 1'b0;
        end
        
        //sub
        8'b00000011: begin
            WRITEENABLE = 1'b1;
            istwocomp = 1'b1;
            isregout = 1'b1; 
            ALUOP = 3'b001;
            jump = 1'b0;
            branch = 1'b0;
        end

        //and
        8'b00000100: begin
            WRITEENABLE = 1'b1;
            istwocomp = 1'b0;
            isregout = 1'b1; 
            ALUOP = 3'b010;
            jump = 1'b0;
            branch = 1'b0;
        end

        //or
        8'b00000101: begin
            WRITEENABLE = 1'b1;
            istwocomp = 1'b0;
            isregout = 1'b1; 
            ALUOP = 3'b011;
            jump = 1'b0;
            branch = 1'b0;
        end

        //j
        8'b00000110: begin
            WRITEENABLE = 1'b0;
            istwocomp = 1'b0;
            isregout = 1'b0; 
            ALUOP = 3'b000;
            jump = 1'b1;
            branch = 1'b0;
        end

        //beq
        8'b00000111: begin
            WRITEENABLE = 1'b0;
            istwocomp = 1'b1;
            isregout = 1'b1; 
            ALUOP = 3'b001;
            jump = 1'b0;
            branch = 1'b1;
        end

        /*default: begin
            WRITEENABLE = 1'b0;
            istwocomp = 1'b0;
            isregout = 1'b0; 
            ALUOP = 3'b000;
            jump = 1'b0;
            branch = 1'b0;
        end*/
    endcase
  end
endmodule