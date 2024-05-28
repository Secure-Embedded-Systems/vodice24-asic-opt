module bssplit
  #(parameter LEN = 5,
    LOG2LEN = 3)
   (input reset,
    input  clk,
    input  a,
    output q1,
    output q2,
    input  isync,
    output osync1,
    output osync2
    );

   // At sync, the first LEN bits go to q1, the rest to q2
   reg [LOG2LEN-1:0] state;
   reg		     osyncreg;
   
   always @(posedge clk)
     if (reset)
       begin
	  state <= 1'b0;
	  osyncreg = 1'b0;
       end
     else
       begin
	  state <= isync ? LEN-1 : (state ? (state - 1) : state);
	  osyncreg <= (state == 1'b1);	  
       end

   assign q1 = (isync | |state) ? a : 1'b0;
   assign q2 = (isync | |state) ? 1'b0 : a;

   assign osync1 = isync;
   assign osync2 = osyncreg;
   
endmodule
   
   
