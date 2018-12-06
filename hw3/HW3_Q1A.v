module Q1A(A,B,C,Y);
	input A;
	input B;
	input C;
	output Y;
	
	assign Y = (~(A&B))^(~((B|C)&(B&C)));
	
endmodule

module Q1A_tb;
	reg [2:0]testin;
	wire Y;
	Q1A dut(.A(testin[2]), .B(testin[1]), .C(testin[0]), .Y(Y) );
	
	initial begin
		$monitor($time, "  A=%b, B=%b, C=%b, Y=%b", testin[2],testin[1],testin[0],Y );
		testin = 3'b000;
		#10;
		testin = 3'b001;
		#10;
		testin = 3'b010;
		#10;
		testin = 3'b011;
		#10;
		testin = 3'b100;
		#10;
		testin = 3'b101;
		#10;
		testin = 3'b110;
		#10;
		testin = 3'b111;
		#10;
	end
endmodule