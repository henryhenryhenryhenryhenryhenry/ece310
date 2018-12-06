

module transmit(MSG, msgrdy, send, drdy, dacp, clock, reset);
   output [7:0] MSG; //DATA
   output 	msgrdy, drdy; //sending, dready
   input 	send, dacp; //msg_req, dacpt
   input 	clock, reset; //clock, reset
   parameter 	TS1=0, TS2=1, TS3=2, TS4=3, TS5=4, TS6=5, TS7=6, other=7;
   parameter    delay=4;

   reg [2:0] 	state; //state
   reg [7:0] 	MSG; //DATA
   reg [7:0] 	nextdata [0:9]; //nextdata
   reg 		msgrdy, drdy; // sending, dready
   reg [3:0] 	addr; //addr

   integer 	i; //i
   
   always @(posedge clock)
     begin
	if (reset)
	  state=other;
	else
	  case (state)
	    
        // Complete the code for Transmiter
		TS1: begin
			if(!send)
				msgrdy=0;
			else
				begin
				addr = 0;
				msgrdy = 1;
				state = TS2;
				end
		end
		TS2: begin
			MSG = nextdata[addr];
			$display($time," transmitted %h",nextdata[addr]);
			addr=addr+1;
			drdy = 1;
			state = TS3;
		end
		TS3: begin
			drdy = 0;
			if(dacp)
				if(addr == 10)
				begin
					state = other;
					msgrdy = 0;
				end
				else
					state = TS2;
			else
				state = TS3;
		end

	    default:
	      begin
                 $display($time," Transmitter delaying for %d cycle(s)",delay);
		 #(10*delay)
		 for (i=0; i<10; i=i+1)
		   nextdata[i]=$random;
		 state=TS1;
	      end
	  endcase // case(state)
     end // always @ (posedge clock)
endmodule // transmit

	    

module test;
   wire [7:0] MSG; //DATA
   wire       msgrdy, drdy; //sending, dready
   reg 	      send, dacp, clock, reset; //msg_req, dacpt, clock, reset
   integer    msgrdy_delay, send_delay; //msg_req_delay, sending_delay
   integer    drdy_delay, dacp_delay; //dready_delay, dacpt_delay

   integer    i;
   
   always
     #5 clock=~clock;

   initial
     begin
	//$dumpfile("waves.vcd");
        //$dumpvars;
	//$shm_open("waves.db");
	//$shm_probe("AS");
	clock=1; reset=1;
        send=0; dacp=0;
	msgrdy_delay=12; send_delay=15;
	drdy_delay=23; dacp_delay=14;
	#15 reset=0;
	#490
	msgrdy_delay=2; send_delay=6;
	drdy_delay=4; dacp_delay=7;
        #300 $finish;
     end

   always
     begin

    //  Complete the TestBench code
	#(msgrdy_delay) send = 1;
	wait (msgrdy)
	while (msgrdy)
	begin
		wait (drdy) #(drdy_delay)
		$display($time," recieved %h",MSG);
		dacp = 1;
		#(dacp_delay) dacp = 0;
	end
	#(dacp_delay) send = 0;
     end

   transmit dut(MSG, msgrdy, send, drdy, dacp, clock, reset);
endmodule // test
