module CPU_tb;
	
	reg clk;
	wire [31:0] regOut1, regOut2, aluOut, ramOut, pc, aluOpA, aluOpB;
	wire zero, neg, oddParity, evenParity, overflow;
	wire [31:0] instr, regDataIn, addr;
	wire [11:0] imm;
	wire[4:0] rs1, rs2, rd;
	wire[3:0] ALUop, cycleCount;
	wire PCSel, ImmSel, RegWEn, BSel, BrUn, ASel, RegSel, MemRW, ramEn, regRst, BrEq, BrLT; 
	
	//CPU cpu (clk, regOut1, regOut2, aluOut, zero, neg, oddParity, evenParity, overflow, ramOut, pc, aluOpA, aluOpB);
	CPU cpu (clk, regOut1, regOut2, aluOut, zero, neg, oddParity, evenParity, overflow, ramOut, pc, instr, imm, rs1, rs2, rd, ALUop, PCSel, ImmSel, RegWEn, BSel, BrUn, ASel, RegSel, MemRW, ramEn, regRst, BrEq, BrLT, cycleCount, regDataIn, aluOpA, aluOpB, addr);
	
	initial begin
		clk <= 1;
		#1500
		$stop;
	end
	
	always begin
		#5
		clk <= ~clk;
	end
	
endmodule