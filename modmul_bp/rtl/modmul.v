module modmul(input        reset,
              input	   clk,
              input [4:0]  a,
              input [4:0]  b,
              output [4:0] m);
   
   // compute (a*b) mod 29

   wire [9:0]		   result;
   wire [6:0]		   sum0;
   wire [5:0]		   sum1;

   assign result = a * b;
   assign sum0 = result[4:0] + result[9:5] + {result[9:5], 1'b0};
   assign sum1 = sum0[4:0] + sum0[6:5] + {sum0[6:5], 1'b0};
   assign m    = ((sum1 - 5'd29) < sum1) ? (sum1 - 5'd29) : sum1;

endmodule
