//module CPU (clk, regOut1, regOut2, aluOut, zero, neg, oddParity, evenParity, overflow, ramOut, addr);
module CPU (clk, regOut1, regOut2, aluOut, zero, neg, oddParity, evenParity, overflow, ramOut, addr, instr, imm, rs1, rs2, rd, ALUop, PCSel, ImmSel, RegWEn, BSel, BrUn, ASel, RegSel, MemRW, ramEn, regRst, BrEq, BrLT, cycleCount, regDataIn, aluOpA, aluOpB, pc);

	input clk;
	
	output wire[31:0] regOut1, regOut2, aluOut, zero, neg, oddParity, evenParity, overflow, ramOut;
	
	output reg[31:0] addr;
	
/*	wire [31:0] instr;
	wire [11:0] imm;
	wire[4:0] rs1, rs2, rd;
	wire[3:0] ALUop;
	wire PCSel, ImmSel, RegWEn, BSel, BrUn, ASel, RegSel, MemRW; */
	
	output wire [31:0] instr;
	output wire [11:0] imm;
	output wire[4:0] rs1, rs2, rd;
	output wire[3:0] ALUop;
	output wire PCSel, ImmSel, RegWEn, BSel, BrUn, ASel, RegSel, MemRW; 
	
	/*reg ramEn, regRst, BrEq, BrLT;
	reg [2:0] cycleCount;
	reg[31:0] regDataIn, aluOpA, aluOpB, pc;*/
	
	output reg ramEn, regRst, BrEq, BrLT;
	output reg [3:0] cycleCount;
	output reg[31:0] regDataIn, aluOpA, aluOpB, pc;
	
	// module CU (clk, instr, PCSel, ImmSel, RegWEn, BSel, BrUn, BrEq, BrLT, ASel, ALUop, RegSel, MemRW);
	CU cu (clk, instr, PCSel, ImmSel, RegWEn, BSel, BrUn, BrEq, BrLT, ASel, ALUop, RegSel, MemRW);
	// module ROM (clk, address, rs1, rs2, rd, imm, contentout);
	ROM rom (clk, addr[7:0], rs1, rs2, rd, imm, instr);
	// module Regfile (clk, rst, dataIn, rw, rd, rs1, rs2, out1, out2);
	Regfile regFile (clk, rst, regDataIn, RegWEn, rd, rs1, rs2, regOut1, regOut2);
	// module RAM (clk, dataIn, addr, en, rw, dataOut);
	RAM ram (clk, aluOut, regOut2, ramEn, MemRW, ramOut);
	// module ALU (opA, opB, opCode, result, zero, neg, oddParity, evenParity, overflow);
	ALU alu (aluOpA, aluOpB, ALUop, aluOut, zero, neg, oddParity, evenParity, overflow);
	//PC pc (pcIn, pcOut);
	
	initial begin
		pc <= 0;
		cycleCount <= -1;
		ramEn <= 1;
		regRst <= 0;
	end
	
	always @ (PCSel or RegSel or ASel or BSel or BrUn or pc or aluOut or ramOut or regOut1 or regOut2 or imm) begin
		
		if (PCSel == 0) addr <= pc;
		else addr <= aluOut;
		
		if(RegSel == 0) regDataIn <= ramOut;
		else regDataIn <= aluOut;
		
		if (ASel == 0) aluOpA <= regOut1;
		else aluOpA <= pc;
		
		if (BSel == 0) aluOpB <= regOut2;
		else aluOpB <= {20'b0, imm};
		
		// start Branch Comparator
		if (BrUn == 1) BrLT <= (regOut1 < regOut2);
		else begin
			if (regOut1[31] ^ regOut2[31]) BrLT <= regOut1[31]; // if signs are different, less than if regOut1 is negative
			else if (regOut1[31] == 0) BrLT <= (regOut1 < regOut2); // if inputs are positive, normal behavior
			else BrLT <= (regOut1 > regOut2); // if inputs are negative, pick number with larger magnitude
		end
			
		if (rs1 == rs2) BrEq <= 1;
		
		// end Branch Comparator
			
		
	end
	
	always @ (posedge clk) begin // program counter
		if(cycleCount == 4) begin
			cycleCount <= 0;
			pc <= pc + 32'b0000000000000000000000000000100;
		end
		else cycleCount <= cycleCount + 1;
	end
	
endmodule