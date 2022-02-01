module digital_clock(input clk, output reg  [15:0] countsec, input pushbutton, input  timer_ready, input timer_ack);

reg [25:0] clk1;
reg [15:0] localsec;
reg ready;
reg buffer;

always@(~pushbutton)
	buffer<=1;
 
always @(posedge clk)
		clk1<=clk1+1;

			
			
always @ (posedge clk)
	begin
		if((timer_ack==1)&&(ready==1))
			ready <= 0;
		else if((ready == 0) && ~pushbutton)
			ready<=1;
	end


			
always @(posedge clk1[21])
	begin
		localsec<= localsec + 1;
	end	
	
	
	
/*
always @(*)
	if (statusordata==1)
		keyout={15'b0,ready};
	else
		keyout={12'b0,data};	
	
	*/
	
	
	
always @(*)
	begin
		if(timer_ready == 1)
			countsec = ready;
		else
			countsec = localsec;
end	

endmodule