
module receive(DATA, msg_req, sending, dready, dacpt, clock, reset);
   input  [7:0] DATA;
   input 	sending, dready, clock, reset;
   output 	msg_req, dacpt;
   parameter 	RS1=0, RS2=1, RS3=2, other=3;

   reg [1:0] 	state;
   reg [7:0] 	nextdata [0:15];
   reg 		msg_req, dacpt;
   reg [2:0] 	delay;
   reg [3:0] 	addr;

   integer 	i;
   
   always @(posedge clock)
     begin
	if (reset)
	  state=other;
	else
	  case (state)
            RS1: begin
	            msg_req=1;
	            addr=0;
	            state=RS2;
	         end
	    RS2: if (dready)
		   begin
		      nextdata[addr]=DATA;
		      $display($time," Received %h",DATA);
		      addr=addr+1;
		      dacpt=1;
		      state=RS3;
		   end
		 else
		   begin
		      dacpt=0;
		      state=RS2;
		   end // else: !if(dready)
	    RS3: if (sending)
                   begin
	              dacpt=0;
	              state=RS2;
	           end
	         else
	           begin
		      dacpt=0;
		      state=other;
                   end   
	    default:
	      begin
		 delay=$random;
                 $display($time," Receiver delaying for %d cycle(s)",delay);
		 #(10*delay) state=RS1;
	      end
	  endcase // case(state)
     end // always @ (posedge clock)
endmodule // receive

	    

module test;
   reg [7:0] DATA;
   reg        sending, dready, clock, reset;
   wire	      msg_req, dacpt;
   parameter  msg_req_delay=2, sending_delay=12;
   parameter  dready_delay=7, dacpt_delay=4;
   reg [3:0]  msgsize;

   integer    i;
   
   always
     #5 clock=~clock;

   initial
     begin
	$dumpfile("waves.vcd");
	$dumpvars;
	clock=1;
	reset=1;
	sending=0;
	dready=0;
	#15 reset=0;
	#1000 $finish;
     end

   always
     begin
        wait (msg_req)
        #(msg_req_delay) sending=1;
        msgsize=$random;
	if(msgsize == 0)
	begin
		msgsize = 1;
	end

		  //Lab 5 exercise.
		 // message size is randomized. Hence 0 is possibility. We want to avoid that.
		  //hence if msgsize is zero then set it to 1.
		
	$display($time," Transmitter sending %d bytes", msgsize);
	for (i=0; i<msgsize; i=i+1)
	  begin
             DATA=$random;
	     $display($time," Transmitted %h", DATA);
	     dready=1;
	     #(dready_delay) wait (dacpt)
	     #(dacpt_delay) dready=0;
	  end
        sending=0;
        #(sending_delay);	
     end

   receive dut(DATA, msg_req, sending, dready, dacpt, clock, reset);
endmodule // test
