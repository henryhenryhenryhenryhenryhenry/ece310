module Q1(A,B,C,Y);
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

