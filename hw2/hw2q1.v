module circuit(A,B,C,Y);
	input A;
	input B;
	input C;
	output Y;
	wire w1, w2, w3, w4;
	
	nand n1(w1, A, B);
	or o1(w2, B, C);
	and a1(w3, B, C);
	nand n2(w4, w2, w3);
	xor x1(Y, w4, w1);
	
endmodule

module circuit_tb;
	reg [2:0]testin;
	wire Y;
	circuit dut(.A(testin[2]), .B(testin[1]), .C(testin[0]), .Y(Y) );
	
	initial begin
		$monitor($time, "  A=%b, B=%b, C=%b, Y=%b", testin[2],testin[1],testin[0],Y );
		testin = 3'b101;
		#10;
		testin = 3'b011;
		#10;
		testin = 3'b111;
		#10;
		testin = 3'b001;
		#10;
		testin = 3'b100;
		#10;
		testin = 3'b010;
		#10;
		testin = 3'b111;
		#10;
		testin = 3'b001;
		#10;
		testin = 3'b101;
		#10;
		
	end
endmodule