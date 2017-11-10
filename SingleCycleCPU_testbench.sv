
`timescale 1ns/10ps

module SingleCycleCPU_testbench();

	parameter ClockDelay = 10000;
	
	logic clk, reset, running;
	
	integer i;
	
	SingleCycleCPU dut (.running, .clk, .reset);
	
	initial $timeformat(-9, 2, " ns", 10);
	
	initial begin
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		
		for (i = 0; i < 1200; i++)
			@(posedge clk);
		$stop;
	end
	
endmodule