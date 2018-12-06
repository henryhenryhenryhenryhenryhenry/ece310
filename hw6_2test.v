

module receive(MSG, msgrdy, send, drdy, dacp, clock, reset);
   input [7:0] MSG; //DATA
   input 	msgrdy, drdy; //sending, dready
   output 	send, dacp; //msg_req, dacpt
   input 	clock, reset; //clock, reset
   parameter 	RS1=0, RS2=1, RS3=2, RS4=3, RS5=4, RS6=5, RS7=6, other=7;
   parameter    delay=4;

   reg [2:0] 	state; //state
   reg [7:0] 	nextdata [0:9]; //nextdata
   reg 		send, dacp;// msg_req, dacpt
   reg [3:0] 	addr; //addr
   
   always @(posedge clock)
     begin
	if (reset)
	  state=other;
	else
	  case (state)
	    
       //  Complete the code for Receiver
		RS1: begin
			send = 1;
			addr = 0;
			state = RS2;
		end
		RS2: begin
			if(drdy)
			begin
				nextdata[addr] = MSG;
				$display($time," recieved %h", MSG);
				addr = addr + 1;
				dacp = 1;
				state = RS3;
			end
			else
			begin
				dacp = 0;
				state = RS2;
			end
		end
		RS3: begin
			if(msgrdy)
			begin
				dacp = 0;
				state = RS2;
			end
			else
			begin
				dacp = 0;
				state = other;
			end
		end	
	    default:
	      begin
                 $display($time," Receiver delaying for %d cycle(s)",delay);
		 #(10*delay)
		 state=RS1;
	      end
	  endcase // case(state)
     end // always @ (posedge clock)
endmodule // transmit

	    

module test;
   reg [7:0]  MSG; //DATA
   reg        msgrdy, drdy, clock, reset; //sending, dready, clock, reset
   wire       send, dacp; //msg_req, dacpt
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
        msgrdy=0; drdy=0;
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

      //  Complete the test bench
	
	wait (send)
	#(msgrdy_delay) msgrdy = 1;
	
	$display($time," transmitter sending %d bytes", 10);
	for(i=0;i<10;i=i+1)
	begin
		MSG=$random;
		$display($time," transmitted %h",MSG);
		drdy = 1;
		#(drdy_delay) wait (dacp)
		#(dacp_delay) drdy = 0;
	end
	msgrdy = 0;
	#(send_delay);	
     end

   receive dut(MSG, msgrdy, send, drdy, dacp, clock, reset);
endmodule // test
