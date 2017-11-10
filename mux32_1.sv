module mux32_1 (sel, dataIn, dataOut);
	input logic [4:0]sel;
    input logic [31:0]dataIn;
	 output logic dataOut;
    logic [1:0] tempOut;
    logic w1, w2;

    mux16_1 m1 (sel[3:0], dataIn[31:16], tempOut[1]);
    mux16_1 m2 (sel[3:0], dataIn[15:0], tempOut[0]);
    mux2_1 m (sel[4], tempOut[1], tempOut[0], dataOut);

endmodule

module mux16_1 (sel, dataIn, dataOut);
	input logic [3:0]sel;
    input logic [15:0]dataIn;
	 output logic dataOut;
    logic [1:0] tempOut;
    logic w1, w2;

    mux8_1 m1 (sel[2:0], dataIn[15:8], tempOut[1]);
    mux8_1 m2 (sel[2:0], dataIn[7:0], tempOut[0]);
    mux2_1 m (sel[3], tempOut[1], tempOut[0], dataOut);

endmodule

module mux8_1 (sel, dataIn, dataOut);
	 input logic [2:0]sel;
    input logic [7:0]dataIn;
	 output logic dataOut;
    logic [1:0] tempOut;
    logic w1, w2;

    mux4_1 m1 (sel[1:0], dataIn[7:4], tempOut[1]);
    mux4_1 m2 (sel[1:0], dataIn[3:0], tempOut[0]);
    mux2_1 m (sel[2], tempOut[1], tempOut[0], dataOut);

endmodule

module mux4_1 (sel, dataIn, dataOut);
	input logic [1:0]sel;
    input logic [3:0]dataIn;
	 output logic dataOut;
    logic [1:0] tempOut;
    logic w1, w2;

    mux2_1 m1 (sel[0], dataIn[3], dataIn[2], tempOut[1]);
    mux2_1 m2 (sel[0], dataIn[1], dataIn[0], tempOut[0]);
    mux2_1 m (sel[1], tempOut[1], tempOut[0], dataOut);

endmodule

module mux2_1 (sel, in1, in0, out);
	timeunit 1ps;
	timeprecision 1ps;
	input logic sel, in0, in1;
	output logic out;
	logic w1, w2, notSel;

	not #50 n1 (notSel, sel); 
	and #50 a1 (w1, notSel, in0);
	and #50 a2 (w2, sel, in1);
	or #50 o1 (out, w1, w2);

endmodule

	