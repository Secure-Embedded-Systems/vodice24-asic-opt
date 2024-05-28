module wdelay
  #(parameter LEN = 5)
   (input reset,
    input  clk,
    input  is,
    output qs);

   reg [LEN-1:0] r;
   wire [LEN-1:0] nextr;

   genvar	  i;
   generate
      for (i=0; i<LEN; i = i + 1) begin : delayarray
	 always @(posedge clk)
	      if (reset == 1'b1)
		r[i] <= 1'b0;
	      else
		r[i] <= nextr[i];

	 if (i == 0)
	   assign nextr[i] = is;
	 else
	   assign nextr[i] = r[i-1];
      end
   endgenerate

   assign qs = r[LEN-1];

endmodule
