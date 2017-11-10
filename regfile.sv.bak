module main (readRegister1, readRegister2, readData1, readData2,
			regWrite, writeRegister, writeData, clk, reset);
	output logic [63:0] readData1, readData2;
	input logic [4:0] readRegister1, readRegister2;
	input logic clk, reset, regWrite;
	input logic [4:0] writeRegister;
	input logic [63:0] writeData;

	logic [63:0][31:0] regToMux; 									// wire from register to mutiplexor
	logic [31:0] we;

	decoder1_32 decoder (regWrite, writeRegister, we);

	// Registers X30 - X0
	genvar i;
	generate 
		for (i = 30; i >= 0; i--) begin : eachReg
			register64 regs (regToMux[63:0][i], writeData, we[i], clk);
		end
	endgenerate

	register64 x31 (regTomux[63:0][31], 0, 0, clk); 				// Register X31

	// multiplexor that reads data from register.
	mux32_1_64bit mux1 (regToMux, readRegister1, readData1);
	mux32_1_64bit mux2 (regToMux, readRegister2, readData2);

endmodule