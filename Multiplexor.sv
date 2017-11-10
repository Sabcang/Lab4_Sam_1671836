module Multiplexor (dataOut, dataIn, sel);
	input logic [31:0][63:0] dataIn;
	input logic [4:0] sel;
	output logic [63:0] dataOut;
	
	genvar k;
	generate
		for (k = 63; k >= 0; k--) begin : eachMux
			mux32_1 mux1 (sel, {dataIn[31][k], dataIn[30][k], dataIn[29][k], 
								dataIn[28][k], dataIn[27][k], dataIn[26][k], dataIn[25][k], dataIn[24][k], 
								dataIn[23][k], dataIn[22][k], dataIn[21][k], dataIn[20][k], dataIn[19][k], 
								dataIn[18][k], dataIn[17][k], dataIn[16][k], dataIn[15][k], dataIn[14][k], 
								dataIn[13][k], dataIn[12][k], dataIn[11][k], dataIn[10][k], dataIn[9][k], 
								dataIn[8][k], dataIn[7][k], dataIn[6][k], dataIn[5][k], dataIn[4][k], 
								dataIn[3][k], dataIn[2][k], dataIn[1][k], dataIn[0][k]}, dataOut[k]);
		end
	endgenerate
endmodule

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
    mux2_1 m  (sel[1], tempOut[1], tempOut[0], dataOut);

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

module mux2_1_4bit(in1, in0, sel, dataOut);
    input logic [3:0] in1, in0;
    input logic sel;
    output logic [3:0] dataOut;

    genvar i;
    generate
        for (i = 3; i >= 0; i--) begin : eachMux   
            mux2_1 muxx (sel, in1[i], in0[i], dataOut[i]);
        end
    endgenerate

endmodule

module mux2_1_5bit(in1, in0, sel, dataOut);
    input logic [4:0] in1, in0;
    input logic sel;
    output logic [4:0] dataOut;

    genvar i;
    generate
        for (i = 4; i >= 0; i--) begin : eachMux   
            mux2_1 muxx (sel, in1[i], in0[i], dataOut[i]);
        end
    endgenerate

endmodule

module mux2_1_64bit(in1, in0, sel, dataOut);
    input logic [63:0] in1, in0;
    input logic sel;
    output logic [63:0] dataOut;

    genvar i;
    generate
        for (i = 63; i >= 0; i--) begin : eachMux   
            mux2_1 muxx (sel, in1[i], in0[i], dataOut[i]);
        end
    endgenerate

endmodule

module mux4_1_64bit(sel, dataIn, dataOut);
    input logic [3:0][63:0] dataIn;
    input logic [1:0] sel;
    output logic [63:0] dataOut;

    genvar i;
    generate
        for (i = 63; i >= 0; i--) begin : eachMux   
            mux4_1 muxxx (sel, {dataIn[3][i], dataIn[2][i], dataIn[1][i], dataIn[0][i]}, dataOut[i]);
        end
    endgenerate

endmodule

module mux4_1_6bit(sel, dataIn, dataOut);
    input logic [3:0][5:0] dataIn;
    input logic [1:0] sel;
    output logic [5:0] dataOut;

    genvar i;
    generate
        for (i = 5; i >= 0; i--) begin : eachMux   
            mux4_1 muxxx (sel, {dataIn[3][i], dataIn[2][i], dataIn[1][i], dataIn[0][i]}, dataOut[i]);
        end
    endgenerate

endmodule


