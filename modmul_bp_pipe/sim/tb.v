module tb;
   reg [4:0]  a;
   reg [4:0]  b;
   wire [4:0] m;
   reg	      reset;
   reg	      clk;
   
   modmul dut(.reset(reset),
	      .clk(clk),
	      .a(a),
	      .b(b),
	      .m(m));

   always
     begin
	clk = 1'b0;
	#5;
	clk = 1'b1;
	#5;
     end
   
   initial
     begin
        $dumpfile("trace.vcd");
        $dumpvars(0, tb);

	a = 5'b0;
	b = 5'b0;
	reset = 1'b1;

	repeat (2)
	  @(posedge clk);

	reset = 1'b0;
	
	while (1) 
	  begin
	     repeat (3)
	       @(posedge clk);
	     
	     #1;
	     $display("%x %x %x", a, b, dut.m);
	     
	     if (dut.m != ((a * b) % 29))
	       $error;

	     a = a + 5'b1;
	     if (a == 5'b0)
	       b = b + 5'b1;
	     
	     if ((a == 5'b0) && (b == 5'b0))
	       $finish;
	  end 
	   
     end
endmodule
