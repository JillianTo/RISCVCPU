module ROM (clk, address, rs1, rs2, rd, imm, contentout);

	input clk;
	input [7:0] address;
	reg [31:0] content;
	output reg [31:0] contentout;
	output reg [4:0] rs1, rs2, rd;
	output reg [11:0] imm;
	
	integer i;
	
	/*
	reg [7:0] in1;
	reg [7:0] in2;
	reg [7:0] in3;
	reg [7:0] in4;
	*/
	
	reg [7:0] rom [255:0];
	
	initial begin
	
	for (i = 0; i < 256; i = i+1) begin
		rom[i] <= 8'b0;
	end
	
	rom[16] <= 8'b00110011; //add
	rom[17] <= 8'b10000011;
	rom[18] <= 8'b01000010;
	rom[19] <= 8'b00000000;
	
	rom[20] <= 8'b10110011; //sub
	rom[21] <= 8'b00000100;
	rom[22] <= 8'b01010100;
	rom[23] <= 8'b01000000;
	
	rom[24] <= 8'b10110011; //and
	rom[25] <= 8'b01110000;
	rom[26] <= 8'b11010010;
	rom[27] <= 8'b00000000;
	
	rom[28] <= 8'b00110011; //or
	rom[29] <= 8'b11100000;
	rom[30] <= 8'b00110110;
	rom[31] <= 8'b00000001;
	
	rom[32] <= 8'b10110011; //xor
	rom[33] <= 8'b01001010;
	rom[34] <= 8'b11111111;
	rom[35] <= 8'b00000001;
	
	rom[36] <= 8'b00010011; //addi
	rom[37] <= 8'b10000010;
	rom[38] <= 8'b10101000;
	rom[39] <= 8'b00101010;
	
	rom[40] <= 8'b10010011; //andi
	rom[41] <= 8'b11110010;
	rom[42] <= 8'b01011010;
	rom[43] <= 8'b01010101;
	
	rom[44] <= 8'b00010011; //ori
	rom[45] <= 8'b11100011;
	rom[46] <= 8'b10011101;
	rom[47] <= 8'b00011001;
	
	rom[48] <= 8'b10010011; //xori
	rom[49] <= 8'b01000111;
	rom[50] <= 8'b11010101;
	rom[51] <= 8'b01001011;
	
	rom[52] <= 8'b10000011; //lw
	rom[53] <= 8'b00100000;
	rom[54] <= 8'b11110000;
	rom[55] <= 8'b00000000;
	
	rom[56] <= 8'b00100011; //sw
	rom[57] <= 8'b10100110;
	rom[58] <= 8'b01000011;
	rom[59] <= 8'b00000000;
	
	rom[60] <= 8'b01100011; //beq
	rom[61] <= 8'b00000001;
	rom[62] <= 8'b11000011;
	rom[63] <= 8'b00101010;
	
	
	end
	
	always @(posedge clk) begin
	
		
		
		
			if ((address <= 252) && (address >= 0)) begin
			content <= {rom[address+3], rom[address+2], rom[address+1], rom[address]};
			end
		
			else begin
				if (address == 253) content <= {8'd0, rom[address+2], rom[address + 1], rom[address]}; //bits are filled right to left not left to right, correct 
				else if (address == 254) content <= {16'd0, rom[address+1], rom[address]};
				else if (address == 255) content <= {24'd0, rom[address]};
				else content <= 32'b0;
		
			end
			
			contentout <= content;
			
			if (contentout[6:0] == 7'b0110011) begin //R-type
				
				if(contentout[14:12] == 3'b000) begin //ADD, SUB
				
					if(contentout[31:25] == 7'b0000000) begin //ADD
					
						rs1 <= content[19:15];
						rs2 <= content[24:20];
						rd <= content[11:7];
						imm <= 12'b0;
					end
					
					else if(contentout[31:25] == 7'b0100000) begin //SUB
				
						rs1 <= content[19:15];
						rs2 <= content[24:20];
						rd <= content[11:7];
						imm <= 12'b0;

					end
				
				end
			
				
				else if (contentout[14:12] == 3'b111) begin //AND
					
						rs1 <= content[19:15];
						rs2 <= content[24:20];
						rd <= content[11:7];
						imm <= 12'b0;
				
				end
				
				else if(contentout[14:12] == 3'b110) begin //OR
				
						rs1 <= content[19:15];
						rs2 <= content[24:20];
						rd <= content[11:7];
						imm <= 12'b0;
				
				end
				
				else if(contentout[14:12] == 3'b100) begin //XOR
				
						rs1 <= content[19:15];
						rs2 <= content[24:20];
						rd <= content[11:7];
						imm <= 12'b0;
				
				end
			
			end
			
			else if (contentout[6:0] == 7'b0010011) begin //I-type
			
				if(contentout[14:12] == 3'b000) begin //ADDI
				
						rs1 <= content[19:15];
						rd <= content[11:7];
						imm <= content[31:20];
						rs2 <= 5'b0;
				
				end
				
				else if(contentout[14:12] == 3'b111) begin //ANDI
				
						rs1 <= content[19:15];
						rd <= content[11:7];
						imm <= content[31:20];
						rs2 <= 5'b0;
				
				end
				
				else if(contentout[14:12] == 3'b110) begin //ORI
				
						rs1 <= content[19:15];
						rd <= content[11:7];
						imm <= content[31:20];
						rs2 <= 5'b0;
				
				end
				
				else if(contentout[14:12] == 3'b100) begin //XORI
			
						rs1 <= content[19:15];
						rd <= content[11:7];
						imm <= content[31:20];
						rs2 <= 5'b0;
				
				end
			
			
			
			end
			
			else if (contentout[6:0] == 7'b0000011) begin //Load Instruction
			
						rs1 <= content[19:15];
						rd <= content[11:7];
						imm <= content[31:20];
						rs2 <= 5'b0;
			end
			
			else if (contentout[6:0] == 7'b0100011) begin //Store Instruction
			
						imm <= {content[31:25], content[11:7]};
						rs2 <= content[24:20];
						rs1 <= content[19:15];
						rd <= 5'b0;
			
			
			end
			
			else if (contentout[6:0] == 7'b1100011) begin //B-type 
			
				if (contentout[14:12] == 3'b000) begin //BEQ
			
					imm <= {content[31], content[7], content[30:25], content[11:8]};
					rs2 <= content[24:20];
					rs1 <= content[19:15];
					rd <= 5'b0;
				end
				
				else if(contentout[14:12] == 3'b001) begin //BNE
				imm <= {content[31], content[7], content[30:25], content[11:8]};
					rs2 <= content[24:20];
					rs1 <= content[19:15];
					rd <= 5'b0;
				
				end
				
				else if(contentout[14:12] == 3'b100) begin //BLT
				imm <= {content[31], content[7], content[30:25], content[11:8]};
					rs2 <= content[24:20];
					rs1 <= content[19:15];
					rd <= 5'b0;
				
				end
				
				else if(contentout[14:12] == 3'b101) begin //BGE
				imm <= {content[31], content[7], content[30:25], content[11:8]};
					rs2 <= content[24:20];
					rs1 <= content[19:15];
					rd <= 5'b0;
				
				end
				
				else if(contentout[14:12] == 3'b110) begin //BLTu
				imm <= {content[31], content[7], content[30:25], content[11:8]};
					rs2 <= content[24:20];
					rs1 <= content[19:15];
					rd <= 5'b0;
				
				end
				
				else if(contentout[14:12] == 3'b111)begin  //BGEu
				imm <= {content[31], content[7], content[30:25], content[11:8]};
					rs2 <= content[24:20];
					rs1 <= content[19:15];
					rd <= 5'b0;
				
				end
			
			
			end
			
			
		
		
		
		
		
	
	end
	
	
	
	
	
	
endmodule