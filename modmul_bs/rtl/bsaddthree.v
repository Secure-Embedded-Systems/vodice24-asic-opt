module bsaddthree(
	     input  reset,
	     input  clk,
	     input  a,
	     output q,
	     input  isync,
	     output osync,
	     output ocarry
	     );

   reg		    carry;
   reg		    qreg;
   reg		    sync;   
   wire		    newcarry;
   wire		    newqreg;

   reg [4:0]	    breg;

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
	     sync  <= isync;
	     breg  <= isync ? 5'b10001 : {breg[4], breg[4:1]};
	  end
     end

   // this dedicated expression adds -3 (0b..11100011) to the bitserial input
   assign {newcarry, newqreg} = a + (isync ? 1'b1 : breg[0]) + (isync ? 1'b0 : carry);
   assign q = qreg;
   assign osync = sync;
   assign ocarry = carry;
   
endmodule
	    
