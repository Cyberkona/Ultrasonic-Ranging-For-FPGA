module My_Dig
(
	CLK, Hundred, Ten, One, D_Ten, D_Hundred, Digitron_Out, DigitronCS_Out
);
	 input CLK;
	 input [3:0] Hundred;
	 input [3:0] Ten;
	 input [3:0] One;
	 input [3:0] D_Ten;
	 input [3:0] D_Hundred;
	 output [7:0]Digitron_Out; 
	 output [5:0]DigitronCS_Out;

    parameter T250K = 24'd200000;
	 reg [23:0]Count;
	 reg [3:0]SingleNum;
	 reg [7:0]W_Digitron_Out;
	 reg [5:0]W_DigitronCS_Out;
	 
	 parameter _0 = 8'b0011_1111, _1 = 8'b0000_0110, _2 = 8'b0101_1011,
			 	  _3 = 8'b0100_1111, _4 = 8'b0110_0110, _5 = 8'b0110_1101,
			 	  _6 = 8'b0111_1101, _7 = 8'b0000_0111, _8 = 8'b0111_1111,
				  _9 = 8'b0110_1111;
		
	always @ ( posedge CLK )
		begin	
			 if( Count == T250K )
				begin
					Count <= 16'd0;
					W_DigitronCS_Out = {1'b1,W_DigitronCS_Out[0],W_DigitronCS_Out[4:1]};

					case(W_DigitronCS_Out)
						6'b11_1110: SingleNum = D_Hundred;		
						6'b11_1101: SingleNum = D_Ten;		
						6'b11_1011: SingleNum = One;	
						6'b11_0111: SingleNum = Ten;		
						6'b10_1111: SingleNum = Hundred;		
						default:	W_DigitronCS_Out = 6'b11_1110;
					endcase

					case(SingleNum)
						0:  W_Digitron_Out = _0;
						1:  W_Digitron_Out = _1;
						2:  W_Digitron_Out = _2;
						3:  W_Digitron_Out = _3;
						4:  W_Digitron_Out = _4;
						5:  W_Digitron_Out = _5;
						6:  W_Digitron_Out = _6;
						7:  W_Digitron_Out = _7;
						8:  W_Digitron_Out = _8;
						9:  W_Digitron_Out = _9;
					endcase
				end
			else
				Count <= Count + 1'b1;
	end
 
	 assign Digitron_Out = (W_DigitronCS_Out == 6'b11_1011) ? {1'b1,W_Digitron_Out[6:0]} : W_Digitron_Out;
	 assign DigitronCS_Out = W_DigitronCS_Out;
	
endmodule