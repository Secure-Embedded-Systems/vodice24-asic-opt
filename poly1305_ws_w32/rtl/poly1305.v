module poly1305(input          reset,
		input	       clk,
		input [127:0]  r,
		input [127:0]  s,
		input [127:0]  m,
		input	       fb,
		input	       ld,
		input	       first,
		output [127:0] p,
		output	       rdy);
   // fb   ld    first
   // x    x     1      marks the first block of a sequence of blocks
   // 1    1     0      m contains 128 bits of message (and does not include separator byte)
   // 0    1     0      m contains <128 bits of message (and includes separator byte)
   // 0    0     x      processing cycle
   
   reg [129:0]		       acc;
   wire [129:0]		       acc_out;
   wire [129:0]		       acc_in;
   wire			       block_start;
   wire			       block_done;

   wire [128:0]		       msep;
   assign msep = fb ? {1'b1, m} : m;

   assign acc_in = first ? 130'b0 : acc;

   wire [127:0]		       rclamp;

   assign rclamp = r & 128'h0FFF_FFFC_0FFF_FFFC_0FFF_FFFC_0FFF_FFFF;
   
   processblock single(.reset(reset),
		       .clk  (clk),
		       .r    (rclamp),
		       .m    (msep),
		       .a_in (acc_in),
		       .a_out(acc_out),
		       .start(block_start),
		       .done (block_done)
		       );

   always @(posedge clk)
     if (reset)
       acc <= 130'h0;
     else
       acc <= block_done ? acc_out : acc;
   
   assign block_start = ld;
   
   assign p = acc_out + s;
   assign rdy = block_done;
   
endmodule
