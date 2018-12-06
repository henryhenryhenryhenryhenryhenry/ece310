
module proj1( 
input clk, 
input rst, 
output MemRW_IO, 
output [7:0] MemAddr_IO, 
output [15:0] MemD_IO);

wire [7:0] MemAddr;
wire [15:0] MemD;
wire [15:0] MemQ;
wire MemRW;
wire muxPC;
wire muxMAR;
wire MuxACC;
wire loadMAR;
wire loadPC;
wire loadACC;
wire loadMDR;
wire loadIR;
wire opALU;
wire zflag;
wire [7:0]opcode;

//one instance of memory
//one instance of controller
//one instance of datapath1
ram r1( MemAddr, MemD, MemQ, MemRW);
ctr c1( clk, rst, zflag, opcode, muxPC, muxMAR, muxACC, loadMAR, loadPC, loadACC, loadMDR, loadIR, opALU, MemRW);
datapath d1( clk, rst, muxPC, muxMAR, muxACC, loadMAR, loadPC, loadACC, loadMDR, loadIR, opALU, zflag, opcode, MemAddr, MemD, MemQ, MemRW);

//these are just to observe the signals. 
assign MemAddr_IO = MemAddr; 
assign MemD_IO = MemD; 
assign MemRW_IO = MemRW;

endmodule
//---------------------------------------------------------------------------------------------------------------------------------------------
module ram(addr, din, dout, we);
input [7:0] addr;
input [15:0] din;
input we;
output reg [15:0] dout;
reg [15:0] mem[0:255]; // 16x255

always@(*)
begin
	case(we)
	// during write set dout to din
	1: //write din to memory
	mem[addr] <= din;
	0: //write memory value to dout
	dout <= mem[addr];
	
	endcase
end
endmodule
//---------------------------------------------------------------------------------------------------------------------------------------------
module registers (
input wire clk,
input wire rst,
output reg  [7:0]PC_reg,
input wire  [7:0]PC_next,
output reg  [15:0]IR_reg, 
input wire  [15:0]IR_next,  
output reg  [15:0]ACC_reg, 
input wire  [15:0]ACC_next,  
output reg  [15:0]MDR_reg, 
input wire  [15:0]MDR_next,   
output reg  [7:0]MAR_reg,
input wire  [7:0]MAR_next,  
output reg zflag_reg,
input wire zflag_next);

always@(posedge clk) begin
	if(rst) 
	begin
		PC_reg <= 0;
		IR_reg <= 0;
		ACC_reg <= 0;
		MDR_reg <= 0;
		MAR_reg <= 0;
		zflag_reg <= 0;
	end 
	else 
	begin
		PC_reg <= PC_next;
		IR_reg <= IR_next;
		ACC_reg <= ACC_next;
		MDR_reg <= MDR_next;
		MAR_reg <= MAR_next;
		zflag_reg <= zflag_next;
	end
end
endmodule
//---------------------------------------------------------------------------------------------------------------------------------------------
module datapath(
input  clk,
input  rst,
input  muxPC,
input  muxMAR, 
input  muxACC,
input  loadMAR, 
input  loadPC,
input  loadACC, 
input  loadMDR, 
input  loadIR, 
input  opALU,
output   zflag,
output [7:0]opcode,
output [7:0]MemAddr, 
output [15:0]MemD, 
input  [15:0]MemQ,
input MemRW//
);

wire  [7:0]PC_next;
wire  [15:0]ACC_next;
wire  [7:0]MAR_next;
wire  [15:0]IR_next;
wire  [15:0]MDR_next;
wire zflag_next;

wire  [7:0]PC_reg;
wire  [15:0]IR_reg;   
wire  [15:0]ACC_reg;   
wire  [15:0]MDR_reg;   
wire  [7:0]MAR_reg;   
wire zflag_reg; 

wire  [15:0]ALU_out;

//muxPC, muxMAR, muxACC
//loadMAR, loadPC, loadACC, loadMDR, loadIR
assign PC_next = loadPC ? (muxPC ? IR_reg : (PC_reg + 1)) : PC_reg;

assign IR_next =  loadIR ? MDR_reg : IR_reg;

assign ACC_next = loadACC ? (muxACC ? ALU_out : MDR_reg) : ACC_reg;

assign MDR_next = loadMDR ? MemQ : MDR_reg;//

assign MAR_next = loadMAR ? (~muxMAR ? PC_reg : IR_reg[15:8]) : MAR_reg;//not sure which half of IR is what

assign zflag_next =  |ACC_reg ? 1'b0 : 1'b1;//

assign zflag =  zflag_next;
assign opcode = IR_reg[7:0];//not sure which half of IR is what
assign MemAddr = MAR_reg;//not sure which half of IR is what
assign MemD = ACC_reg;

//one instance of registers
registers regs(clk, rst, PC_reg, PC_next, IR_reg, IR_next, ACC_reg, ACC_next, MDR_reg, MDR_next, MAR_reg, MAR_next, zflag, zflag_next );
// one instunace of alu
alu a( MDR_reg, ACC_reg, opALU, ALU_out);

endmodule
//---------------------------------------------------------------------------------------------------------------------------------------------
module ctr(
clk,
rst,
zflag,
opcode,
muxPC,
muxMAR,
muxACC,
loadMAR,
loadPC,
loadACC,
loadMDR,
loadIR,
opALU,
MemRW
);
parameter d_width=16, addr_width=8, mem_depth=256;
parameter Fetch_1=     4'b0000;
parameter Fetch_2=     4'b0001;
parameter Fetch_3=     4'b0010;
parameter Decode=      4'b0011;
parameter ExecADD_1=   4'b0100;
parameter ExecADD_2=   4'b0101;
parameter ExecOR_1=    4'b0110;
parameter ExecOR_2=    4'b0111;
parameter ExecLoad_1=  4'b1000;
parameter ExecLoad_2=  4'b1001;
parameter ExecStore_1= 4'b1010;
parameter ExecStore_2= 4'b1011;
parameter ExecJump=    4'b1100;

parameter op_add=   8'b0001;//
parameter op_or=    8'b0010;//
parameter op_load=  8'b0011;//
parameter op_store= 8'b0100;//
parameter op_jump=  8'b0101;//
parameter op_jumpz= 8'b0110;//

input clk;
input rst;
input zflag;
input [addr_width-1:0] opcode;
output reg muxPC;
output reg muxMAR;
output reg muxACC;
output reg loadMAR;
output reg loadPC;
output reg loadACC;
output reg loadMDR;
output reg loadIR;
output reg opALU;
output reg MemRW;
		   
reg [3:0]reg_state;
reg [3:0]next_state;
		   

always @ ( posedge clk )
begin
   	if( rst )
     		reg_state <=  Fetch_1 ;
   	else
     		reg_state<= next_state ;
end


always @ (reg_state or opcode or zflag)
begin
    	case (reg_state)
      	// follow the flow chart to figure out allthe next states.
	  	default: next_state <= Fetch_1;
		Fetch_1: next_state <= Fetch_2;
		Fetch_2: next_state <= Fetch_3;
		Fetch_3: next_state <= Decode;
		Decode: 
		begin
			case(opcode)
			op_add: next_state <= ExecADD_1;
			op_or: next_state <= ExecOR_1;
			op_load: next_state <= ExecLoad_1;
			op_store: next_state <= ExecStore_1;
			op_jump: next_state <= ExecJump;
			op_jumpz:
			begin
				if(zflag)
				next_state <= ExecJump;
				else
				next_state <= Fetch_1;
			end
			default: next_state <= 4'b1111;
			endcase
		end
		ExecADD_1: next_state <= ExecADD_2; 
		ExecADD_2: next_state <= Fetch_1;
		ExecOR_1: next_state <= ExecOR_2;
		ExecOR_2: next_state <= Fetch_1;
		ExecLoad_1: next_state <= ExecLoad_2;
		ExecLoad_2: next_state <= Fetch_1;
		ExecStore_1: next_state <= Fetch_1;
		ExecJump: next_state <= Fetch_1;
    	endcase
end				 

always @ (reg_state )
begin
    	case (reg_state)
      		Fetch_1:	 
	  	begin
			muxPC <= 1'b0; 
    			muxMAR <= 1'b0;
    			muxACC <= 1'b0; //
    			loadMAR <= 1'b1;
    			loadPC <= 1'b1; 
    			loadACC <= 1'b0; //
    			loadMDR <= 1'b0; //
    			loadIR <= 1'b0; //
    			opALU <= 1'b0; //
    			MemRW <= 1'b0; //
	   	end

		Fetch_2:
		begin
			muxPC <= 1'b0; 
    			muxMAR <= 1'b0;
    			muxACC <= 1'b0; 
    			loadACC <= 1'b0; 
    			loadIR <= 1'b0; 
    			opALU <= 1'b0; 
			loadPC <= 1'b0;//
			loadMAR <= 1'b0;//
			
			MemRW <= 1'b0;
			loadMDR <= 1'b1;			
		end

		Fetch_3:
		begin
			muxPC <= 1'b0; 
    			muxMAR <= 1'b0;
    			muxACC <= 1'b0; 
    			loadMAR <= 1'b0;
    			loadPC <= 1'b0; 
    			loadACC <= 1'b0; 
    			opALU <= 1'b0; 
    			MemRW <= 1'b0; 
			loadMDR <= 1'b0;//

			loadIR <= 1'b1;
		end

		Decode:
		begin
			muxPC <= 1'b0; 
    			muxACC <= 1'b0; 
    			loadPC <= 1'b0; 
    			loadACC <= 1'b0; 
    			loadMDR <= 1'b0; 
    			opALU <= 1'b0; 
    			MemRW <= 1'b0; 
			loadIR <= 1'b0;//

			muxMAR <= 1'b1;
			loadMAR <= 1'b1;
		end

		ExecADD_1:
		begin
			muxPC <= 1'b0; 
    			muxACC <= 1'b0; 
    			loadPC <= 1'b0; 
    			loadACC <= 1'b0; 
    			loadIR <= 1'b0; 
    			opALU <= 1'b0; 
			muxMAR <= 1'b0;//
			loadMAR <= 1'b0;//
			
			MemRW <= 1'b0;
			loadMDR <= 1'b1;
		end

		ExecADD_2:
		begin
			muxPC <= 1'b0; 
    			muxMAR <= 1'b0;
    			loadMAR <= 1'b0;
    			loadPC <= 1'b0; 
    			loadIR <= 1'b0; 
    			MemRW <= 1'b0; 
			loadMDR <= 1'b0;//
			
			loadACC <= 1'b1;
			muxACC <= 1'b0;
			opALU <= 1'b1;
		end

		ExecOR_1:
		begin
			muxPC <= 1'b0; 
    			muxACC <= 1'b0; 
    			loadPC <= 1'b0; 
    			loadACC <= 1'b0; 
    			loadIR <= 1'b0; 
    			opALU <= 1'b0; 
			muxMAR <= 1'b0;//
			loadMAR <= 1'b0;//

			MemRW <= 1'b0;
			loadMDR <= 1'b1;
		end

		ExecOR_2:
		begin
			muxPC <= 1'b0; 
    			muxMAR <= 1'b0;
    			loadMAR <= 1'b0;
    			loadPC <= 1'b0; 
    			loadIR <= 1'b0; 
    			MemRW <= 1'b0; 
			loadMDR <= 1'b0;//

			loadACC <= 1'b1;
			muxACC <= 1'b0;
			opALU <= 1'b0;
		end

		ExecLoad_1:
		begin
			muxPC <= 1'b0; 
    			muxACC <= 1'b0; 
    			loadPC <= 1'b0; 
    			loadACC <= 1'b0; 
    			loadIR <= 1'b0; 
    			opALU <= 1'b0; 
			muxMAR <= 1'b0;//
			loadMAR <= 1'b0;//

			MemRW <= 1'b0;
			loadMDR <= 1'b1;
		end

		ExecLoad_2:
		begin
			muxPC <= 1'b0; 
    			muxMAR <= 1'b0; 
    			loadMAR <= 1'b0;
    			loadPC <= 1'b0;  
    			loadIR <= 1'b0; 
    			opALU <= 1'b0; 
    			MemRW <= 1'b0; 
			loadMDR <= 1'b0;//

			loadACC <= 1'b1;
			muxACC <= 1'b1;
		end

		ExecStore_1:
		begin
			muxPC <= 1'b0; 
    			muxACC <= 1'b0; 
    			loadPC <= 1'b0; 
    			loadACC <= 1'b0; 
    			loadMDR <= 1'b0; 
    			loadIR <= 1'b0; 
    			opALU <= 1'b0; 
			muxMAR <= 1'b0;//
			loadMAR <= 1'b0;//

			MemRW <= 1'b1;
		end

		ExecJump:
		begin
    			muxACC <= 1'b0; 
    			loadACC <= 1'b0; 
    			loadMDR <= 1'b0; 
    			loadIR <= 1'b0; 
    			opALU <= 1'b0; 
    			MemRW <= 1'b0; 
			muxMAR <= 1'b0;//
			loadMAR <= 1'b0;//

			muxPC <= 1'b1;
			loadPC <= 1'b1;
		end
		  
      	//pick values for all other states.
   	
	endcase  
   
end
		   
endmodule
//---------------------------------------------------------------------------------------------------------------------------------------------
module alu( 
input [15:0] A, B,
input opALU, 
output wire [15:0] Rout);

assign Rout = opALU ? A+B : A|B;

endmodule
//---------------------------------------------------------------------------------------------------------------------------------------------
module proj1_tb;
	reg clk;
	reg rst;
	wire MemRW_IO;
	wire [7:0]MemAddr_IO;
	wire [15:0]MemD_IO;

always@(Dut.c1.reg_state) 
begin
	case (Dut.c1.reg_state)

		0: $display($time," Fetch_1");
		1: $display($time," Fetch_2");
		2: $display($time," Fetch_3");
		3: $display($time," Decode");
		4: $display($time," ExecADD_1");
		5: $display($time," ExecADD_2");
		6: $display($time," ExecOR_1");
		7: $display($time," ExecOR_2");
		8: $display($time," ExecLoad_1");
		9: $display($time," ExecLoad_2");
		10: $display($time," ExecStore_1");
		11: $display($time," ExecStore_2");
		12: $display($time," ExecJump");
		default: $display($time," Unrecognized State %b %b %b",  Dut.d1.IR_reg, Dut.d1.MemQ, Dut.d1.MemAddr);

	endcase 
end

always 
begin
      #5  clk = !clk;
end
		
initial 
begin
	$dumpfile("Proj1_waves.vcd");
  	$dumpvars;
	clk=1'b0;
	rst=1'b1;
	$readmemh("mem.dat", proj1_tb.Dut.r1.mem);
	#20 rst=1'b0;
	#435 
	$display("Final value\n");
	$display("0x00d %d\n", proj1_tb.Dut.r1.mem[16'h000d]);
	$finish;
end

proj1 Dut(clk, rst, MemRW_IO, MemAddr_IO, MemD_IO);	   

endmodule