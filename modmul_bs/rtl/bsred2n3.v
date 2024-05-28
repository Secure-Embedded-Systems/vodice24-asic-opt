module bsred2n3
  #(parameter LEN = 5)
  (input reset,
   input  clk,
   input  is,
   output qs,
   input  isync,
   output osync);
   
   wire		      lsb, msb, lsbsync, msbsync;   
   bssplit #(.LEN(LEN), .LOG2LEN(LEN)) bssplit_1 (.reset(reset),
					      .clk(clk),
					      .a(is),
					      .q1(lsb),
					      .q2(msb),
					      .isync(isync),
					      .osync1(lsbsync),
					      .osync2(msbsync)
					      );

   wire	   msbx3, msbx3sync;
   bsx3 bsx3_1 (.reset(reset),
		.clk(clk),
		.a(msb),
		.q(msbx3),
		.isync(msbsync),
		.osync(msbx3sync)
		);

   wire	   lsbalign;
   wdelay #(.LEN(LEN+1)) wdelay_mullsbalign (.reset(reset),
					 .clk(clk),
					 .is(lsb),
					 .qs(lsbalign)
					 );
   
   wire	   qred;
   bsadd qred_bsadd(.reset(reset),
		    .clk(clk),
		    .a(msbx3),
		    .b(lsbalign),
		    .q(qred),
		    .isync(msbx3sync),
		    .osync(osync));
   
   assign qs = qred;

endmodule
