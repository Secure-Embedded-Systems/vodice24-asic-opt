module bsx3(
	   input  reset,
	   input  clk,
	   input  a,
	   output q,
	   input  isync,
	   output osync);

   wire		  ax2;
   wire		  bsx2_sync;
   
   bsx2 bsx2_1(.reset(reset),
	       .clk(clk),
	       .a(a),
	       .q(ax2),
	       .isync(isync),
	       .osync(bsx2_sync)
	       );

   bsadd bsadd_1(.reset(reset),
		 .clk(clk),
		 .a(a),
		 .b(ax2),
		 .q(q),
		 .isync(bsx2_sync),
		 .osync(osync)
		 );
   
endmodule 
