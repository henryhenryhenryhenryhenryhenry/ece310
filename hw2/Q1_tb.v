module Q1_tb;
	reg [2:0]testin;
	wire Y;
	Q1 dut(.A(testin[2]), .B(testin[1]), .C(testin[0]), .Y(Y) );
	
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