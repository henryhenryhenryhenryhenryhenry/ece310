
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

module mysub64 (out, a, b);
	output [63:0] out;
	input [63:0] a;
	input [63:0] b;
	assign out = a - b;
endmodule

module mymod(A, B, Load, O, Done, Clk);//O = A % B
	input [63:0] A;
	input [63:0] B;
	input Load;
	output reg [63:0] O;
	output reg Done;
	input Clk;

	reg [63:0] A_internal;//large #
	reg [63:0] B_internal;//small #
	reg [63:0] O_internal;
	wire [63:0] O_internal_next;

	//mysub64 U1(O_internal_next, A_internal, O_internal);//Ointnext = Aint - Oint
	mysub64 U1(O_internal_next, O_internal, B_internal);//Ointnext = Oint - Bint

always @ (posedge Clk)
	if (Load) begin
		Done = 0;
		A_internal <= A;
		B_internal <= B;
		O_internal <= A;
	end else begin
		if( O_internal <= B_internal || Done)begin
			Done = 1;
			O = O_internal;
		end else begin
			O_internal = O_internal_next;
			//B_internal = B_internal - 1'b1;
		end
	end	

endmodule

module proj2 (private_key, public_key, message_val, clk, Start, Rst, Cal_done, Cal_val, state);
	input [63:0] private_key;
	input [63:0] public_key;
	input [63:0] message_val;
	input clk;
	input Start;
	input Rst;
	output Cal_done;
	output [63:0] Cal_val;

	output reg [3:0] state;
	reg [63:0] prikey;
	reg [63:0] pubkey;
	reg [63:0] msgval;
	reg [63:0] out;
	reg done;

	reg [63:0] A,B;
	wire [63:0] modO;
	wire [63:0] expO;
	reg modload;
	reg expload;
	wire calcdone;

	assign Cal_val = out;
	assign Cal_done = done;

	myexpo exp(A, B, expload, expO, expcalcdone, clk);
	mymod  mod(A, B, modload, modO, modcalcdone, clk);
	
	//msg ^ prikey % pubkey

always @ (posedge clk)
begin
	if(Rst)
		state <= 4'b0000;
	else
		state <= state;
end

always @ (posedge clk) 
begin
	case(state)
	4'b0000: begin //reset
		prikey <= 0;
		pubkey <= 0;
		msgval <= 0;
		out <= 0;
		done <= 0;
		A <= 0;
		B <= 0;
		modload <= 0;
		expload <= 0;

		state <= 4'b0001;
	end
	4'b0001: begin //capture state
		if(Start) begin
			//Cal_val = 0;
			//Cal_done = 0;
			out <= 0;
			done <= 0;
			prikey <= private_key;
			pubkey <= public_key;
			msgval <=  message_val;
			
			state <= 4'b0010;
		end else begin
			state <= 4'b0001;
		end
	end
	4'b0010: begin //exp state 1 : out = msgval ^ prikey
		A <= msgval;
		B <= prikey;
		expload <= 1;

		state <= 4'b0011;
	end
	4'b0011: begin //exp state 2
		expload <= 0;

		state <= 4'b0100;
	end
	4'b0100: begin //exp state 3
		if(expcalcdone) begin
			state <= 4'b0101;
			out <= expO;
		end else begin
			state <= 4'b0011;
		end
	end
	4'b0101: begin //mod state 1 : out = out % pubkey
		A <= out;
		B <= pubkey;
		modload <= 1;

		state <= 4'b0110;
	end
	4'b0110: begin //mod state 2
		modload <= 0;

		state <= 4'b0111;
	end
	4'b0111: begin //mod state 3
		if(modcalcdone) begin
			state <= 4'b1000;
			out <= modO;
		end else begin
			state <= 4'b0110;
		end
	end
	4'b1000: begin //cal done 1
		done <= 1;
		out <= out;

		state <= 4'b1001;
	end
	4'b1001: begin //cal done 2
		done <= 1;
		out <= out;

		state <= 4'b1010;
	end
	4'b1010: begin //cal done 3
		done <= 1;
		out <= out;

		state <= 4'b0000;
	end
	4'b1011: begin

	end
	4'b1100: begin

	end
	4'b1101: begin

	end
	4'b1110: begin

	end
	4'b1111: begin

	end
	endcase
end

endmodule

module proj2_tb;
	reg [63:0] private_key;
	reg [63:0] public_key;
	reg [63:0] message_val;
	reg clk;
	reg Start;
	reg Rst;
	wire Cal_done;
	wire [63:0] Cal_val;
	wire [3:0] state;

	proj2 dut(private_key, public_key, message_val, clk, Start, Rst, Cal_done, Cal_val, state);

	always
		#5 clk = ~clk;

	initial begin
	$monitor($time, " private key: %d, public key: %d, message: %d, state: %d, done: %b, out: %d", private_key, public_key, message_val, state, Cal_done, Cal_val);


	clk = 0;
	private_key = 3;
	public_key = 33;
	message_val = 9;
	//private key = 7;
	//public key = 33;
	//message_val = 3;
	Rst = 1;
	#6
	Rst = 0;
	#5
	Rst = 0;
	Start = 1;
	#15
	Start = 0;
	
	#500
	//private_key = 3;
	//public_key = 33;
	//message_val = 9;
	private_key = 7;
	public_key = 33;
	message_val = 3;
	Rst = 1;
	#6
	Rst = 0;
	#5
	Rst = 0;
	Start = 1;
	#15
	Start = 0;

	#1000 $finish;
	end




endmodule
