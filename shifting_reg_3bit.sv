module shifting_reg_3bit (out, in, clk);
	input logic in, clk;
	output logic [2:0] out;
	
	always_ff @(posedge clk) begin
		out <= {in, out[2:1]};
	end
endmodule