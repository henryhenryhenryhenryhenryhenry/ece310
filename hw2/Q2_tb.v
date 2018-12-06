module Q2_tb;
	reg [1:0]testin;
	wire Y1, Y0;
	Q2 dut(.In(testin[1]), .S(testin[0]), .z1(Y1), .z0(Y0) );
	
	initial begin
		$monitor($time, "  In=%b, S=%b, z1=%b, z2=%b", testin[1],testin[0],Y1,Y0 );
		testin = 2'b00;
		#10;
		testin = 2'b01;
		#10;
		testin = 2'b10;
		#10;
		testin = 2'b11;
		#10;
		
	end
endmodule