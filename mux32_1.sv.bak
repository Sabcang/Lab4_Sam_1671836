module mux32_1 (sel, dataIn, dataOut);
	input logic [4:0]sel;
    input logic [31:0]dataIn;
	output logic out;
    logic [1:0] tempOut;
    logic w1, w2;

    mux8_1 m1 (sel[3:0], dataIn[31:16], tempOut[1]);
    mux8_1 m2 (sel[3:0], dataIn[15:0], tempOut[0]);
    mux2_1 m (sel[4], tempOut[1], tempOut[0], dataOut);

endmodule

	