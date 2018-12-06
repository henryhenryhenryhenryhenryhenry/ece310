
module myadder1(  A, B ,CIN , S , COUT );
       input A,B,CIN;
       output S, COUT;
       assign S = A^B^CIN;
       assign COUT = (A&B) | (CIN&(A^B));
endmodule

module myadder8(A,B,S,clk);
input [2:0] A;
input [2:0] B;
output [3:0] S;
input clk;

reg [2:0] input_to_stage0;
reg  output_of_stage0;
wire tsum0;
wire tcar0;

reg [2:0] input_to_stage1;
reg  output_of_stage1;
wire tsum1;
wire tcar1;

reg [2:0] input_to_stage2;
reg  output_of_stage2;
wire tsum2;
wire tcar2;

reg [3:0] S;

reg [2:0] tempA0;
reg [2:0] tempB0;
reg [3:0] sum0;

reg [2:0] tempA1;
reg [2:0] tempB1;
reg [3:0] sum1;

reg [2:0] tempA2;
reg [2:0] tempB2;

always @ (posedge clk)
begin

//capture both A and B
tempA0 <= A;
tempB0 <= B;
input_to_stage0 <= {tempA0[0],tempB0[0],1'b0};
output_of_stage0 <= tcar0;
sum0 <= {3'b0,tsum0};

//move the previous inputs to here.
tempA1 <= tempA0;
tempB1 <= tempB0;
input_to_stage1 <= {tempA1[1],tempB1[1],output_of_stage0};
output_of_stage1 <= tcar1;
sum1 <= {2'b0,tsum1,sum0[0]};

//move the previous inputs to here.
tempA2 <= tempA1;
tempB2 <= tempB1;
input_to_stage2 <= {tempA2[2],tempB2[2],output_of_stage1};
output_of_stage2 <= tcar2;
S <= {output_of_stage2, tsum2,sum1[1:0]};


end

    myadder1 fa0 (input_to_stage0[0],input_to_stage0[1],input_to_stage0[2],tsum0, tcar0);
    myadder1 fa1 (input_to_stage1[0],input_to_stage1[1],input_to_stage1[2],tsum1, tcar1);
    myadder1 fa2 (input_to_stage2[0],input_to_stage2[1],input_to_stage2[2],tsum2, tcar2);

endmodule


module pipelined_3bit_adder(A,B, clock, sum);
output reg [3:0] sum;
input clock;
input [2:0]A,B;
reg [2:0] a_temp;
reg [2:0] b_temp;
wire [3:0] sum_temp;

always @ (posedge clock)
begin
a_temp <= A;
b_temp <= B;
sum <= sum_temp;
end

myadder8 MA1(a_temp,b_temp,sum_temp,clock);


endmodule

module pipelined_3bit_adder_tb;
wire [3:0]t_sum;
reg t_clock;
reg [2:0] a_temp;
reg [2:0] b_temp;

pipelined_3bit_adder DUT(a_temp,b_temp,t_clock, t_sum);
always #5 t_clock = ~t_clock;
initial begin
$monitor($time,"A=%h,B=%h,Sum=%h",a_temp, b_temp, t_sum);
t_clock = 0;
a_temp = 0;
b_temp = 0;
repeat(5)
begin
#10
a_temp = a_temp+1;
b_temp = b_temp+1;
end
#200 $finish;
end
endmodule
