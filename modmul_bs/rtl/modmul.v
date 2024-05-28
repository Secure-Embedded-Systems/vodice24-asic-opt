module modmul
  #(parameter LEN = 22)
   (input           reset,
    input	    clk,
    input	    a,
    input [LEN-1:0] b,
    output	    q,
    input	    isync,
    output	    osync
    );

   wire	   mul, mul_sync;
   
   bsmul #(.LEN(LEN)) bsmul_1 (.reset(reset),
			       .clk(clk),
			       .a(a),
			       .b(b),
			       .q(mul),
			       .isync(isync),
			       .osync(mul_sync)
			       );
		    
   wire	   q1, q1_sync;   
   bsred2n3 bsred2n3_1(.reset(reset),
		       .clk(clk),
		       .is(mul),
		       .qs(q1),
		       .isync(mul_sync),
		       .osync(q1_sync)
		       );
   
   wire	   q2, q2_sync;   
   bsred2n3 bsred2n3_2(.reset(reset),
		       .clk(clk),
		       .is(q1),
		       .qs(q2),
		       .isync(q1_sync),
		       .osync(q2_sync)
		       );
   
   wire	   q3, q3_sync, q3_cy;   
   bsaddthree bsaddthree_1(.reset(reset),
			   .clk(clk),
			   .a(q2),
			   .q(q3),
			   .ocarry(q3_cy),
			   .isync(q2_sync),
			   .osync(q3_sync));
   
   wire	   q2stream;   
   wdelay #(.LEN(LEN+1)) q2stream_dly(.reset(reset),
				      .clk(clk),
				      .is(q2),
				      .qs(q2stream));
   
   wire	   q3stream;   
   wdelay #(.LEN(LEN)) q3stream_dly(.reset(reset),
				    .clk(clk),
				    .is(q3),
				    .qs(q3stream));
   
   wdelay #(.LEN(LEN)) q3streamsync_dly(.reset(reset),
					.clk(clk),
					.is(q3_sync),
					.qs(osync));
   
   assign q = q3_cy ? q3stream : q2stream;
   
endmodule
