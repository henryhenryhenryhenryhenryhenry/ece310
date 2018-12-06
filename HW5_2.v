module myadder1(  A, B ,CIN , S , COUT );
       input A,B,CIN;
       output S, COUT;
       assign S = A^B^CIN;
       assign COUT = (A&B) | (CIN&(A^B));
endmodule

module myadder8(A,B,clk,S);
input [7:0] A;
input [7:0] B;

input clk;

output [8:0] S;

reg [7:0] input_to_stage0;
reg  output_of_stage0;
wire tsum0;
wire tcar0;

reg [7:0] input_to_stage1;
reg  output_of_stage1;
wire tsum1;
wire tcar1;

reg [7:0] input_to_stage2;
reg  output_of_stage2;
wire tsum2;
wire tcar2;

reg [7:0] input_to_stage3;
reg  output_of_stage3;
wire tsum3;
wire tcar3;

reg [7:0] input_to_stage4;
reg  output_of_stage4;
wire tsum4;
wire tcar4;

reg [7:0] input_to_stage5;
reg  output_of_stage5;
wire tsum5;
wire tcar5;

reg [7:0] input_to_stage6;
reg  output_of_stage6;
wire tsum6;
wire tcar6;

reg [7:0] input_to_stage7;
reg  output_of_stage7;
wire tsum7;
wire tcar7;

reg [8:0] S;

reg [7:0] tempA0;
reg [7:0] tempB0;
reg [8:0] sum0;

reg [7:0] tempA1;
reg [7:0] tempB1;
reg [8:0] sum1;

reg [7:0] tempA2;
reg [7:0] tempB2;
reg [8:0] sum2;

reg [7:0] tempA3;
reg [7:0] tempB3;
reg [8:0] sum3;

reg [7:0] tempA4;
reg [7:0] tempB4;
reg [8:0] sum4;

reg [7:0] tempA5;
reg [7:0] tempB5;
reg [8:0] sum5;

reg [7:0] tempA6;
reg [7:0] tempB6;
reg [8:0] sum6;

reg [7:0] tempA7;
reg [7:0] tempB7;


always @ (posedge clk)
begin

//capture both A and B
tempA0 <= A;
tempB0 <= B;
input_to_stage0 <= {tempA0[0],tempB0[0],1'b0};
output_of_stage0 <= tcar0;
sum0 <= {8'b0,tsum0};

//move the previous inputs to here.
tempA1 <= tempA0;
tempB1 <= tempB0;
input_to_stage1 <= {tempA1[1],tempB1[1],output_of_stage0};
output_of_stage1 <= tcar1;
sum1 <= {7'b0,tsum1,sum0[0]};

//move the previous inputs to here.
tempA2 <= tempA1;
tempB2 <= tempB1;
input_to_stage2 <= {tempA2[2],tempB2[2],output_of_stage1};
output_of_stage2 <= tcar2;
sum2 <= {6'b0, tsum2,sum1[1:0]};

//move the previous inputs to here.
tempA3 <= tempA2;
tempB3 <= tempB2;
input_to_stage3 <= {tempA3[2],tempB3[2],output_of_stage2};
output_of_stage3 <= tcar3;
sum3 <= {5'b0, tsum3,sum2[2:0]};

//move the previous inputs to here.
tempA4 <= tempA3;
tempB4 <= tempB3;
input_to_stage4 <= {tempA4[2],tempB4[2],output_of_stage3};
output_of_stage4 <= tcar4;
sum4 <= {4'b0, tsum4,sum3[3:0]};

//move the previous inputs to here.
tempA5 <= tempA4;
tempB5 <= tempB4;
input_to_stage5 <= {tempA5[2],tempB5[2],output_of_stage4};
output_of_stage5 <= tcar5;
sum5 <= {3'b0, tsum5,sum4[4:0]};

//move the previous inputs to here.
tempA6 <= tempA5;
tempB6 <= tempB5;
input_to_stage6 <= {tempA6[2],tempB2[2],output_of_stage5};
output_of_stage6 <= tcar6;
sum6 <= {2'b0, tsum6,sum5[5:0]};


//move the previous inputs to here.
tempA7 <= tempA6;
tempB7 <= tempB6;
input_to_stage7 <= {tempA7[2],tempB7[2],output_of_stage6};
output_of_stage7 <= tcar7;
S <= {output_of_stage7, tsum7,sum6[6:0]};



end

    myadder1 fa0 (input_to_stage0[0],input_to_stage0[1],input_to_stage0[2],tsum0, tcar0);
    myadder1 fa1 (input_to_stage1[0],input_to_stage1[1],input_to_stage1[2],tsum1, tcar1);
    myadder1 fa2 (input_to_stage2[0],input_to_stage2[1],input_to_stage2[2],tsum2, tcar2);
    myadder1 fa3 (input_to_stage3[0],input_to_stage3[1],input_to_stage3[2],tsum3, tcar3);
    myadder1 fa4 (input_to_stage4[0],input_to_stage4[1],input_to_stage4[2],tsum4, tcar4);
    myadder1 fa5 (input_to_stage5[0],input_to_stage5[1],input_to_stage5[2],tsum5, tcar5);
    myadder1 fa6 (input_to_stage6[0],input_to_stage6[1],input_to_stage6[2],tsum6, tcar6);
    myadder1 fa7 (input_to_stage7[0],input_to_stage7[1],input_to_stage7[2],tsum7, tcar7);



/*
    myadder1 fa0 (A[0],B[0],1'b0,S[0],C1);
    myadder1 fa1 (A[1],B[1],C1,S[1],C2);
    myadder1 fa2 (A[2],B[2],C2,S[2],C3);
    myadder1 fa3 (A[3],B[3],C3,S[3],C4);
    myadder1 fa4 (A[4],B[4],C4,S[4],C5);
    myadder1 fa5 (A[5],B[5],C5,S[5],C6);
    myadder1 fa6 (A[6],B[6],C6,S[6],C7);
    myadder1 fa7 (A[7],B[7],C7,S[7],S[8]);
*/
endmodule


module HW5_2(A,B, clock, sum);
output reg [8:0] sum;
input clock;
input [7:0]A,B;
reg [7:0] a_temp;
reg [7:0] b_temp;
wire [8:0] sum_temp;

always @ (posedge clock)
begin
a_temp <= A;
b_temp <= B;
sum <= sum_temp;
end

myadder8 MA1(a_temp,b_temp, clock, sum_temp);


endmodule

module HW5_2_tb;
wire [8:0]t_sum;
reg t_clock;
reg [7:0] a_temp;
reg [7:0] b_temp;

HW5_2 DUT(a_temp,b_temp,t_clock, t_sum); //was called pp1, fixed
always #5 t_clock = ~t_clock;
initial begin
$monitor($time,"A=%h,B=%h,Sum=%h",a_temp, b_temp, t_sum);
t_clock = 0;
a_temp = 0;
b_temp = 0;
repeat(20)
begin
#10
a_temp = a_temp+1;
b_temp = b_temp+1;
end
#200 $finish;
end
endmodule
