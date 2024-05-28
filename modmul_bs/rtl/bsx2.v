module bsx2(
	   input  reset,
	   input  clk,
	   input  a,
	   output q,
	   input  isync,
	   output osync);
   
   reg		  s;

   always @(posedge clk)
     if (reset)
       s <= 1'b0;
     else
       s <= a;

   assign q = isync ? 1'b0 : s;
   assign osync = isync;
   
endmodule
