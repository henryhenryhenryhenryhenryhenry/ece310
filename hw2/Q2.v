module Q2(In,S,z0,z1);
	input In;
	input S;
	output z0;
	output z1;
	wire w1;

	not n1(w1, S);
	and a1(z0, In, w1);
	and a2(z1, In, S);
	
endmodule

