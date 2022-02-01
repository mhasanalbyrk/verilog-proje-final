module digital_clock(input clk, output reg  [15:0] countsec);

reg [25:0] clk1;



always @(posedge clk)
			clk1<=clk1+1;

			
			
always @(posedge clk1[21])
	begin
		countsec<= countsec + 1;
	end	

endmodule