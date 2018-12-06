module Q3_tb;
	reg [2:0]test;
	wire z0,z1,z2,z3;
	Q3 dut(.in(test[2]), .s1(test[1]), .s0(test[0]), .z0(z0), .z1(z1), .z2(z2), .z3(z3));
	
	initial begin
		$monitor($time, "  in=%b, s1=%b, s0=%b, z0=%b, z1=%b, z2=%b, z3=%b", test[2],test[1],test[0],z0,z1,z2,z3 );
		test = 3'b000;
		
		repeat(7)
		#10 test = test + 1;
		
	end
endmodule