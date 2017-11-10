module SE26 (BrAddr26, SEBrAddr);
	input logic [25:0] BrAddr26;
	output logic [63:0] SEBrAddr;
								 
	assign SEBrAddr =  {BrAddr26[25], BrAddr26[25], BrAddr26[25], BrAddr26[25], BrAddr26[25], 
							BrAddr26[25], BrAddr26[25], BrAddr26[25], BrAddr26[25], BrAddr26[25], 
							BrAddr26[25], BrAddr26[25], BrAddr26[25], BrAddr26[25], BrAddr26[25], 
							BrAddr26[25], BrAddr26[25], BrAddr26[25], BrAddr26[25], BrAddr26[25], 
							BrAddr26[25], BrAddr26[25], BrAddr26[25], BrAddr26[25], BrAddr26[25], 
							BrAddr26[25], BrAddr26[25], BrAddr26[25], BrAddr26[25], BrAddr26[25], 
							BrAddr26[25], BrAddr26[25], BrAddr26[25], BrAddr26[25], BrAddr26[25], 
							BrAddr26[25], BrAddr26[25], BrAddr26[25], BrAddr26};
endmodule

module SE19 (CondAddr19, SECondAddr);
	input logic [18:0] CondAddr19;
	output logic [63:0] SECondAddr;

	assign SECondAddr =  {CondAddr19[18], CondAddr19[18], CondAddr19[18], CondAddr19[18], CondAddr19[18], 
								 CondAddr19[18], CondAddr19[18], CondAddr19[18], CondAddr19[18], CondAddr19[18], 
								 CondAddr19[18], CondAddr19[18], CondAddr19[18], CondAddr19[18], CondAddr19[18], 
								 CondAddr19[18], CondAddr19[18], CondAddr19[18], CondAddr19[18], CondAddr19[18], 
								 CondAddr19[18], CondAddr19[18], CondAddr19[18], CondAddr19[18], CondAddr19[18], 
								 CondAddr19[18], CondAddr19[18], CondAddr19[18], CondAddr19[18], CondAddr19[18], 
								 CondAddr19[18], CondAddr19[18], CondAddr19[18], CondAddr19[18], CondAddr19[18], 
								 CondAddr19[18], CondAddr19[18], CondAddr19[18], CondAddr19[18], CondAddr19[18], 
								 CondAddr19[18], CondAddr19[18], CondAddr19[18], CondAddr19[18], CondAddr19[18], 
								 CondAddr19};
endmodule

module SE9 (Daddr9, SEDAddr);
	input logic [8:0] Daddr9;
	output logic [63:0] SEDAddr;
	
	assign SEDAddr =  {Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], 
							 Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], 
							 Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], 
							 Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], 
							 Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], 
							 Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], 
							 Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8],
							 Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], Daddr9[8], Daddr9};

endmodule

module SE12 (imm12, SEImm12);
	input logic [11:0] imm12;
	output logic [63:0] SEImm12;
	
	assign SEImm12 =  {52'b0, imm12};
endmodule

module combine (
	input logic [1:0] shamt,
	input logic [63:0] Db,
	input logic [15:0] Imm16,
	output logic [63:0] out);
	
	always_comb begin
		case(shamt)
		2'b0: begin out[63:16] = Db[63:16]; out[15:0] = Imm16; end
		2'b1: begin out[63:32] = Db[63:32]; out[31:16] = Imm16; out[15:0] = Db[15:0]; end
		2'd2: begin out[63:48] = Db[63:48]; out[47:32] = Imm16; out[31:0] = Db[31:0]; end
		2'd3: begin out[63:48] = Imm16; out[47:0] = Db[47:0]; end
		default:;
		endcase
	end
endmodule

module combine_testbench();

	logic [1:0] shamt;
	logic [63:0] Db;
	logic [15:0] Imm16;
	logic [63:0] out;
	
	combine dut (.shamt, .Db, .Imm16, .out);
	
	integer i;
	
	initial begin
		shamt = 00; Db = 63'hABCDEF01ABCDEF01; Imm16 = 16'b1111000011110000; #10;
		shamt = 01; Db = 63'hABCDEF01ABCDEF01; Imm16 = 16'b1111000011110000; #10;
		shamt = 10; Db = 63'hABCDEF01ABCDEF01; Imm16 = 16'b1111000011110000; #10;
		shamt = 11; Db = 63'hABCDEF01ABCDEF01; Imm16 = 16'b1111000011110000; #10;
	end
endmodule