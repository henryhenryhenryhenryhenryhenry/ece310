module hw7(ain,bin,out, clk);
input [7:0] ain;
input [7:0] bin;
output reg [15:0] out;
wire [15:0] a1,a2,a3,a4,a5,a6,a7,a8, result;
reg [7:0] a,b;
input clk;

reg[7:0] atemp, btemp;
reg[15:0] a1prev,a2prev,a3prev,a4prev;

  always @ ( posedge clk )
   begin
   a <= ain;
   b <= bin;
   atemp <= a;
   btemp <= b;

   a1prev <= a1;
   a2prev <= a2;
   a3prev <= a3;
   a4prev <= a4;

   out  <= result;
   end

//stage 1
assign a1=(b[0]==1'b1) ? {8'b00000000 , a } : 16'b0000000000000000;
assign a2=(b[1]==1'b1) ? {7'b0000000 , a , 1'b0} : 16'b0000000000000000;
assign a3=(b[2]==1'b1) ? {6'b000000 , a , 2'b00} : 16'b0000000000000000;
assign a4=(b[3]==1'b1) ? {5'b00000 , a , 3'b000} : 16'b0000000000000000;

//stage 2 - delayed
assign a5=(btemp[4]==1'b1) ? {4'b0000 , atemp , 4'b0000} : 16'b0000000000000000;
assign a6=(btemp[5]==1'b1) ? {3'b000 , atemp , 5'b00000} : 16'b0000000000000000;
assign a7=(btemp[6]==1'b1) ? {2'b00 , atemp , 6'b000000} : 16'b0000000000000000;
assign a8=(btemp[7]==1'b1) ? {1'b0 , atemp , 7'b0000000} : 16'b0000000000000000;

assign result = a1prev + a2prev + a3prev + a4prev + a5 + a6 + a7 + a8;

endmodule

module hw7_tb;
            reg [7:0] a;
            reg [7:0] b;
            wire [15:0] p;
            reg clk;
            integer delay;

            mult2 dut (a,b,p,clk);
           
          always 
             begin
              #5  clk = !clk;
             end
           
            initial begin
                         clk = 0;
                         #5
                         a = 0;
	                 b = 0;

                         $monitor($time," A=%d,B=%d, Product=%d", a,b,p );
                         repeat (10 )
                         begin 
                         #10
                         a = a + 2; 
                         b = b + 2;  
                         end

                         #10 $finish;
                          
            end 
endmodule
