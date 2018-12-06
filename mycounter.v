 module mycounter (clock, in, latch, dec, clear, zero);
/* simple top down counter with zero flag */

input       clock;  /* clock */
input [3:0] in;     /* starting count */
input       latch;  /* latch `in’ when high */
input       dec;    /* decrement count when dec high */
input       clear;  /* clear count when clear high */ 
output      zero;   /* high when count down to zero */

reg [3:0] value;   /* current count value */
reg [3:0] next_value;
wire      zero, enable;

// D-Flip Flops with enable 
always@(posedge clock)
  if (enable) value <= next_value;

// produce enable
assign enable = latch | (dec & !zero) | clear;

// input multiplexor to value register
always@(latch or value or in or dec or zero)
  begin
    if (latch) next_value = in;
    else if (dec && !zero) next_value = value - 1'b1;
    else next_value = 4'b0; // default is clear
  end

// combinational logic to produce `zero’ flag
  assign zero = ~|value;
endmodule /* counter */
