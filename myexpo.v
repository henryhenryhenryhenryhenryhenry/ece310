
module mymult64 (out, a, b);
	output [63:0] out;
	input [63:0] a;
	input [63:0] b;
	assign out = a * b;
endmodule

module myexpo(A, B, Load, O, Done, Clk);
	input [63:0] A;
	input [63:0] B;
	input Load;
	output reg [63:0] O;
	output reg Done;
	input Clk;

	reg [63:0] A_internal;
	reg [63:0] B_internal;
	reg [63:0] O_internal;
	wire [63:0] O_internal_next;

	mymult64 U1(O_internal_next, A_internal, O_internal);

always @ (posedge Clk)
	if (Load) begin
		Done = 0;
		A_internal <= A;
		B_internal <= B;
		O_internal <= A;
	end else begin
		if( B_internal <= 1 || Done)begin
			Done = 1;
			O = O_internal;
		end else begin
			O_internal = O_internal_next;
			B_internal = B_internal - 1'b1;
		end
	end	

endmodule

module myexpo_tb;

	reg [63:0] A;
	reg [63:0] B;
	reg load;
	wire [63:0] out;
	wire done;
	reg clk;

	myexpo dut(A, B, load, out, done, clk);

	always
		#5 clk = !clk;
	
	initial begin
	clk = 0;
	A = 3;
	B = 5;
	#1
	load = 1;
	#5
	load = 0;
	
	$monitor($time," A=%d, B=%d, load=%b, out=%d, done=%b", A, B, load, out, done);
	
	#100 $finish;	
	end

endmodule
