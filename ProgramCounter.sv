module ProgramCounter (counter, clk, UnCondBr, BrTaken, CondAddr19, BrAddr26, reset);
	output logic [63:0] counter;
	input logic clk, UnCondBr, BrTaken, reset;
	input logic [18:0] CondAddr19;
	input logic [25:0] BrAddr26;
	
	logic [63:0] ps, ns;
	logic [63:0] SECondAddr, SEBrAddr;
	SE26 se26 (BrAddr26, SEBrAddr);
	SE19 se19 (CondAddr19, SECondAddr);
	
	logic [63:0] ToShift;
	mux2_1_64bit x64 (.in1(SEBrAddr), .in0(SECondAddr), .sel(UnCondBr), .dataOut(ToShift));
	
	logic [63:0] ShiftToAddr;
	assign ShiftToAddr = {ToShift[61:0], 2'b0};
	
	logic [63:0] BranchResult, StandardResult;
	logic overflow, overflow2;            // not considering an overflow case for now.
	Addr_64bit Brad64 (BranchResult, ps, ShiftToAddr, overflow);
	Addr_64bit Stad64 (StandardResult, ps, 64'd4, overflow2);

	mux2_1_64bit updatePC (.in1(BranchResult), .in0(StandardResult), .sel(BrTaken), .dataOut(ns));
	
	always_ff @(posedge clk) 
	begin
		if (reset)
			ps <= 0;
		else
			ps <= ns;
	end		
	
	assign counter = ps;
	
endmodule
