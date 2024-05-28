module modmul(input        reset,
              input	   clk,
              input [4:0]  a,
              input [4:0]  b,
              output [4:0] m);
   
   wire [9:0]		   result;
   reg [9:0]		   resultreg;
   
   wire [6:0]		   sum0;
   reg [6:0]		   sum0reg;

   wire [5:0]		   sum1;
   reg [5:0]		   sum1reg;

   always @(posedge clk)
     if (reset)
       begin
	  resultreg <= 10'b0;
	  sum0reg <= 7'b0;
	  sum1reg <= 6'b0;	  
       end
     else
       begin
	  resultreg <= result;
	  sum0reg <= sum0;
	  sum1reg <= sum1;
       end
   
   assign result = a * b;
   assign sum0 = resultreg[4:0] + resultreg[9:5] + {resultreg[9:5], 1'b0};
   assign sum1 = sum0reg[4:0] + sum0reg[6:5] + {sum0reg[6:5], 1'b0};
   assign m    = ((sum1reg - 5'd29) < sum1reg) ? (sum1reg - 5'd29) : sum1reg;

endmodule
