module lfsr(input clk, 
	    input  reset, 
	    output q);   
   reg [3:0]	   r1;
   wire [3:0]	   nextr1;

  always @(posedge clk)
    if (reset)
      r1 <= 4'b1;
    else
      r1 <= nextr1;
   
   assign nextr1 = {r1[0],r1[0]^r1[3],r1[2],r1[1]};   
   assign q = r1[0];
   
endmodule
