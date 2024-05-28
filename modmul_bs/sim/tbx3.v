module tbx3;

   parameter CTLLEN = 32;
   
   reg [9:0] a1;
   wire	     a1s;
   wire	     qs;
   wire [11:0] q;
   
   reg	      reset;
   reg	      clk;
   
   reg [CTLLEN-1:0] ctl;
   wire		    syncl1;
   wire		    syncl2;
   
   piso #(.LEN(10)) PSA1(
			.reset(reset),
			.clk(clk),
			.i(a1),
			.s(a1s),
			.sync(syncl1)
			);
   
   bsx3              DUT(
			 .reset(reset),
			 .clk(clk),
			 .a(a1s),
			 .q(qs),
			 .sync(syncl2)
			 );

   sipo #(.LEN(12)) QSP(
		       .reset(reset),
		       .clk(clk),
		       .i(qs),
		       .s(q),
		       .sync(syncl3)
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
   assign syncl2 = ctl[1];
   assign syncl3 = ctl[2];

   initial 
     begin
        $dumpfile("trace.vcd");
        $dumpvars(0, tbx3);

	reset = 1'b0;	
	a1 = 10'h03FF;

	@(posedge clk) ;
	reset = 1'b1;
		
	@(posedge clk) ;
	reset = 1'b0;

	#1;
			
	repeat (10)
	  begin
	     while (ctl[CTLLEN-1] != 1'b1)
	       @(posedge clk) ;

	     $display("%x %x", a1, q);

	     a1 = a1 + 10'd1;

	     @(posedge clk) ;
	     
	  end // repeat (10)

	$finish;
	
     end
   
endmodule
