module bsadd(
	     input  reset,
	     input  clk,
	     input  a,
	     input  b,
	     output q,
	     input  isync,
	     output osync
	     );

   reg		    carry;
   reg		    qreg;
   reg		    sync;   
   wire		    newcarry;
   wire		    newqreg;
   
   always @(posedge clk)
     begin
	if (reset)
	  begin
	     carry <= 1'b0;
	     qreg <= 1'b0;
	     sync <= 1'b0;	     
	  end
	else
	  begin
	     carry <= newcarry;
	     qreg  <= newqreg;
	     sync <= isync;	     
	  end
     end

   assign {newcarry, newqreg} = a + b + (isync ? 1'b0 : carry);
   assign q = qreg;
   assign osync = sync;

 
endmodule
	    
