module train_controller( prog_seq , prog_cap, rst , clk , start, station );

//what are the input ports.
input [4:0] prog_seq;
input prog_cap, rst, clk, start;

//What are the output ports.
output [2:0]station;

//internal signals

reg [2:0] station;
reg [3:0] state;  // to keep track of the state in the first state machine
reg [4:0] progseq; // internal register to capture the value
reg stat; // signal that goes to the second state machine
reg ends; // signal that goes to the second state machine

always @(posedge clk)
   begin
  if (rst)
    begin
    state <= 0;
    stat  <= 0;
    ends <= 0;
    end
  else
     case(state)
	 
	 //0 capture the input
	4'b0000: 
	begin
		progseq[4] <= prog_seq[4];
		progseq[3] <= prog_seq[3];
		progseq[2] <= prog_seq[2];
		progseq[1] <= prog_seq[1];
		progseq[0] <= prog_seq[0];
		
		if(prog_cap) begin state <= 4'b0001; end
		else begin state <= 4'b0000; end
	end
		
	 //1 look for start and start start machine
	4'b0001: 
	begin
		if(start) state <= 4'b0010;
		else state <= 4'b0001;
	end
		
	 //2 ouput bit 0
	4'b0010: 
	begin
		stat <= progseq[4];
		state <= 4'b0011;
	end
		
	 //3 output bit 1
	4'b0011:
	begin
		stat <= progseq[3];
		state <= 4'b0100;
	end

	 //4 output bit 2
	4'b0100: 
	begin
		stat <= progseq[2];
		state <= 4'b0101;
	end

	 //5 output bit 3
	4'b0101:
	begin
		stat <= progseq[1];
		state <= 4'b0110;
	end

	 //6 output bit 4
	4'b0110:
	begin
		stat <= progseq[0];
		state <= 4'b0111;
	end

	 //7 ends to 1
	4'b0111:
	begin
		ends <= 1;
		state <= 4'b1000;
		stat <= 0;
		station <=3'b000;
	end
		
	 //8 ends to 0 go to 0
	4'b1000:
	begin
		ends <= 0;
		state <= 4'b0000;
		
	end
		 

     default: begin state <= 0; end
     endcase

    end

always @(posedge clk)
   begin
  if (rst || ends)
      station <= 0; 
   else
   case ( station )
   // look at stat and decide where to go.
   // don't worry about ends signal here for simplicity.
	3'b000: //downtown
	begin
	if(stat)
		begin
		station <= 3'b001;
		end
	else
		begin
		station <= 3'b000;
		end
	end
	3'b001: //airport
	begin
	if(stat)
		begin
		station <= 3'b100;
		end
	else
		begin
		station <= 3'b010;
		end
	end
	3'b010: //state fair
	begin
	if(stat)
		begin
		station <= 3'b100;
		end
	else
		begin
		station <= 3'b011;
		end
	end
	3'b011: //umstead
	begin
	if(stat)
		begin
		station <= 3'b100;
		end
	else
		begin
		station <= 3'b011;
		end
	end
	3'b100: //mordecai
	begin
	if(stat)
		begin
		station <= 3'b101;
		end
	else
		begin
		station <= 3'b111;
		end
	end
	3'b101: //citi museum
	begin
	if(stat)
		begin
		station <= 3'b110;
		end
	else
		begin
		station <= 3'b011;
		end
	end
	3'b110: //ncsu
	begin
	if(stat)
		begin
		station <= 3'b110;
		end
	else
		begin
		station <= 3'b111;
		end
	end
	3'b111: //state capital
	begin
	if(stat)
		begin
		station <= 3'b101;
		end
	else
		begin
		station <= 3'b001;
		end
	end

 
   endcase
end

endmodule

module train_controller_tb;

//what are the input ports.
reg [4:0] prog_seq;
reg prog_cap, rst, clk, start;
wire [2:0] station;

always #5 clk = ~clk;

//Use an always statement to output the state name
always @(station)
begin
case (station)
0: $display("?downtown?");
1: $display("?airport?");
endcase
end

train_controller dut( prog_seq , prog_cap, rst , clk , start, station );
initial begin
rst = 0;
clk  = 0;
#2 
rst = 1;
#7 rst = 0;
#12 prog_seq = 5'b10001; prog_cap = 1;
#22 start = 1;   

end
endmodule
