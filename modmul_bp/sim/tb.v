module tb;
   reg [4:0] a;
   reg [4:0] b;
   wire [4:0] m;

   modmul dut(.reset(),
	      .clk(),
	      .a(a),
	      .b(b),
	      .m(m));

   initial
     begin
        $dumpfile("trace.vcd");
        $dumpvars(0, tb);

	a = 5'b0;
	b = 5'b0;

	while (1) 
	  begin
	     #10;
	     
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
