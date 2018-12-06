module AROM(addr, aout);
input [3:0] addr;
output reg [7:0] aout;
reg [7:0] MEM [15:0];
always @(addr)
aout <= MEM[addr];
endmodule

module BROM(addr, bout);
input [3:0] addr;
output reg [7:0] bout;
reg [7:0] MEM [15:0];
always @(addr)
bout <= MEM[addr];
endmodule

module myadder(a,b,c);
input [7:0] a;
input [7:0] b;
output [8:0] c;
assign c = a + b;
endmodule



module mycontroller(clock, reset, address);
output reg [3:0] address;
input clock, reset;
reg state;
reg pstate;
parameter S0=1'b0, S1=1'b1;

always @ (posedge clock)
if(reset == 1) 
begin
pstate <= S0;
address <= 0;
end
else
pstate <= state;

always @( pstate )
case(pstate)
S0: begin
state <= S1;
end
S1: begin 
address = address+1;
state <= S0;
end
default:
state <= S0;
endcase

endmodule

module lab5(clock, reset, sum);
output [8:0] sum;
input clock;
input reset;

wire[3:0] address ;
wire[7:0] aout ;
wire[7:0] bout ;

mycontroller d(clock, reset, address);
AROM A1(address, aout);
BROM B1(address, bout);
myadder c(aout, bout, sum);


//create some wires to connect the modules
//based on the names you pick for the wires, adjust the testbench below
// create one instace of each module.
// create one instance of each of the 4 modules.

endmodule

module lab5_tb;
wire [8:0]t_sum;
reg t_reset;
reg t_clock;
lab5 DUT(t_clock, t_reset, t_sum);
always #5 t_clock = ~t_clock;
initial begin
$monitor($time,"Address=%h,A=%h,B=%h,Sum=%h",DUT.address,DUT.aout,DUT.bout, t_sum);
$readmemh("a.dat", DUT.A1.MEM);
$readmemh("b.dat", DUT.B1.MEM);
t_reset = 1;
t_clock = 0;
#7 t_reset = 0;
end
endmodule
