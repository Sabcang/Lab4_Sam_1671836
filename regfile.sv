module regfile (ReadRegister1, ReadRegister2, ReadData1, ReadData2,
			RegWrite, WriteRegister, WriteData, clk, reset);
	output logic [63:0] ReadData1, ReadData2;
	input logic [4:0] ReadRegister1, ReadRegister2, WriteRegister;
	input logic clk, reset, RegWrite;
	input logic [63:0] WriteData;

	logic [31:0][63:0] regToMux; 									// wire from register to mutiplexor
	logic [31:0] we;            
	
	decoder1_32 decoder (RegWrite, WriteRegister, we[31:0]);

	// Registers X30 - X0
	genvar j;
	generate 
		for (j = 30; j >= 0; j--) begin : eachReg
			register64 regs (regToMux[j], WriteData, we[j], clk, reset);
		end
	endgenerate
	logic [63:0] x31ToMux;

	register64 x31 (regToMux[31], 64'b0, we[31], clk, reset); 				// Register X31

	// multiplexor that reads data from register.
	Multiplexor mul1 (ReadData1, regToMux, ReadRegister1);
	Multiplexor mul2 (ReadData2, regToMux, ReadRegister2);
endmodule

module register64(dataOut, dataIn, we, clk, reset);
    input logic we, clk, reset;
    input logic [63:0] dataIn;
    output logic [63:0] dataOut;
	 
    logic [63:0] muxToReg, regToOut;

    genvar i;
    generate
        for (i = 63; i >= 0; i--) begin : eachDff
            D_FF dff64 (regToOut[i], muxToReg[i], reset, clk);
				mux2_1 m64 (we, dataIn[i], regToOut[i], muxToReg[i]);
        end
    endgenerate
	 
	 assign dataOut = regToOut;
	 
endmodule

module D_FF (q, d, reset, clk);
    output reg q;
    input d, reset, clk;

    always_ff @(posedge clk)
        if (reset)
            q <= 0; // On reset, set to 0
        else
            q <= d; // Otherwise out = d
endmodule 