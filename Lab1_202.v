//Declare the ports of Half adder module
module half_adder( A, B, S, C );

    //what are the input ports.
    input A;
    input B;

    //What are the output ports.
    output S;
    output C;
     
     //Implement the Sum and Carry equations using Structural verilog
     xor x1(S,A,B); //XOR operation
     and a1(C,A,B); //AND operation
 
endmodule

//Declare the ports for the full adder module
module full_adder( A, B, Cin, S, Cout);

    //what are the input ports.
    input A;
    input B;
    input Cin;

    //What are the output ports.
    output S;
    output Cout;
    
    wire Sa1, Ca1, Ca2;    
     
     //Two instances of half adders used to make a full adder
     half_adder a1( .A(A),   .B(B),  .S(Sa1),  .C(Ca1));
     half_adder a2( .A(Sa1), .B(Cin),  .S(S),    .C(Ca2));
     or o1(Cout,Ca1,Ca2);

 endmodule

//test bench module
module full_adder_tb;

     reg [2:0]testin;
     wire S, Cout;
     //one instance of full adder used here for testing.
     full_adder dut( .A(testin[2]), .B(testin[1]), .Cin(testin[0]), .S(S), .Cout(Cout));
   
     //Procedural block for testing all possible inputs
     initial begin
     // always put the monitor statement first
      $monitor($time," A=%b,B=%b,Cin=%b,S=%b,Cout=%b",testin[2],testin[1],testin[0],S,Cout );
      testin = 3'b0;

      // display statement - replace with your name
      $display(" Lab 1 202 full adder testbench - Henry Lindbo\n");
      repeat(7)
      #10 testin = testin + 1;

      end
 endmodule
