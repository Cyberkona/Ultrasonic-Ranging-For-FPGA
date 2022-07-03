module dis_sound(
 CLK, RSTn, pulse_r, pulse_t, test_count, Digitron_Out, DigitronCS_Out,LED_Out
);
	input CLK;
	input RSTn; 
	input pulse_r;
	input pulse_t;
	output reg test_count;
	output [7:0]Digitron_Out;
	output [5:0]DigitronCS_Out;
	output [7:0]LED_Out;
	
	parameter headshoulders=12'd100;
	reg [11:0] count_hs;
	
	reg R1,R2;
	reg T1,T2;
	
	wire [3:0]Hundred;
	wire [3:0]Ten;
	wire [3:0]One;
	wire [3:0]D_Ten;
	wire [3:0]D_Hundred;

	always @ (posedge CLK) begin
		if(!RSTn)
			begin
				R1 <= 0;
				R2 <= 0;
				T1 <= 0;
				T2 <= 0;				
			end
		else
			begin
				R1 <= pulse_r;
				R2 <= R1;
				T1 <= pulse_t;
				T2 <= T1;	
			end
	end
			
	always @ (posedge CLK) begin
		if(!RSTn)
			begin
				test_count <= 0;
			end
		else if({T1,T2}==2'b10) begin		//调制波上升沿
				test_count <= 1;
			end
		else if(count_hs >= 12'd100) 		//回波下降沿记满间隔
			begin				
				if({R1,R2}==2'b10)			//回波上升沿
					test_count <= 0;
				else if({R1,R2}==2'b01)    //回波下降沿
					count_hs <= 0;	
			end
		else 
			count_hs <= count_hs + 1;
	end
	

	My_Distance_Count U1
(
	.CLK(CLK) ,	// input  CLK_sig
	.RTSn(RSTn) ,	// input  RTSn_sig
	.test_count(test_count) ,	// input  test_count_sig
	.Hundred(Hundred) ,	// output [3:0] Hundred_sig
	.Ten(Ten) ,	// output [3:0] Ten_sig
	.One(One) ,	// output [3:0] One_sig
	.D_Ten(D_Ten) ,	// output [3:0] D_Ten_sig
	.D_Hundred(D_Hundred) ,	// output [3:0] D_Hundred_sig
	.LED_Out(LED_Out) 	// output [7:0] LED_Out_sig
);

	My_Dig U2
(
	.CLK(CLK) ,	// input  CLK_sig
	.Hundred(Hundred) ,	// input [3:0] Hundred_sig
	.Ten(Ten) ,	// input [3:0] Ten_sig
	.One(One) ,	// input [3:0] One_sig
	.D_Ten(D_Ten) ,	// input [3:0] D_Ten_sig
	.D_Hundred(D_Hundred) ,	// input [3:0] D_Hundred_sig
	.Digitron_Out(Digitron_Out) ,	// output [7:0] Digitron_Out_sig
	.DigitronCS_Out(DigitronCS_Out) 	// output [5:0] DigitronCS_Out_sig
);
				
endmodule	