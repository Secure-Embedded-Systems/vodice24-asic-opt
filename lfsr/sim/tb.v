module tb;
   reg clk;
   reg reset;  
   wire	q;
   
   lfsr DUT(.clk(clk), 
           .reset(reset), 
           .q(q));

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
	reset = 1'b1;
	repeat(2)
	  @(posedge clk);
	reset = 1'b0;
	repeat (20)
	  begin
	     @(posedge clk);
	     $display("%b", DUT.r1);
	  end
	$finish;
     end

endmodule
