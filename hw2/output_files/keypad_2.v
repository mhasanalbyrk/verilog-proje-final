module keypad_test(
						output reg [3:0] rowwrite, // x1-4 GPIO 27, 29, 31, 33
						input [3:0] colread, //y1-y4 GPIO 26, 28, 30, 32
						input clk, //r8
						output reg [15:0] data,
						input keypad_ready,
						input keypad_ack,
						output reg [15:0] keyout
);


reg [25:0] clk1;
reg rowpressed;
reg [3:0] keyread;
reg state;

reg ready;



always @(posedge clk)
		begin
			if((keypad_ack==1)&&(ready==1))
				ready <= 0;
			else if((ready == 0) && rowpressed)
				ready<=1;
end


always @(posedge clk)
			clk1<=clk1+1;

always @(posedge clk1[20])
	begin
		rowwrite<= {rowwrite[2:0], rowwrite[3]};
		//secs<= secs + 1;
	end	
	
	
always @(posedge clk1[20])
	begin
		if (rowwrite==4'b1110&&colread==4'b1110)
			begin
				keyread=4'h1;
				rowpressed=1;
			end
		else if (rowwrite==4'b1110&&colread==4'b1101)
			begin
				keyread=4'h2;
				rowpressed=1;
			end
		else if (rowwrite==4'b1110&&colread==4'b1011)
			begin
				keyread=4'h3;
				rowpressed=1;
			end
		else if (rowwrite==4'b1110&&colread==4'b0111)
			begin
				keyread=4'hA;
				rowpressed=1;
			end
			
			
		else if (rowwrite==4'b1101&&colread==4'b1110)
			begin
				keyread=4'h4;
				rowpressed=1;
			end
		else if (rowwrite==4'b1101&&colread==4'b1101)
			begin
				keyread=4'h5;
				rowpressed=1;
			end
		else if (rowwrite==4'b1101&&colread==4'b1011)
			begin
				keyread=4'h6;
				rowpressed=1;
			end
		else if (rowwrite==4'b1101&&colread==4'b0111)
			begin
				keyread=4'hB;
				rowpressed=1;
			end
			
			
		else if (rowwrite==4'b1011&&colread==4'b1110)
			begin
				keyread=4'h7;
				rowpressed=1;
			end
		else if (rowwrite==4'b1011&&colread==4'b1101)
			begin
				keyread=4'h8;
				rowpressed=1;
			end
		else if (rowwrite==4'b1011&&colread==4'b1011)
			begin
				keyread=4'h9;
				rowpressed=1;
			end
		else if (rowwrite==4'b1011&&colread==4'b0111)
			begin
				keyread=4'hC;
				rowpressed=1;
			end
			
			
		else if (rowwrite==4'b0111&&colread==4'b1110)
			begin
				keyread=4'hE;//star
				rowpressed=1;
			end
		else if (rowwrite==4'b0111&&colread==4'b1101)
			begin
				keyread=4'h0;
				rowpressed=1;
			end
		else if (rowwrite==4'b0111&&colread==4'b1011)
			begin
				keyread=4'hF;//sharp
				rowpressed=1;
			end
		else if (rowwrite==4'b0111&&colread==4'b0111)
			begin
				keyread=4'hD;
				rowpressed=1;
			end
		else
			rowpressed=0;
end


always@(posedge clk)
begin
	case(state)
		1'b0:
			begin
				if((rowpressed==1) && (ready == 1))
					begin
						keyout<={12'h0, keyread};
						state<=1;
					end
				else 
					state<=0;
			end
		1'b1:
			begin
				if(rowpressed==1)
					state<=1;
				else
					state<=0;
			end
	endcase		
end

	

	
			
initial begin
	clk1=0;
	rowwrite=4'b1110;
	keyread=4'b0011;
	state=0;
	end
endmodule