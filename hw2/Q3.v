module Q3(in, s1, s0, z0, z1, z2, z3);
	input in, s1, s0;
	output z0, z1, z2, z3;
	wire w1, w2;
	
	Q2 demux1(.In(in), .S(s1), .z1(w2), .z0(w1) );
	Q2 demux2(.In(w1), .S(s0), .z1(z1), .z0(z0) );
	Q2 demux3(.In(w2), .S(s0), .z1(z3), .z0(z2) );
	
	




endmodule