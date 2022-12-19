module PC ( in, out);

	 input [31:0] in; 
	 
	 output reg [31:0] out;
	
	 // setup output	
	 always @(*) begin 
		 out <= in + 32'b0000000000000000000000000000100;
	 end
	
endmodule
		