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
   wire [2:0]   five;
   assign five = 5;   

   assign initialsum = m + a_in;
   assign initialsumred = initialsum[130] ? 
			  initialsum[129:0] + five : 
			  initialsum[129:0];   



   reg [6:0]	ctlstate;
   localparam [6:0] INITSEQ   = 7'd1;
   localparam [6:0] FINALSEQ  = 7'd21;
   
   // controller
   always @(posedge clk)
     begin
	if (reset)
	  ctlstate <= 7'h0;
	else
	  begin
	     ctlstate <= (ctlstate == FINALSEQ) ? 7'h0 :
			 start ? INITSEQ :
			 (ctlstate > 7'h0) ? ctlstate + 7'h1 :
			 ctlstate;
	  end
     end // always @ (posedge clk)

   assign done = (ctlstate == FINALSEQ);
 
   // instruction encoding
   localparam [2:0] ACC_IDLE    = 3'h0;
   localparam [2:0] ACC_W1      = 3'h1;
   localparam [2:0] ACC_W2      = 3'h2;
   localparam [2:0] ACC_W3      = 3'h3;
   localparam [2:0] ACC_W4      = 3'h4;
   localparam [2:0] ACC_CLR     = 3'h5;
   localparam [2:0] MULOP1_IDLE = 3'h0;
   localparam [2:0] MULOP1_W1   = 3'h1;
   localparam [2:0] MULOP1_W2   = 3'h2;
   localparam [2:0] MULOP1_W3   = 3'h3;
   localparam [2:0] MULOP1_W4   = 3'h4;
   localparam	    R_ROT  = 1'b1;
   localparam	    R_IDLE = 1'b0;
   localparam	    M_SHFT = 1'b1;
   localparam	    M_IDLE = 1'b0;

   reg [2:0]	     ins_acc;
   reg [2:0]	     ins_mulop1;
   reg		     ins_r;
   reg		     ins_m;

   // microcode rom
   always @(*)
     begin
	ins_acc = ACC_IDLE;  
	ins_mulop1 = MULOP1_IDLE; 
	ins_r = R_IDLE; 
	ins_m = M_IDLE;
	case(ctlstate) 
	  0:  begin ins_acc = ACC_CLR;  ins_mulop1 = MULOP1_IDLE; ins_r = R_IDLE; ins_m = M_IDLE; end
	  1:  begin ins_acc = ACC_W1;   ins_mulop1 = MULOP1_W1;   ins_r = R_IDLE; ins_m = M_IDLE; end
	  2:  begin ins_acc = ACC_W2;   ins_mulop1 = MULOP1_W2;   ins_r = R_IDLE; ins_m = M_IDLE; end
	  3:  begin ins_acc = ACC_W3;   ins_mulop1 = MULOP1_W3;   ins_r = R_IDLE; ins_m = M_IDLE; end 
	  4:  begin ins_acc = ACC_W4;   ins_mulop1 = MULOP1_W4;   ins_r = R_ROT;  ins_m = M_SHFT; end
	  5:  begin ins_acc = ACC_W1;   ins_mulop1 = MULOP1_W1;   ins_r = R_IDLE; ins_m = M_IDLE; end
	  6:  begin ins_acc = ACC_W2;   ins_mulop1 = MULOP1_W2;   ins_r = R_IDLE; ins_m = M_IDLE; end
	  7:  begin ins_acc = ACC_W3;   ins_mulop1 = MULOP1_W3;   ins_r = R_IDLE; ins_m = M_IDLE; end
	  8:  begin ins_acc = ACC_W4;   ins_mulop1 = MULOP1_W4;   ins_r = R_ROT;  ins_m = M_SHFT; end
	  9:  begin ins_acc = ACC_W1;   ins_mulop1 = MULOP1_W1;   ins_r = R_IDLE; ins_m = M_IDLE; end
	  10: begin ins_acc = ACC_W2;   ins_mulop1 = MULOP1_W2;   ins_r = R_IDLE; ins_m = M_IDLE; end
	  11: begin ins_acc = ACC_W3;   ins_mulop1 = MULOP1_W3;   ins_r = R_IDLE; ins_m = M_IDLE; end
	  12: begin ins_acc = ACC_W4;   ins_mulop1 = MULOP1_W4;   ins_r = R_ROT;  ins_m = M_SHFT; end
	  13: begin ins_acc = ACC_W1;   ins_mulop1 = MULOP1_W1;   ins_r = R_IDLE; ins_m = M_IDLE; end
	  14: begin ins_acc = ACC_W2;   ins_mulop1 = MULOP1_W2;   ins_r = R_IDLE; ins_m = M_IDLE; end
	  15: begin ins_acc = ACC_W3;   ins_mulop1 = MULOP1_W3;   ins_r = R_IDLE; ins_m = M_IDLE; end
	  16: begin ins_acc = ACC_W4;   ins_mulop1 = MULOP1_W4;   ins_r = R_ROT;  ins_m = M_SHFT; end	  
	  17: begin ins_acc = ACC_W1;   ins_mulop1 = MULOP1_W1;   ins_r = R_IDLE; ins_m = M_IDLE; end
	  18: begin ins_acc = ACC_W2;   ins_mulop1 = MULOP1_W2;   ins_r = R_IDLE; ins_m = M_IDLE; end
	  19: begin ins_acc = ACC_W3;   ins_mulop1 = MULOP1_W3;   ins_r = R_IDLE; ins_m = M_IDLE; end
	  20: begin ins_acc = ACC_W4;   ins_mulop1 = MULOP1_W4;   ins_r = R_ROT;  ins_m = M_SHFT; end	  
	  21: begin ins_acc = ACC_IDLE; ins_mulop1 = MULOP1_IDLE; ins_r = R_IDLE; ins_m = M_IDLE; end
	endcase
     end

   // operations on message register and r register   
   always @(posedge clk)
     begin
	if (reset)
	  begin
	     rm       <= 130'h0;
	     rr       <= 128'h0;
	  end
	else
	  begin
	     rm <= start ? initialsumred : 
		   (ins_m == M_SHFT) ? {32'h0, rm[129:32]} :
		   rm;
	     rr <= start ? r : 
		   (ins_r == R_ROT) ? {rr[97:0], 32'b0} + {rr[129:98] * five} :
		   rr;	     
	  end
     end

   // multiplier
   reg [33:0]	mulop1;
   reg [31:0]	mulop2;
   reg [65:0]	mulres;
   
   always @(*)
     mulres = mulop1 * mulop2;

   always @(*)
     begin
	mulop2 = rm[31:0];
	mulop1 = 34'h0;
	case (ins_mulop1)
	  3'h0 : mulop1 = 34'h0;
	  3'h1 : mulop1 = {2'b0,rr[31:0]};
	  3'h2 : mulop1 = {2'b0,rr[63:32]};
	  3'h3 : mulop1 = {2'b0,rr[95:64]};
	  3'h4 : mulop1 = rr[129:96];
	endcase
     end

   // operations on accumulator
   reg [131:0]	acc;
   always @(posedge clk)
     begin
	if (reset)
	  begin
	     acc <= 132'h0;
	  end
	else
	  begin
	     case (ins_acc)
	       ACC_IDLE: acc <= acc;
	       ACC_CLR:  acc <= 132'h0;
	       ACC_W1:   acc <= acc + mulres;
	       ACC_W2:   acc <= acc + {mulres, 32'h0};
	       ACC_W3:   acc <= acc + {mulres, 64'h0};
	       ACC_W4:   acc <= acc + {mulres[33:0], 96'h0} + (mulres[65:34] * five);
	     endcase
	  end 
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

endmodule
