module bsmul
  #(parameter LEN = 5)
   (input  reset,
    input  clk,
    input  a,
    input  [LEN-1:0] b,
    output q,
    input  isync,
    output osync
    );

   wire [(LEN-1):0] product;
   wire [(LEN-1):0] bsadd_b;
   wire [(LEN-1):0] bsadd_q;
   wire [(LEN-1):0] osync_add;
   
   genvar	    i;
   generate
      for (i=0; i<LEN; i = i + 1) begin : addarray
	 
	 assign product[i] = a & b[LEN-i-1];
	 
	 bsadd thisadd(
		       .reset(reset),
		       .clk(clk),
		       .a(product[i]),
		       .b(bsadd_b[i]),
		       .q(bsadd_q[i]),
		       .isync(isync),
		       .osync(osync_add[i])
	       );
	 
	 if (i == 0)
	   assign bsadd_b[i] = 1'b0;
	 else
	   assign bsadd_b[i] = bsadd_q[i-1];	 
			     
      end
   endgenerate

   assign q = bsadd_q[LEN-1];
   assign osync = osync_add[0];
   
endmodule
