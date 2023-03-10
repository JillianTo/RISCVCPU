module RAM (clk, dataIn, addr, en, rw, dataOut);
	input [31:0] dataIn;
	input [31:0] addr;
	input en, rw, clk;
	output reg [31:0] dataOut;
	
	reg [7:0] chip [0:255][0:7];
	
	integer i0, i1;
	
	initial begin
		for (i0 = 0; i0<256; i0=i0+1) begin // initialize all ram addresses as 0
			for (i1 = 0; i1<8; i1=i1+1) begin
				chip [i0][i1] <= 8'b0;
			end
		end
	end
	
	always @(posedge clk) begin
		if (en == 1) begin
			if (rw == 1) begin // write
				chip[addr[7:0]][addr[10:8]] <= dataIn[7:0]; 
				chip[addr[7:0]+1][addr[10:8]] <= dataIn[15:8]; 
				chip[addr[7:0]+2][addr[10:8]] <= dataIn[23:16]; 
				chip[addr[7:0]+3][addr[10:8]] <= dataIn[31:24]; 
				dataOut <= 32'b0;
			end
			else dataOut <= {chip[addr[7:0]+3][addr[10:8]],chip[addr[7:0]+2][addr[10:8]],chip[addr[7:0]+1][addr[10:8]],chip[addr[7:0]][addr[10:8]]};
		end
	end

endmodule