
module transmit(DATA, dready, dacpt, clock, reset);
   output [7:0] DATA;
   output 	dready;
   input 	dacpt, clock, reset;
   parameter 	TS1=0, TS2=1, other=2;

   reg [1:0] 	state;
   reg [7:0] 	DATA, nextdata;
   reg 		dready;
   reg [2:0] 	delay;
   
   always @(posedge clock)
     begin
	if (reset)
	  state=other;
	else
	  case (state)
	    TS1: if (!dacpt)
	           begin
               DATA=nextdata;
	           dready=1'b1;
		      state=TS2;
		      $display($time," Transmitted %h",nextdata);
	           end
	    TS2: if(dacpt)
		   begin
		      dready=1'b0;
	              state=other;
		   end
	    default:
	      begin
		 delay=$random;
                 $display($time," Transmitter delaying for %d cycles",delay+1);
		 #(10*delay) nextdata=$random;
		 state=TS1;
	      end
	  endcase // case(state)
     end // always @ (posedge clock)
endmodule // transmit

	    

module test;
   wire [7:0] DATA;
   wire       dready;
   reg 	      dacpt, clock, reset;
   reg [4:0]  dready_delay, dacpt_delay;
   
   always
     #5 clock=~clock;

   initial
     begin
	clock=1;
	reset=1;
	dacpt=0;
	#15 reset=0;
	#300 $finish;
     end

   always
     begin
        wait (dready) dready_delay=$random;
        $display($time," Receiver delaying for %d",dready_delay);
	#(dready_delay) $display($time," Received %h",DATA);
	dacpt=1;
	dacpt_delay=$random;
        $display($time," Receiver delaying for %d",dacpt_delay);
	#(dacpt_delay) dacpt=0;
     end

   transmit dut(DATA, dready, dacpt, clock, reset);
endmodule // test
