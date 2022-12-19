module CU (clk, instr, PCSel, ImmSel, RegWEn, BSel, BrUn, BrEq, BrLT, ASel, ALUop, RegSel, MemRW);
	input clk, BrEq, BrLT;
	input[31:0] instr;
	output reg PCSel, ImmSel, RegWEn, BSel, BrUn, ASel, RegSel, MemRW;
	output reg [3:0] ALUop;
	
	reg [3:0] cycleCount;
	
	initial begin
		cycleCount <= -1;
	end
	always @(posedge clk) begin
		
		if(cycleCount == 4) cycleCount <= 0;
		else cycleCount <= cycleCount + 1;
		
		case(instr[6:0]) 
			7'b1100011: begin // branch
				
				ImmSel <= 1;
				BSel <= 1;
				ASel <= 1;
				ALUop <= 4'b0000;
				RegWEn <= 0;
				 
				case(instr[14:12])
					000: begin // BEQ
						if(BrEq == 1) PCSel <= 1;
						else PCSel <= 0;
						
						BrUn <= 0;
					end
					001: begin // BNE
						if(BrEq == 0) PCSel <= 1;
						else PCSel <= 0;
						
						BrUn <= 0;
					end
					100: begin // BLT
						if(BrLT == 1) PCSel <= 1;
						else PCSel <= 0;
						
						BrUn <= 0;
					end
					101: begin // BGE
						if(BrEq == 0 && BrLT == 0) PCSel <= 1;
						else PCSel <= 0;
						
						BrUn <= 0;
					end
					110: begin // BLTU
						if(BrLT == 1) PCSel <= 1;
						else PCSel <= 0;
						
						BrUn <= 1;
					end
					111: begin // BGEU
						if(BrEq == 0 && BrLT == 0) PCSel <= 1;
						else PCSel <= 0;

						BrUn <= 1;
					end
				endcase
				
			end
			7'b0000011: begin // LW
			
				PCSel <= 0;
				ImmSel <= 1;
				BSel <= 1;
				ASel <= 0;
				ALUop <= 4'b0000;
				RegSel <= 0;
				MemRW <= 0;
				
				if(cycleCount == 4) RegWEn <= 1;
				else RegWEn <= 0;
				
			end
			7'b0100011: begin // SW
			
				PCSel <= 0;
				ImmSel <= 1;
				RegWEn <= 0;
				BSel <= 1;
				ASel <= 0;
				ALUop <= 4'b0000;
				MemRW <= 1;
			
			end
			7'b0010011: begin // logical imm
			
				PCSel <= 0;
				ImmSel <= 1;
				BSel <= 1;
				ASel <= 0;
				RegSel <= 1;
				
				ALUop <= {1'b0,instr[14:12]};
				
				if(cycleCount == 4) RegWEn <= 1;
				else RegWEn <= 0;
				
			end
			7'b0110011: begin // logical
			
				PCSel <= 0;
				ImmSel <= 0;
				BSel <= 0;
				ASel <= 0;
				RegSel <= 1;
				
				ALUop[2:0] <= instr[14:12];
				if((instr[30] == 1) && (instr[14:12] == 3'b000)) ALUop[3] <= 1; // SUB
				else ALUop[3] <= 0;
				
				if(cycleCount == 4) RegWEn <= 1;
				else RegWEn <= 0;
				
			end
			default: begin
				PCSel <= 0;
				ImmSel <= 0;
				RegWEn <= 0; 
				BSel <= 0; 
				BrUn <= 0; 
				ASel <= 0; 
				RegSel <= 0; 
				MemRW <= 0;
				ALUop <= 4'b0;
			end
			
		endcase
	end
	
endmodule