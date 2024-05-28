module tb;

   parameter CTLLEN = 64;
   
   reg [4:0] a1;
   wire	     a1s;

   reg [4:0] a2;   
   wire	     qs;

   wire [9:0] q;
   
   reg	      reset;
   reg	      clk;
    
   reg [CTLLEN-1:0] ctl;
   wire		    syncl1;
   wire		    psa1_sync;
   wire		    bsmodmul_sync;   
   wire		    qsp_sync;   
   
   piso #(.LEN(5)) PSA1(
			.reset(reset),
			.clk(clk),
			.i(a1),
			.s(a1s),
			.isync(syncl1),
			.osync(psa1_sync)
			);

   modmul #(.LEN(5)) DUT(
			   .reset(reset),
			   .clk(clk),
			   .a(a1s),
			   .b(a2),
			   .q(qs),
			   .isync(psa1_sync),
			   .osync(bsmodmul_sync)
			 );

   sipo #(.LEN(10)) QSP(
			.reset(reset),
			.clk(clk),
			.i(qs),
			.s(q),
			.isync(bsmodmul_sync),
			.osync(qsp_sync)
		       );
   
   always
     begin
	clk = 1'b0;
	#5;
	clk = 1'b1;
	#5;
     end

   always @(posedge clk)
     begin
	if (reset)
	  ctl <= 1'b1;
	else
	  ctl <= {ctl[CTLLEN-2:0], ctl[CTLLEN-1]};
     end

   assign syncl1 = ctl[0];

   initial 
     begin
        $dumpfile("trace.vcd");
        $dumpvars(0, tb);

	reset = 1'b0;	
	a1 = 5'h1;
	a2 = 5'h10;

	@(posedge clk) ;
	reset = 1'b1;
		
	@(posedge clk) ;
	reset = 1'b0;

	#1;
			
	repeat (10)
	  begin
	     while (ctl[CTLLEN-1] != 1'b1)
	       @(posedge clk) ;

	     $display("%x %x %x", a1, a2, q);

	     if (((a1 * a2) % 29) != q)
	       $error("q %x", q);
	     
	     a1 = a1 + 1'd1;
	     if (a1 == 1'd0)
	       a2 = a2 + 1'd1;

	     @(posedge clk) ;
	     
	  end // repeat (10)

	$finish;
	
     end
   
endmodule
