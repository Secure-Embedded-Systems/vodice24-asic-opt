module piso 
  #(parameter LEN = 5)
   (input           reset,
    input	    clk,
    input [LEN-1:0] i,
    output	    s,
    input	    isync,
    output	    osync);
   
   reg [(LEN-1):0]    shiftreg;
   wire [(LEN-1):0]   nextshiftreg;
   reg		      syncreg;
   
   always @(posedge clk)
     begin
	if (reset == 1'b1)
	  begin
	     syncreg <= 1'b0;	     
	     shiftreg <= 1'b0;
	  end	
	else
	  begin
	     shiftreg <= nextshiftreg;
	     syncreg <= isync;
	  end
     end

   assign nextshiftreg = isync ? i : {1'b0, shiftreg[LEN-1:1]};
   assign s = shiftreg[0];
   assign osync = syncreg;
   
endmodule
