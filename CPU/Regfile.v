module Regfile (clk, rst, dataIn, rw, rd, rs1, rs2, out1, out2);

	input clk, rw, rst;
	input [31:0] dataIn;
	input [4:0] rd, rs1, rs2;
	
	output reg [31:0] out1, out2;
	
	integer i;
	
	reg [31:0] mem [0:31];
	
	initial begin
		for (i=0; i<32; i=i+1) begin
				mem[i] <= 54;
			end
	end
	
	always @(posedge clk) begin
		if (rst == 1) begin
			for (i=0; i<32; i=i+1) begin
				mem[i] <= 0;
			end
		end
		
		if (rw == 1) begin // write
			mem[rd] <= dataIn;
		end else begin // read
			out1 <= mem[rs1];
			out2 <= mem[rs2];
		end
		
	end
	
endmodule