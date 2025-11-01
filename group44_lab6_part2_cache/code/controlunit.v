`timescale 1ns/100ps



module control_unit(OPCODE,WRITEENABLE,istwocomp,isregout,jump,branch,ALUOP,WRITE,READ,BUSYWAIT,selwrite,STALL);
    input [7:0] OPCODE;
    output reg WRITEENABLE,istwocomp,isregout;
    output reg [2:0] ALUOP;
    output reg jump,branch;
    input BUSYWAIT;
    output reg WRITE,READ,selwrite;
    output reg STALL;

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
	always @(BUSYWAIT) begin
    STALL = BUSYWAIT;

    // if (BUSYWAIT == 1'b0) begin
    //   READ = 1'b0;
    //   WRITE = 1'b0;
    // end
  end

  always @(OPCODE ) begin
    

      #1
      case (OPCODE)
        //loadi instruction
        8'b00000000: begin
          ALUOP = 3'b000;
          isregout = 1'b0;
          istwocomp= 1'b0; // Assign unknown value to Negate
          WRITEENABLE = 1'b1;
          branch = 1'b0;
          jump= 1'b0;
          WRITE = 1'b0;
          READ = 1'b0;
          selwrite = 1'b1;

        end
        //add instruction 
        8'b00000001: begin
          ALUOP = 3'b001;
          isregout = 1'b1;
          istwocomp= 1'b0;
          WRITEENABLE = 1'b1;
          branch = 1'b0;
          jump= 1'b0;
          WRITE = 1'b0;
          READ = 1'b0;
          selwrite = 1'b1;
        end 
        //mov instruction 
        8'b00000010: begin
          ALUOP = 3'b000;
          isregout = 1'b1;
          istwocomp= 1'b0;
          WRITEENABLE = 1'b1;
          branch = 1'b0;
          jump= 1'b0;
          WRITE = 1'b0;
          READ = 1'b0;
          selwrite = 1'b1;
        end
        //sub instruction 
        8'b00000011: begin
          ALUOP = 3'b001;
          isregout = 1'b1;
          istwocomp= 1'b1;
          WRITEENABLE = 1'b1;
          branch = 1'b0;
          jump= 1'b0;
          WRITE = 1'b0;
          READ = 1'b0;
          selwrite = 1'b1;
        end
        //and instruction 
        8'b00000100: begin
          ALUOP = 3'b010;
          isregout = 1'b1;
          istwocomp= 1'b0;
          WRITEENABLE = 1'b1;
          branch = 1'b0;
          jump= 1'b0;
          WRITE = 1'b0;
          READ = 1'b0;
          selwrite = 1'b1;
        end
        //or instruction 
        8'b00000101: begin
          ALUOP = 3'b011;
          isregout = 1'b1;
          istwocomp= 1'b0;
          WRITEENABLE = 1'b1;
          branch = 1'b0;
          jump= 1'b0;
          WRITE = 1'b0;
          READ = 1'b0;
          selwrite = 1'b1;
        end

        //****************************
        //jumpinstruction 
        8'b00000110: begin
          ALUOP = 3'b000; //xxx
          isregout = 1'b0; //x
          istwocomp= 1'b0; //x
          WRITEENABLE = 1'b0; 
          branch = 1'b0;
          jump= 1'b1;
          WRITE = 1'b0;
          READ = 1'b0;
          selwrite = 1'b1;
        end

        //beq instruction 
        8'b00000111: begin
          ALUOP = 3'b001;
          isregout = 1'b1;
          istwocomp= 1'b1;
          WRITEENABLE = 1'b0;
          branch = 1'b1;
          jump= 1'b0;
          WRITE = 1'b0;
          READ = 1'b0;
          selwrite = 1'b1;
        end



        // new instructions 
        //lwd
        8'b00001000: begin
          ALUOP = 3'b000;
          isregout = 1'b1;
          istwocomp= 1'b0;
          WRITEENABLE = 1'b1;
          branch = 1'b0;
          jump= 1'b0;
          WRITE = 1'b0;
          READ = 1'b1;
          selwrite = 1'b0;
        end

        //lwi
        8'b00001001: begin
          ALUOP = 3'b000;
          isregout = 1'b0;
          istwocomp= 1'b1;
          WRITEENABLE = 1'b1;
          branch = 1'b0;
          jump= 1'b0;
          WRITE = 1'b0;
          READ = 1'b1;
          selwrite = 1'b0;
        end

        //swd
        8'b00001010: begin
          ALUOP = 3'b000;
          isregout = 1'b1;
          istwocomp= 1'b0;
          WRITEENABLE = 1'b0;
          branch = 1'b0;
          jump= 1'b0;
          WRITE = 1'b1;
          READ = 1'b0;
          selwrite = 1'b0;
        end

        //swi
        8'b00001011: begin
          ALUOP = 3'b000;
          isregout = 1'b0;
          istwocomp= 1'b0;
          WRITEENABLE = 1'b0;
          branch = 1'b0;
          jump= 1'b0;
          WRITE = 1'b1;
          READ = 1'b0;
          selwrite = 1'b0;
        end
      
      endcase
    
  end 

  
endmodule