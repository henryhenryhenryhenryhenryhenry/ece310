
module transmit(DATA, msg_req, sending, dready, dacpt, clock, reset);
   output [7:0] DATA;
   output 	sending, dready;
   input 	msg_req, dacpt, clock, reset;
   parameter 	TS1=0, TS2=1, TS3=2, other=3;

   reg [1:0] 	state;
   reg [7:0] 	DATA;
   reg [7:0] 	nextdata [0:15];
   reg 		dready, sending;
   reg [2:0] 	delay;
   reg [3:0] 	addr, msgsize;

   integer 	i;
   
   always @(posedge clock)
     begin
	if (reset)
	  state=other;
	else
	  case (state)
	    TS1: if (!msg_req)
	             sending=0;
	         else
	             begin
		         addr=0;
		         sending=1;
			 state=TS2;
	             end
	    TS2: begin
	             DATA=nextdata[addr];
		     $display($time," Transmitted %h",nextdata[addr]);
	             addr=addr+1;
	             dready=1;
	             state=TS3;
	         end
	    TS3: begin
	             dready=0;
                     if (dacpt)
	                 if (addr==msgsize)
		             begin
			         state=other; 
			         sending=0;
		             end
		         else
			     state=TS2;
	             else
                         state=TS3;
                 end
	    default:
	      begin
		 delay=$random;
                 $display($time," Transmitter delaying for %d cycle(s)",delay);
		 #(10*delay) msgsize=$random;
		if(msgsize == 0)
		begin
			msgsize=1;
		end
		 
		 //Lab 5 exercise.
		 // message size is randomized. Hence 0 is possibility. We want to avoid that.
		 //hence if msgsize is zero then set it to 1.
		 
         $display($time," Transmitter sending %d byte(s)",msgsize);
		 for (i=0; i<=msgsize; i=i+1)
		   nextdata[i]=$random;
		 state=TS1;
	      end
	  endcase // case(state)
     end // always @ (posedge clock)
endmodule // transmit

	    

module test;
   wire [7:0] DATA;
   wire       sending, dready;
   reg 	      msg_req, dacpt, clock, reset;
   parameter  msg_req_delay=12, sending_delay=15;
   parameter  dready_delay=23, dacpt_delay=17;
   // Note: if dacpt_delay is less than 10, the transmitter may not notice
   // that dacpt was ever high!
   
   always
     #5 clock=~clock;

   initial
     begin
	clock=1;
	reset=1;
	dacpt=0;
	#15 reset=0;
	#1000 $finish;
     end

   always
     begin
        #(msg_req_delay) msg_req=1;
        wait (sending)
        while (sending)
            begin
                wait (dready) #(dready_delay) 
                $display($time," Received %h",DATA);
                dacpt=1;
                #(dacpt_delay) dacpt=0;
            end
        #(sending_delay) msg_req=0;
     end

   transmit dut(DATA, msg_req, sending, dready, dacpt, clock, reset);
endmodule // test
