module tb;
   reg [127:0]  r;
   reg [127:0]	s;
   reg [127:0]	m;
   reg		fb;   
   reg	        ld;
   reg	        first;
   wire [127:0]	p;
   wire		rdy;
   reg		reset;
   reg		clk;   
   
   poly1305 dut(.reset(reset),
		.clk(clk),
		.r(r),
		.s(s),
		.m(m),
		.fb(fb),
		.ld(ld),
		.first(first),
		.p(p),
		.rdy(rdy));

   always
     begin
	clk = 1'b0;
	#5;
	clk = 1'b1;
	#5;
     end
   
   reg [514:0] inputvector;
   integer     inputfile;

   reg	       tv_firstblock;
   reg	       tv_lastblock;
   reg	       tv_fullblock;
   reg [127:0] tv_data;
   reg [255:0] tv_key;
   reg [127:0] tv_tag;
   reg [127:0] tv_tag_swap;
   
   integer     i;
   
   initial
     begin
        $dumpfile("trace.vcd");
        $dumpvars(0, tb);
	inputfile = $fopen("../../poly1305_tv/vectors.txt","r");

	r = 128'h0;
	s = 128'h0;
	m = 128'h0;
	fb = 1'b0; // fulblock
	ld = 1'b0;
	first = 1'b0;

	reset = 1'b1;
	repeat(3)
	  @(posedge clk);

	reset = 1'b0;
	@(posedge clk);
	
	while ($fscanf(inputfile, "%b", inputvector) != 0)
	  begin

	     {tv_firstblock,
	      tv_lastblock,
	      tv_fullblock,
	      tv_data,
	      tv_key,
	      tv_tag} = inputvector;
//	     $display("---");	     
//	     $display("first %b last %b full %b tag %x", tv_firstblock, tv_lastblock, tv_fullblock, tv_tag);	    
//	     $display("msg %x key %x", tv_data, tv_key);

	     r = 128'b0;
	     s = 128'b0;
	     for (i = 0; i < 16; i = i + 1)
	       begin
		  s = (s << 8) | tv_key[7:0];
		  tv_key = (tv_key >> 8);
	       end
	     for (i = 0; i < 16; i = i + 1)
	       begin
		  r = (r << 8) | tv_key[7:0];
		  tv_key = (tv_key >> 8);
	       end
	     
	     m = 128'b0;
	     for (i = 0; i < 16; i = i + 1)
	       begin
		  m = (m << 8) | tv_data[7:0];
		  tv_data = (tv_data >> 8);
	       end

	     first = tv_firstblock;
	     fb = tv_fullblock;
	     
	     ld = 1'b1;
	     @(posedge clk);

	     #1;
	     
	     while (rdy == 1'b0)
	       begin
		  ld = 1'b0;
		  @(posedge clk);
	       end

	     tv_tag_swap = 128'b0;
	     for (i = 0; i < 16; i = i + 1)
	       begin
		  tv_tag_swap = (tv_tag_swap << 8) | tv_tag[7:0];
		  tv_tag = (tv_tag >> 8);
	       end
	     
	     if ((tv_lastblock == 1'b1) && (p != tv_tag_swap))
	       $error("Expected tag %x but computed %x", tv_tag_swap, p);
	     else  if (tv_lastblock == 1'b1)
	       $display("Tag OK: %x", p);	     
	  end
	
	
	$finish;
     end
	
endmodule
