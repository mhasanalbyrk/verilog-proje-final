module calculator (
			output wire [3:0] rowwrite,
			input [3:0] colread,
			input clk,
			output wire [3:0] grounds,
			output wire [6:0] display,
			//input wire [7:0] secs,
			input pushbutton //may be used as clock
			);
 
reg [15:0] data_all;
wire [3:0] keyout;
reg [25:0] clk1;
reg [1:0] ready_buffer;
reg ack;
reg keypad_ack;
reg keypad_ready;
reg timer_ack;
reg statusordata;
reg timer_ready;
//reg [7:0] secs;
wire [15:0] secs;
 
//memory map is defined here
localparam	BEGINMEM=16'h0000,
		ENDMEM=16'h0fff,
		KEYPAD=16'hefff,
		KEYPADPOLL = 16'hd000,
		SEVENSEG=16'hdfff,
		TIMER=16'hd001,
		TIMERPOLL=16'hd002;
//  memory chip
reg [15:0] memory [0:128]; 
 
// cpu's input-output pins
wire [15:0] data_out;
reg [15:0] data_in;
wire [15:0] address;
wire memwt;

  
digital_clock timer (.clk(clk), .countsec(secs), .pushbutton(pushbutton), .timer_ready(timer_ready), .timer_ack(timer_ack));
 
sev_seg ss1 (.clk(clk), .grounds(grounds), .display(display), .datain(data_all));
 
keypad  kp1(.clk(clk), .rowwrite(rowwrite), .colread(colread), .statusordata(statusordata), .ack(ack), .keyout(keyout));
  //bird_cpu br1 (.clk(~pushbutton), .address(address), .memwt(memwt), .data_in(data_in), .data_out(data_out));
  //keypad_test kp1(.rowwrite(rowwrite), .colread(colread), .clk(clk), .number(keyout));
  
  //keypad_2 kp2 (.clk(clk), .rowwrite(rowwrite), .colread(colread));

bird_cpu br1 (.clk(clk), .address(address), .memwt(memwt), .data_in(data_in), .data_out(data_out));
 
 /*

always@(~pushbutton)
	timer_ready=1;
 
 */
//multiplexer for cpu input
always @*
	if ( (BEGINMEM<=address) && (address<=ENDMEM) )
		begin
			data_in=memory[address];
			ack=0;
			statusordata=0;
		end
	else if (address==KEYPADPOLL)// poll for keypad
		begin	
			statusordata=1;
			data_in=keyout;
			ack=0;
		end
	else if (address==KEYPAD)// load keypad data
		begin
			statusordata=0;
			data_in=keyout;
			ack=1;
		end
	else if (address==TIMER)// load timer
		begin
			timer_ready=0;
			data_in=secs;
			timer_ack=1;
		end
	else if (address==TIMERPOLL)// Poll for timer
		begin
			timer_ready=1;
			data_in=secs;
			timer_ack=0;
		end
	else
		begin
			data_in=16'hf345; //any number
			ack=0;
			statusordata=0;
		end
 
//multiplexer for cpu output 
 
always @(posedge clk) //data output port of the cpu
	if (memwt)
		if ( (BEGINMEM<=address) && (address<=ENDMEM) )
			memory[address]<=data_out;
		else if ( SEVENSEG==address) 
			data_all<=data_out;
 
initial 
	begin
		data_all=4'h0000;
		ack=0;
		statusordata=0;
		$readmemh("ram.dat", memory);
		timer_ready=0;
	end
 
endmodule