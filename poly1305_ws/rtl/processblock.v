module processblock(input	    reset,
		    input	    clk,
		    input  [127:0]  r,
		    input  [128:0]  m, // {1, 128 message bits}
		    input  [129:0]  a_in, // {acc < P = 2^130 - 5}
		    output [129:0]  a_out,
		    input	    start,
		    output	    done
		    );

   reg [131:0]		   rm;
   reg [129:0]		   rr;   
   wire [129:0]		   rr_rotred;

   wire [130:0]		   initialsum;
   wire [129:0]		   initialsumred;
   assign initialsum = m + a_in;
   assign initialsumred = initialsum[130] ? 
			  initialsum[129:0] + 3'h5 : 
			  initialsum[129:0];   
   
   always @(posedge clk)
     begin
	if (reset)
	  begin
	     rm <= 130'h0;
	     rr <= 128'h0;
	  end
	else
	  begin
	     rm <= start ? initialsumred : {32'h0, rm[129:32]};
	     rr <= start ? r : rr_rotred;
	  end
     end

   // sequential modular multiplier
   wire [63:0]  mul0, mul1, mul2;
   wire [65:0]  mul3;   
   assign mul0 = rr[ 31: 0] * rm[31:0];
   assign mul1 = rr[ 63:32] * rm[31:0];
   assign mul2 = rr[ 95:64] * rm[31:0];
   assign mul3 = rr[129:96] * rm[31:0];

   // reduction
   wire [2:0]   five;
   assign five = 5;   
   wire [33:0]	redmul3;
   assign redmul3 = mul3[65:34] * five;   
   assign rr_rotred = {rr[97:0], 32'b0} + {rr[129:98] * five};

   // accumulate
   reg [131:0]	acc;

   always @(posedge clk)
     begin
	if (reset)
	  acc <= 130'h0;
	else
	  acc <= start ?
		 130'b0 : 
		 acc 
		 + mul0 
		 + {mul1, 32'h0} 
		 + {mul2, 64'h0} 
		 + {mul3[33:0], 96'h0}
		 + redmul3;
     end
   
   // final reduction
   reg [129:0] acc_red;
   always @(*)
     case(acc[131:130])
       2'b00: acc_red = acc;
       2'b01: acc_red = acc + 3'h5;
       2'b10: acc_red = acc + 4'ha;
       2'b11: acc_red = acc + 4'hf;
     endcase
   
   assign a_out = acc_red;   
     
   // controller
   reg [5:0]	mulctl;   
   always @(posedge clk)
     begin
	mulctl <= reset ? 6'h0 : {mulctl[4: 0], start};
     end
   assign done = mulctl[5];

endmodule
