module PipliningCPU (running, clk, reset);
	input logic clk, reset;
	output logic running;
	
	assign running = 1;
	
	// RegFile I/O
	logic [4:0] Rd, Rn, Rm;
	logic [63:0] nextData, Db;
	logic [31:0] instruction;
	logic [63:0] instruAddress;
	
	// control signals
	logic MemWrite, RegWrite, Reg2Loc, UnCondBr, BrTaken, MemToReg, MovMuxSel, ByteOp;
	logic [2:0] ALUOp;
	logic [1:0] ALUSrc;
	
	// control signals that is stored in shifting register
	logic [2:0] MemWrite3b, RegWrite3b, Reg2Loc3b, UnCondBr3b, BrTaken3b, MemToReg3b, 
				MovMuxSel3b, ByteOp3b;
	logic [2:0][2:0] ALUOp3b;
	logic [1:0][2:0] ALUSrc3b;
	
	// mux to ALU source B
	logic [63:0] ALUA, ALUB;
	
	// Sign Extentions
	logic [63:0] SEDaddr, SEImm12, EImm16, ShiftedImm16;
	
	// ALU I/O
	logic [63:0] AluResult;
	
	// data memory
	logic [63:0] dataFromMem;
	
	assign Rd = instruction[4:0];
	assign Rn = instruction[9:5];
	assign Rm = instruction[20:16];
	
	// Flag Registers:
	logic zero, overflow, carryout, negative, SetFlag;  // value
	logic zeroPort, overflowPort, carryoutPort, negativePort; // ALUPort
	logic toZeroDff, toNegativeDff, toCarryoutDff, toOverflowDff;

	mux2_1 zeromux (.sel(SetFlag), .in1(zeroPort), .in0(zero), .out(toZeroDff));
	D_FF zeroDff (.q(zero), .d(toZeroDff), .clk, .reset);
	
	mux2_1 negativemux (.sel(SetFlag), .in1(negativePort), .in0(negative), .out(toNegativeDff));
	D_FF negativeDff (.q(negative), .d(toNegativeDff), .clk, .reset);
	
	mux2_1 carryoutmux (.sel(SetFlag), .in1(carryoutPort), .in0(carryout), .out(toCarryoutDff));
	D_FF carryoutDff (.q(carryout), .d(toCarryoutDff), .clk, .reset);
	
	mux2_1 overflowmux (.sel(SetFlag), .in1(overflowPort), .in0(overflow), .out(toOverflowDff));
	D_FF overflowDff (.q(overflow), .d(toOverflowDff), .clk, .reset);
	
	// Program Counter
	ProgramCounter PC (.counter(instruAddress), .clk, .UnCondBr, .BrTaken, 
							 .CondAddr19(instruction[23:5]), .BrAddr26(instruction[25:0]), .reset);
	
	instructmem im (instruAddress, instruction, clk);
	
	// the Reg2Loc controlled MUX to Ab port of RegFile
	logic [4:0] MuxToAb;
	mux2_1_5bit m5 (.in1(Rm), .in0(Rd), .sel(Reg2Loc), .dataOut(MuxToAb));
	
	
	
	// RegFile
	regfile rf (.ReadRegister1(Rn), .ReadRegister2(MuxToAb), .ReadData1(ALUA), .ReadData2(Db),
					.RegWrite(RegWrite3b[0]), .WriteRegister(Rd), .WriteData(nextData), .clk, .reset);
	
	assign SEDaddr = 64'(signed'(instruction[20:12]));
	assign SEImm12 = 64'(signed'(instruction[21:10]));
	
	assign EImm16 = {48'b0, instruction[20:5]};
	
	logic [63:0] shiftDistance, mult_high;  // not using it but have a wire connected to the port.  
	mult mult1 (.A(64'd16), .B({62'd0, instruction[22:21]}), .doSigned(1'b0), 
				.mult_low(shiftDistance), .mult_high(mult_high));
				
	shifter shifter4Mov (.value(EImm16), .direction(1'b0), .distance(shiftDistance[5:0]), 
					     .result(ShiftedImm16));
	
	// MOVK Pass B from Rd and change the data (from 16*shamt + 15 to 16*shamt) to Imm16
	logic [63:0] MovkOut;
	combine movk (.shamt(instruction[22:21]), .Db, .Imm16(instruction[20:5]),.out(MovkOut));
	
	//the MovMux controlled MUX to movz or movk
	logic [63:0] MovMux;
	mux2_1_64bit movMux2_1 (.in1(MovkOut), .in0(ShiftedImm16), .sel(MovMuxSel3b[2]), .dataOut(MovMux));
	
	mux4_1_64bit mux1 (.sel({ALUSrc3b[1][2], ALUSrc3b[0][2]}), 
					   .dataIn({MovMux, SEImm12, SEDaddr, Db}), .dataOut(ALUB));
	
	alu ALU (.result(AluResult), .A(ALUA), .B(ALUB), .cntrl(ALUOp3b[2][2], ALUOp3b[1][2],ALUOp3b[0][2]), 
			 .zero(zeroPort), .overflow(overflowPort), .carry_out(carryoutPort), .negative(negativePort));
	
	// controlled the MUX that select STURB/LDURB or STUR/LDUR	
	logic [3:0] ByteOpMux;
	mux2_1_4bit bOrNb2_1 (.in1(4'b1), .in0(4'd8), .sel(ByteOp3b[1]), .dataOut(ByteOpMux));
	
	datamem dm (.address(AluResult), .write_enable(MemWrite3b[1]), .read_enable(MemToReg3b[1]), 
				.write_data(Db), .clk, .xfer_size(ByteOpMux), .read_data(dataFromMem));
	
    
	
	// controlled the MUX that select LDURB or LDUR	
	logic [63:0] LByteOpMux;
	mux2_1_64bit LByteOpMux2_1 (.in1({56'b0, dataFromMem[7:0]}), .in0(dataFromMem), 
								.sel(ByteOp3b[1]), .dataOut(LByteOpMux));
	
	
	
	// MemToReg Mux
	mux2_1_64bit mux2 (.in1(LByteOpMux), .in0(AluResult), .sel(MemToReg3b[1]), .dataOut(nextData));
	
	// Control signal registers that stores signal up to 3 cycles
	// shifting_reg_3bit Reg2LocSR (.out(Reg2Loc3b), .in(Reg2Loc), .clk);
	shifting_reg_3bit ALUSrcSR1 (.out(ALUSrc3b[1]), .in(ALUSrc[1]), .clk);
	shifting_reg_3bit ALUSrcSR0 (.out(ALUSrc3b[0]), .in(ALUSrc[0]), .clk);
	shifting_reg_3bit MemToRegSR (.out(MemToReg3b), .in(MemToReg), .clk);
	shifting_reg_3bit RegWriteSR (.out(RegWrite3b), .in(RegWrite), .clk);
	shifting_reg_3bit MemWriteSR (.out(MemWrite3b), .in(MemWrite), .clk);
	// shifting_reg_3bit BrTakenSR (.out(BrTaken3b), .in(BrTaken), .clk);
	// shifting_reg_3bit UnCondBrSR (.out(UnCondBr3b), .in(UnCondBr), .clk);
	shifting_reg_3bit ALUOpSR2 (.out(ALUOp3b[2]), .in(ALUOp[2]), .clk);
	shifting_reg_3bit ALUOpSR1 (.out(ALUOp3b[1]), .in(ALUOp[1]), .clk);
	shifting_reg_3bit ALUOpSR0 (.out(ALUOp3b[0]), .in(ALUOp[0]), .clk);
	shifting_reg_3bit SetFlagSR (.out(SetFlag3b), .in(SetFlag), .clk);
	shifting_reg_3bit MovMuxSelSR (.out(MovMuxSel3b), .in(MovMuxSel), .clk);
	shifting_reg_3bit ByteOpSR (.out(ByteOp3b), .in(ByteOp), .clk);
	// Control Logic
	always_comb
	begin
		case(instruction[31:21])
			11'b10001011000: begin       //ADD
				Reg2Loc = 1'b1;
				ALUSrc = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b1;
				MemWrite = 1'b0;
				BrTaken = 1'b0;
				UnCondBr = 1'bx;
				ALUOp = 3'b010;
				SetFlag = 1'b0;
				MovMuxSel = 1'bx;
				ByteOp = 1'b0;
			end
			11'b10101011000: begin       //ADDS
				Reg2Loc = 1'b1;
				ALUSrc = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b1;
				MemWrite = 1'b0;
				BrTaken = 1'b0;
				UnCondBr = 1'bx;
				ALUOp = 3'b010;
				SetFlag = 1'b1;
				MovMuxSel = 1'bx;
				ByteOp = 1'b0;
			end
			11'b11001011000: begin			//SUB
				Reg2Loc = 1'b1;
				ALUSrc = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b1;
				MemWrite = 1'b0;
				BrTaken = 1'b0;
				UnCondBr = 1'bx;
				ALUOp = 3'b011;
				SetFlag = 1'b0;
				MovMuxSel = 1'bx;
				ByteOp = 1'b0;
			end
			11'b11101011000: begin       //SUBS
				Reg2Loc = 1'b1;
				ALUSrc = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b1;
				MemWrite = 1'b0;
				BrTaken = 1'b0;
				UnCondBr = 1'bx;
				ALUOp = 3'b011;
				SetFlag = 1'b1;
				MovMuxSel = 1'bx;
				ByteOp = 1'b0;
			end
			11'b11111000010: begin			//LDUR
				Reg2Loc = 1'bx;
				ALUSrc = 2'b01;
				MemToReg = 1'b1;
				RegWrite = 1'b1;
				MemWrite = 1'b0;
				BrTaken = 1'b0;
				UnCondBr = 1'bx;
				ALUOp = 3'b010;
				SetFlag = 1'b0;
				MovMuxSel = 1'bx;
				ByteOp = 1'b0;
			end
			11'b11111000000: begin			//STUR
				Reg2Loc = 1'b0;
				ALUSrc = 2'b01;
				MemToReg = 1'bx;
				RegWrite = 1'b0;
				MemWrite = 1'b1;
				BrTaken = 1'b0;
				UnCondBr = 1'bx;
				ALUOp = 3'b010;
				SetFlag = 1'b0;
				MovMuxSel = 1'bx;
				ByteOp = 1'b0;
			end
			11'h1c2: begin			       //LDURB
    			Reg2Loc = 1'bx;
    			ALUSrc = 2'b01;
    			MemToReg = 1'b1;
    			RegWrite = 1'b1;
    			MemWrite = 1'b0;
    			BrTaken = 1'b0;
    			UnCondBr = 1'bx;
    			ALUOp = 3'b010;
    			SetFlag = 1'b0;
				MovMuxSel = 1'bx;
				ByteOp = 1'b1;
         end
         11'h1c0: begin			      //STURB
            Reg2Loc = 1'b0;
            ALUSrc = 2'b01;
        	MemToReg = 1'bx;
    		RegWrite = 1'b0;
    		MemWrite = 1'b1;
        	BrTaken = 1'b0;
            UnCondBr = 1'bx;
        	ALUOp = 3'b010;
    		SetFlag = 1'b0;
			MovMuxSel = 1'bx;
			ByteOp = 1'b1;
         end
			
			default: begin
				if (instruction[31:26] == 6'b000101) begin  // B
					Reg2Loc = 1'bx;
					ALUSrc = 2'b0x;
					MemToReg = 1'bx;
					RegWrite = 1'b0;
					MemWrite = 1'b1;
					BrTaken = 1'b1;
					UnCondBr = 1'b1;
					ALUOp = 3'bx;
					SetFlag = 1'b0;
					MovMuxSel = 1'bx;
					ByteOp = 1'b0;
				end else if (instruction[31:24] == 8'b10110100) begin // CBZ
					Reg2Loc = 1'b0;
					ALUSrc = 2'b00;
					MemToReg = 1'bx;
					RegWrite = 1'b0;
					MemWrite = 1'b0;
					BrTaken = zeroPort;
					UnCondBr = 1'b0;
					ALUOp = 3'b000;
					SetFlag = 1'b0;
					MovMuxSel = 1'bx;
					ByteOp = 1'b0;
				end else if (instruction[31:24] == 8'b01010100) begin //B.LT
					Reg2Loc = 1'bx;
					ALUSrc = 2'bx;
					MemToReg = 1'bx;
					RegWrite = 1'b0;
					MemWrite = 1'b0;
					BrTaken = (negative != overflow);
					UnCondBr = 1'b0;
					ALUOp = 3'b000;
					SetFlag = 1'b0;
					MovMuxSel = 1'bx;
					ByteOp = 1'b0;
				end else begin // Stall
					Reg2Loc = 1'bx;
					ALUSrc = 2'bx;
					MemToReg = 1'bx;
					RegWrite = 1'b0;
					MemWrite = 1'b0;
					BrTaken = 1'b0;
					UnCondBr = 1'bx;
					ALUOp = 3'bxxx;
					SetFlag = 1'b0;
					MovMuxSel = 1'bx;
					ByteOp = 1'bx;
			end
		endcase
		
		case(instruction[31:23])
    		9'b111100101: begin      //MOVK
				Reg2Loc = 1'b0;
    			ALUSrc = 2'b11;
    			MemToReg = 1'b0;
    			RegWrite = 1'b1;
    			MemWrite = 1'b0;
    			BrTaken = 1'b0;
    			UnCondBr = 1'bx;
    			ALUOp = 3'b000;
    			SetFlag = 1'b0;
				MovMuxSel = 1'b1;
				ByteOp = 1'b0;
         end
         9'b110100101: begin      //MOVZ
            Reg2Loc = 1'bx;
            ALUSrc = 2'b11;
           	MemToReg = 1'b0;
           	RegWrite = 1'b1;
           	MemWrite = 1'b0;
           	BrTaken = 1'b0;
           	UnCondBr = 1'bx;
           	ALUOp = 3'b000;
           	SetFlag = 1'b0;
			MovMuxSel = 1'b0;
			ByteOp = 1'b0;
         end
		   default: ;
		endcase
			
		case(instruction[31:22])
			10'h244: begin    // ADDI 
				Reg2Loc = 1'bx;
				ALUSrc = 2'b10;
				MemToReg = 1'b0;
				RegWrite = 1'b1;
				MemWrite = 1'b0;
				BrTaken = 1'b0;
				UnCondBr = 1'bx;
				ALUOp = 3'b010;
				SetFlag = 1'b0;
				MovMuxSel = 1'bx;
				ByteOp = 1'b0;
			end
			10'h344: begin    // SUBI 
				Reg2Loc = 1'bx;
				ALUSrc = 2'b10;
				MemToReg = 1'b0;
				RegWrite = 1'b1;
				MemWrite = 1'b0;
				BrTaken = 1'b0;
				UnCondBr = 1'bx;
				ALUOp = 3'b011;
				SetFlag = 1'b0;
				MovMuxSel = 1'bx;
				ByteOp = 1'b0;
			end
			default: ;
		endcase
	end
endmodule
