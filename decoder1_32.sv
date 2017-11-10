module decoder1_32 (dataIn, sel, dataOut);
    input logic dataIn;
    input logic [4:0] sel;
    output logic [31:0] dataOut; //careful about 31

    logic wire1, wire2;
    decoder1_16 d1 (wire1, dataOut[31:16], sel[3:0]);
    decoder1_16 d2 (wire2, dataOut[15:0], sel[3:0]);
    decoder1_2 d (dataIn, wire1, wire2, sel[4]);
endmodule

module decoder1_16 (in, out, sel);
    input logic in;
    input logic [3:0] sel;
    output logic [15:0] out;

    logic [3:0] wires;

    decoder1_4 d1 (wires[3], out[15:12], sel[1:0]);
    decoder1_4 d2 (wires[2], out[11:8], sel[1:0]);
    decoder1_4 d3 (wires[1], out[7:4], sel[1:0]);
    decoder1_4 d4 (wires[0], out[3:0], sel[1:0]);
    decoder1_4 d (in, wires[3:0], sel[3:2]);
endmodule

module decoder1_4 (in, out, sel);
    input logic in;
    input logic [1:0] sel;
    output logic [3:0] out;

    logic wire1, wire2;
	 
    decoder1_2 d1 (wire1, out[3], out[2], sel[0]);
    decoder1_2 d2 (wire2, out[1], out[0], sel[0]);
    decoder1_2 d (in, wire1, wire2, sel[1]);
endmodule

module decoder1_2 (in, out1, out0, sel);
    timeunit 1ps;
	 timeprecision 1ps;
	 input logic in, sel;
    output logic out1, out0;

    logic w;
    
    not #50 n (w, sel);
    and #50 a1 (out1, in, sel);
    and #50 a0 (out0, in, w); 

endmodule