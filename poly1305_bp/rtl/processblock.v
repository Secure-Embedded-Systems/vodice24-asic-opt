module processblock(input	   reset,
		    input	   clk,
		    input [127:0]  r,
		    input [128:0]  m, // {1, 128 message bits}
		    input [129:0]  a_in, // {acc < P = 2^130 - 5}
		    output [129:0] a_out,
		    input	   start,
		    output	   done
		    );

   wire [130:0]			   m1;
   wire [258:0]			   m2; // 128 bits * 131 bits = 259 bits
   wire [131:0]			   m3; // first reduction leaves 2 extra bits
   wire [129:0]			   m4;
   wire [2:0]			   five;

   assign five = 5;   
   assign m1 = m + a_in;
   assign m2 = m1 * r;
   assign m3 = m2[129:0] + m2[258:130] * five;  // first reduction
   assign a_out = m3[129:0] + m3[131:130] * five;  // second reduction   
   assign done = start;
   
endmodule
