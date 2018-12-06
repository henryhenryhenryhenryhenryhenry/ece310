module FullAdder1Bit (output sum, output Co, input A, B, Ci);
	assign sum = A ^ B ^ Ci;
	assign Co = (A & B) | (A & Ci) | (B & Ci);
endmodule


module FullAdder4Bit (output [3:0] sum, output Co, input [3:0] A, B, input Ci);
	wire c0, c1, c2;
	FullAdder1Bit u1(sum[0], c0, A[0], B[0], Ci);
	FullAdder1Bit u2(sum[1], c1, A[1], B[1], c0);
	FullAdder1Bit u3(sum[2], c2, A[2], B[2], c1);
	FullAdder1Bit u4(sum[3], Co, A[3], B[3], c2);
	
endmodule

module Q2B (output reg [3:0] O, output reg Co, input reg [3:0] A, B, input reg [1:0] S, input reg Ci );
	wire [3:0] sum;
	wire [3:0] diff;
	wire sumco;
	wire diffco;

	FullAdder4Bit U1(sum, sumco, A, B, Ci);
	FullAdder4Bit U2(diff, diffco, A, ~B, 1'b1);//A-B is compueted by adding A with not(B)+1

	always @*
	begin
		case(S)
			2'b00: 
			begin
			O = sum;     //A+B
			Co = sumco;
			end
			2'b01: 
			begin
			O = diff;    //A-B
			Co = diffco;
			end
			2'b10: 
			begin
			O = A & B;
			Co = 1'b0;
			end
			2'b11:
			begin
			O = A | B;
			Co = 1'b0;
			end
		endcase
	end
endmodule

module Q2B_tb;
	reg [1:0] s;
	reg [3:0] a;
	reg [3:0] b;
	reg ci;
	wire co;
	wire [3:0]o;
	
	Q2B dut(o, co, a, b, s, ci);
	
	initial begin
		$monitor($time, "  S=%b%b, A=%b%b%b%b, B=%b%b%b%b, O=%b%b%b%b, Co=%b ", s[1],s[0], a[3],a[2],a[1],a[0],
																		b[3],b[2],b[1],b[0], o[3],o[2],o[1],o[0], co);
		ci = 1'b0;
		a = 4'b0011;
		b = 4'b0010;
		s = 2'b00;
		#10;
		s = 2'b01;
		#10;
		s = 2'b10;
		#10;
		s = 2'b11;
		#10;
	end


endmodule