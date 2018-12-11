module Lfsr5(seed, load, loutput, clock);
   output reg [4:0] loutput;
   input [4:0] seed;
   input load, clock;	

   always @ (posedge clock)
      if(load) begin
         if( |seed )
            loutput <= seed;
         else
            loutput <= 5'b00001;
      end else begin
         //loutput <= {loutput[3], loutput[2], loutput[1], loutput[0], loutput[4]^loutput[1]};
         loutput[4] <= loutput[3];
         loutput[3] <= loutput[2];
         loutput[2] <= loutput[1];
         loutput[1] <= loutput[0];
         loutput[0] <= loutput[4]^loutput[1];
      end

endmodule

module Lfsr5_tb;
   wire [4:0] out;
   reg [4:0] seed;
   reg load, clk;

   Lfsr5 dut (seed, load, out, clk);

   always
         #5 clk = !clk;

   initial begin
      clk = 0;
      seed = 5'b10101;
      #1
      load = 1;
      #5
      load = 0;
      
      $monitor($time," out = %b",out);

      #95 $finish;
   end

endmodule
