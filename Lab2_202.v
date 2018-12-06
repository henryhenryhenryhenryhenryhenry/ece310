//Lab2 module
module Lab2Module( A, B, C );

    //what are the input ports.
    input [31:0]A;
    input [31:0]B;

    //What are the output ports.
    output reg [31:0]C;
     
    always @(A,B)
    begin
    //C = 4'h5;

// step 1) Init C to zero
	C = 0;
// step 2) set C[1:0] to the bitwise and of A[1:0] and B[1:0]
	C[1:0] = A[1:0] & B[1:0];
// step 3) set C[3:2] to the bitwise or of A[3:2] or B[3:2]
	C[3:2] = A[3:2] | B[3:2];
// step 4) set C[5:4] to the bitwise xor of A[5:4] xor B[5:4]
	C[5:4] = A[5:4] ^ B[5:4];
// step 5) set C[7:6] to negation of  A[7:6]
	C[7:6] = ~A[7:6];
// step 6) set C[9:8] to negation of  B[7:6]
	C[9:8] = ~B[7:6];
// step 7) set C[10] to xor reduction of A
	C[10] = ^A;
// step 8) set C[11] to and reduction of A
	C[11] = &A;
// step 9) set C[12] to or reduction of A
	C[12] = |A;
// step 10) set C[13] to not of xor reduction of B
	C[13] = ~^B;
// step 11) set C[14] to not of and reduction of B
	C[14] = ~&B;
// step 12) set C[15] to not of or reduction of B
	C[15] = ~|B;
// step 13) left shift C by 3 bits
	C = C<<3;
// step 14) if A and B are true set C[0] to 1 else 0
	C[0] = A&&B;
// step 15) if A or B are true set C[1] to 1 else 0
	C[1] = A||B;
// step 16) using concatinate operator set C[31:24] to A[31:28],B[31:28]
	C[31:24] = {A[31:28],B[31:28]};

    end
 
endmodule


//test bench module
module Lab2Module_tb;

     reg [31:0]t_a;
     reg [31:0]t_b;
     wire[31:0] t_c;

       Lab2Module dut( .A(t_a), .B(t_b), .C(t_c));
       initial begin
       t_a = 32'h55555555;
       t_b = 32'hAAAAAAAA;
       // display statement - replace with your name
      #10 $display(" Kamal Final value of C is = %h\n",t_c);
      end
 endmodule