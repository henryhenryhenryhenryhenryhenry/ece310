

module receive(DATA, dready, dacpt, clock, reset);
   input [7:0]  DATA;
   input 	dready, clock, reset;
   output 	dacpt;
   parameter 	RS1=0, RS2=1, other=2;

   reg [1:0] 	state;
   reg [7:0] 	nextdata;
   reg 		dacpt;
   reg [2:0] 	delay;
   
   always @(posedge clock)
     begin
	if (reset)
	  state=other;
	else
	  case (state)
	    RS1: if(dready)
		   begin
		      nextdata=DATA;
		      dacpt=1'b1;
	              state=RS2;
		      $display($time," Received %h",nextdata);
		   end
	    RS2: begin
	            dacpt=1'b0;
	            state=other;
		 end
	    default:
	      begin
                 delay=$random;
		 $display($time," Receiver delaying for %d cycles",delay+1);
		 #(10*delay) state=RS1;
	      end
	  endcase // case(state)
     end // always @ (posedge clock)
endmodule // receive

	    

module test;
   reg [7:0]  DATA;
   reg        dready, clock, reset;
   wire	      dacpt;
   reg [4:0]  dacpt_delay, dready_delay;
   
   always
     #5 clock=~clock;

   initial
     begin
        //$shm_open("waves.db");
        //$shm_probe("AS");
	clock=1;
	reset=1;
	dready=0;
	#15 reset=0;
	#300 $finish;
     end

   always
     begin
	dacpt_delay=$random;
        $display($time," Transmitter delaying for %d",dacpt_delay);
	#(dacpt_delay) DATA=$random; dready=1;
        $display($time," Transmitted %h",DATA);
        dready_delay=$random;
        $display($time," Transmitter delaying for %d",dready_delay);
	wait (dacpt) 
        #(dready_delay) dready=0;
        wait (!dacpt);
     end

   receive dut(DATA, dready, dacpt, clock, reset);
endmodule // test
