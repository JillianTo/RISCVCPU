module ALU (opA, opB, opCode, result, zero, neg, oddParity, evenParity, overflow);
	input[31:0] opA, opB;
	input[3:0] opCode;
	output reg [31:0] result;
	output zero, neg, oddParity, evenParity, overflow;
	
	always @ (opA or opB or opCode) begin
	
		// ADD = 0000, SUB = 1000, XOR = 0100, AND = 0111, OR = 0110
		case(opCode)
			4'b1000: result <= opA-opB;
			4'b0100: result <= opA^opB;
			4'b0111: result <= opA&opB;
			4'b0110: result <= opA|opB;
			default: result <= opA+opB;
		endcase
		
		
	end
		
	assign neg = result[31];

	assign zero = ~(result[0]|result[1]|result[2]|result[3]|result[4]|result[5]|result[6]|result[7]|result[8]|result[9]|result[10]|result[11]|result[12]|result[13]|result[14]|result[15]|result[16]|result[17]|result[18]|result[19]|result[20]|result[21]|result[22]|result[23]|result[24]|result[25]|result[26]|result[27]|result[28]|result[29]|result[30]|result[31]);

	assign oddParity = result[0]^result[1]^result[2]^result[3]^result[4]^result[5]^result[6]^result[7]^result[8]^result[9]^result[10]^result[11]^result[12]^result[13]^result[14]^result[15]^result[16]^result[17]^result[18]^result[19]^result[20]^result[21]^result[22]^result[23]^result[24]^result[25]^result[26]^result[27]^result[28]^result[29]^result[30]^result[31];

	assign evenParity = ~oddParity;

	assign overflow = ~(((~(opA[31]^opB[31]))^result[31])&(~(opA[31]^opB[31])));
		
endmodule