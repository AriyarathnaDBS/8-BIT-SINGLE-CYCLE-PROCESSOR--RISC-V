module flowcontrol(jump,branch,ZERO,flowresult);
    input jump,branch,ZERO;
    output reg flowresult;
 
    always @ (*) begin
        flowresult = jump | (branch & ZERO);
    end

endmodule

