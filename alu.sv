// general ALU which takes 64-bit inputs A, B and a ALU control. 
// Outputs the result, and set zero, overflow, carry out, and negative flag.
module alu (result, A, B, cntrl, zero, overflow, carry_out, negative);
	input logic [63:0] A, B;
	input logic [2:0] cntrl;
	output logic [63:0] result;
	output logic zero, overflow, carry_out, negative;
	
	logic [63:0] carryInNOut;
	
	assign carry_out = carryInNOut[63];
	xor x1 (overflow, carryInNOut[63], carryInNOut[62]);
	assign negative = result[63];
	nor nor1 (zero, result[63], result[62], result[61], result[60], result[59], result[58], result[57], result[56], 
						 result[55], result[54], result[53], result[52], result[51], result[50], result[49], result[48], 
						 result[47], result[46], result[45], result[44], result[43], result[42], result[41], result[40], 
						 result[39], result[38], result[37], result[36], result[35], result[34], result[33], result[32],
						 result[31], result[30], result[29], result[28], result[27], result[26], result[25], result[24], 
						 result[23], result[22], result[21], result[20], result[19], result[18], result[17], result[16], 
						 result[15], result[14], result[13], result[12], result[11], result[10], result[9], result[8], 
						 result[7], result[6], result[5], result[4], result[3], result[2], result[1], result[0]);
						 
	bitALU ba0 (result[0], carryInNOut[0], cntrl[0], A[0], B[0], cntrl);
	genvar i;
	generate 
		for (i = 1; i < 64; i++) begin : eachBit
			bitALU ba (result[i], carryInNOut[i], carryInNOut[i - 1], A[i], B[i], cntrl);
		end
	endgenerate
endmodule

// ALU that only execute 1 bit inputs
module bitALU (R, Cout, Cin, A, B, sel);
	timeunit 1ps;
	timeprecision 1ps;
	input logic A, B, Cin;
	input logic [2:0] sel;
	output logic R, Cout;
	
	logic wireAnd, wireOr, wireXor, wireAdder, notB, BResult;
	and #50 a1 (wireAnd, A, B);
	or #50 o1 (wireOr, A, B);
	xor #50 x1 (wireXor, A, B);
	not #50 n1 (notB, B);
	mux2_1 m2 (sel[0], notB, B, BResult);
	FullAdder fa (wireAdder, Cout, Cin, A, BResult);
	
	mux8_1 m8 (sel, {1'b0, wireXor, wireOr, wireAnd, wireAdder, wireAdder, 1'b0, B}, R);
	
endmodule

// Add 64 bits input. Can't subtract. But Add a negative number is okay.
module Addr_64bit (S, in1, in2, overflow);
	timeunit 1ps;
	timeprecision 1ps;
	output logic [63:0] S;
	output logic overflow;
	input logic [63:0] in1, in2;
	
	logic [63:0] CInNOut;
	genvar i;
	generate
	for (i = 1; i < 63; i++) begin : eachFA
		FullAdder fas (S[i], CInNOut[i], CInNOut[i - 1], in1[i], in2[i]);
	end
	endgenerate
	FullAdder fa64 (S[63], CInNOut[63], CInNOut[62], in1[63], in2[63]);
	FullAdder fa0 (S[0], CInNOut[0], 1'b0, in1[0], in2[0]);
	xor #50 xo (overflow, CInNOut[63], CInNOut[62]);
	
endmodule

// Simple Full Adder
module FullAdder (S, Cout, Cin, A, B);
	timeunit 1ps;
	timeprecision 1ps;
	input logic Cin, A, B;
	output logic S, Cout;
	
	logic wire1, wire2, wire3;
	
	xor #50 x1 (S, A, B, Cin);
	and #50 a1 (wire1, A, B);
	and #50 a2 (wire2, B, Cin);
	and #50 a3 (wire3, A, Cin);
	or #50 o1 (Cout, wire1, wire2, wire3);
	
endmodule
