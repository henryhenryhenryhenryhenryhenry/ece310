module mult1 (out, a, b, clk);
output reg [15:0] out;
	input  [7:0] a;
	input  [7:0] b;
	input clk;
	reg [7:0] aqq,bqq;
	wire [15:0] result;
	
  always @ ( posedge clk )
   begin
   aqq <= a;
   bqq <= b;
   out  <= result;
   end
	
	assign result  = aqq * bqq;

endmodule