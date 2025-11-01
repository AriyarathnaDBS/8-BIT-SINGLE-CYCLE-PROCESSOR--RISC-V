`timescale  1ns/100ps
/*
Module  : Data Cache 
Author  : Isuru Nawinne, Kisaru Liyanage
Date    : 25/05/2020

Description	:

This file presents a skeleton implementation of the cache controller using a Finite State Machine model. 
Note that this code is not complete.
*/


`include "mux4x1.v" 


module dcache (
    CLK,
    BUSYWAIT,
    READ,
    WRITE,
    WRITEDATA,
    READDATA,
    ADDRESS,
    RESET,
    mem_busywait,
    mem_read,
    mem_write,
    mem_writedata,
    mem_readdata,
    mem_address
);

    
    input CLK, READ, WRITE, RESET;
    input[7:0] WRITEDATA, ADDRESS;
    output reg BUSYWAIT;
    output reg [7:0] READDATA;
    
    input mem_busywait;
    input [31:0] mem_readdata;
    output reg mem_read, mem_write;
    output reg [31:0] mem_writedata;
    output reg [5:0] mem_address;

    
    
    // cache array
    
    reg V_array[7:0]; 
    reg D_array[7:0];
    reg [2:0] tag_array [7:0];
    reg [31:0] cache_array[7:0];

  
    //Detecting an incoming memory access
    always @(READ, WRITE)
    begin
        if (WRITE || READ) begin
          BUSYWAIT = 1;  
        end
        
    end
    

    //*************************************************************************
    /*
    Combinational part for indexing, tag comparison for hit deciding, etc.
    */
   

    // memory address splitting
    wire [2:0] tag, index;
    wire [1:0] offset;
    
    assign {tag, index, offset} = {ADDRESS[7:5], ADDRESS[4:2], ADDRESS[1:0]};
   
    
    // indexing
    wire valid_bit, dirty_bit;
    wire [2:0] cache_tag;
    wire [31:0] data_block;

    // indexing latency = #1
    // whenever the values in the cache entry changes, the wires will be updated asynchronously
    assign #1 {valid_bit, dirty_bit, cache_tag, data_block} =  {V_array[index], D_array[index], tag_array [index], cache_array[index]};


    
    // hit detection = valid_bit check + tag comparison
    reg tag_comp, hit;

    
    
    always @(*) begin
        if (READ || WRITE) begin
            #0.9 
            tag_comp =  ~(cache_tag ^ tag);
            hit = valid_bit && tag_comp && (READ||WRITE);
        end
    end

    
    // async actions after a miss
    always @(READ, WRITE, hit, dirty_bit) begin
        //If the existing block is not dirty_bit, the missing data block should be fetched from memory. 
        //For this, cache controller should assert the memory READ control signal as soon as the miss is detected.
        if ((hit == 0) && (READ || WRITE) && (dirty_bit == 0)) begin
            mem_read = 1;
            mem_write = 0;
            mem_address = {tag, index};
            mem_writedata = 32'dx;
            BUSYWAIT = 1; 
        end
        // If the existing block is dirty_bit, 
        // that block must be written back to the memory before fetching the missing block. 
        //For this, cache controller should assert the memory WRITE control signal as soon as the miss is detected.
        if ((hit == 0) && (READ || WRITE) && (dirty_bit == 1)) begin
            mem_read = 0;
            mem_write = 1;
            mem_address = {cache_tag, index};
            mem_writedata = data_block;
            BUSYWAIT = 1;  
        end

    end


    
    // data word selection (from the selected block)

    //selection latency = #1 (included inside the mux)
    wire [7:0] selected_word;
    Mux_4x1 dataWordSelectionMux(data_block[31:24], data_block[23:16], data_block[15:8], data_block[7:0], offset, selected_word);

    // if READ and hit, send data to CPU (asynchronously)
    always @(*) begin
        if (READ && !WRITE && hit) begin
            BUSYWAIT = 0;
            READDATA = selected_word; 
        end
    end

    // if WRITE and hit, write the data to the cache at the positive edge of the next cycle
    always @(posedge CLK) begin
        if (!READ && WRITE && hit) begin
            BUSYWAIT = 0;
            V_array[index] = 1;
            D_array[index] = 1;
            
            case (offset)
                2'b00:   cache_array[index][31:24] = #1 WRITEDATA; 
                2'b01:   cache_array[index][23:16] = #1 WRITEDATA; 
                2'b10:   cache_array[index][15:8]  = #1 WRITEDATA; 
                2'b11:   cache_array[index][7:0]   = #1 WRITEDATA; 
            endcase
        end
    end

    /* Cache Controller FSM Start */

    parameter IDLE = 3'b000, MEmem_READ = 3'b001, MEmem_WRITE = 3'b010, UPDATE_CACHE = 3'b011;
    reg [2:0] state, next_state;

    // combinational next state logic
    always @(*)
    begin
        case (state)
            IDLE:
                if ((READ || WRITE) && !dirty_bit && !hit)  
                    next_state = MEmem_READ;
                else if ((READ || WRITE) && dirty_bit && !hit)
                    next_state = MEmem_WRITE;
                else
                    next_state = IDLE;
            
            MEmem_READ:
                if (!mem_busywait)
                    next_state = UPDATE_CACHE;
                else    
                    next_state = MEmem_READ;
            
            MEmem_WRITE:
                if (!mem_busywait)
                    next_state = MEmem_READ;
                else
                    next_state = MEmem_WRITE;

            UPDATE_CACHE:
                next_state = IDLE;
            
        endcase
    end

    // combinational output logic
    always @(state)
    begin
        case(state)
            IDLE:
            begin
                mem_read = 0;
                mem_write = 0;
                mem_address = 8'dx;
                mem_writedata = 32'dx;
                BUSYWAIT = 0;
            end
         
            MEmem_READ: 
            begin
                mem_read = 1;
                mem_write = 0;
                mem_address = {tag, index};
                mem_writedata = 32'dx;
                BUSYWAIT = 1;       
            end

            UPDATE_CACHE: 
            begin
                mem_read = 0;
                mem_write = 0;
                mem_address = 8'dx;
                mem_writedata = 32'dx;
                BUSYWAIT = 1; 
                
                #1
                {V_array[index], D_array[index], tag_array [index], cache_array[index]} = {1'b1, 1'b0, tag, mem_readdata};     
                BUSYWAIT = 0; 
                
            end



            MEmem_WRITE: 
            begin
                mem_read = 0;
                mem_write = 1;
                mem_address = {cache_tag, index};
                mem_writedata = data_block;
                BUSYWAIT = 1;
            end
            
        endcase
    end


    // sequential logic for state transitioning 
    always @(posedge CLK, RESET)
    begin
        if(RESET)
            state = IDLE;
        else
            state = next_state;
    end

    /* Cache Controller FSM End */



    //Reset cache
    integer i;
    always @(posedge CLK)
    begin
        if (RESET)
        begin
            for (i=0;i<8; i=i+1) begin                
                V_array[i] = 0;
                D_array[i] = 0;
                
            end
        end
    end


    
   

endmodule