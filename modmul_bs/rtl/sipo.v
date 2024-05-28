module sipo
  #(parameter LEN = 5)
   (input           reset,
    input	     clk,
    input	     i,
    output [LEN-1:0] s,
    input	     isync,
    output	     osync);

   reg [LEN-1:0]     shiftreg;
   wire              nextshiftreg;
   reg		     syncreg;
   
   reg [LEN-1:0]     q;
   reg [LEN-1:0]     ctr;
   
   always @(posedge clk)
     begin
        if (reset == 1'b1)
	  begin
             shiftreg <= 1'b0;
	     q        <= 1'b0;
	     ctr      <= 1'b0;
	     syncreg  <= 1'b0;	    
	  end
        else
	  begin
             shiftreg <= {nextshiftreg, shiftreg[LEN-1:1]};
	     ctr      <= isync ? LEN :
			 (ctr > 1'b0) ? ctr - 1'b1 :
			 1'b0;
	     q        <= (ctr == 1'b1) ? shiftreg : q;
	     syncreg  <= (ctr == 1'b1);	    
	  end
     end

   assign nextshiftreg = i;
   assign s = q;
   assign osync = syncreg;
   
endmodule
