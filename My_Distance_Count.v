module My_Distance_Count
(
	CLK, RTSn, test_count, Hundred, Ten, One, D_Ten, D_Hundred,LED_Out
);
	input CLK;
	input RTSn;
	input test_count;
	output reg [3:0]Hundred;
	output reg [3:0]Ten;
	output reg [3:0]One;
	output reg [3:0]D_Ten;
	output reg [3:0]D_Hundred;
	output reg [7:0]LED_Out;//30cm间隔 88235pulse
	
	reg [23:0] led_case;
	
	reg [23:0]pulse;
	reg [23:0]count1;
	reg [23:0]count2;
	reg [23:0]count3;
	reg [23:0]count4;
	reg [23:0]count5;
	reg [23:0]count6;
	
	reg [23:0]count_f;
	reg [23:0]count_l;
	
	reg t1,t2;
	
	parameter eee = 24'd10294;
	parameter led_30 = 24'd88235;
	parameter H = 24'd294118;
	parameter T = 24'd29412;
	parameter O = 24'd2941;
	parameter DT = 24'd294;
	parameter DH = 24'd29;
	
	reg [23:0]Count_5HZ;
	reg CLK_5HZ;
	
	parameter T5HZ = 24'd4_999_999;

	always @ ( posedge CLK )
		begin 
			if( Count_5HZ == T5HZ )
				begin
					Count_5HZ <= 0;
					CLK_5HZ <= ~CLK_5HZ;
				end
			else
				Count_5HZ <= Count_5HZ + 1;
		end
	
	always @ (posedge CLK)begin
		if(!RTSn)
		begin
			t1 <= 0;
			t2 <= 0;
		end
		else 
		begin
			t1 <= test_count;
			t2 <= t1;
		end
	end
	
	
	always @ (posedge CLK)begin
		if(!RTSn)
		begin
			pulse <= 0;
			count1 <= 0;
			count2 <= 0;
			count3 <= 0;
			count4 <= 0;
			count5 <= 0;
			count6 <= 0;

		end
		else if(test_count== 1)begin
			if(pulse >= 24'd750000)
				begin					
					pulse <= 0;
				end
			else
				begin
					pulse <= pulse + 1;
				end
		end
		else if({t1,t2}==2'b01)begin			
			count1 <= pulse;
			count2 <= count1;
			count3 <= count2;
			count4 <= count3;
			count5 <= count4;
			count6 <= count5;
			pulse <= 0;
		end
		
	end
	
	always @ (posedge CLK_5HZ)begin
		if(!RTSn)
		begin
			count_f <= 0;
			Hundred <= 0;
			Ten <= 0;
			One <= 0;
			D_Ten <= 0;
			D_Hundred <= 0;
		end
		else begin
			count_f <= (count1+count2+count3+count4+count5+count6)/6;
			if(count_f <= eee)
				begin
					Hundred <= 0;
					Ten <= 0;
					One <= 0;
					D_Ten <= 0;
					D_Hundred <= 0;
				end
			else
				begin
					Hundred <= (count_f - eee)/H;
					Ten <= ((count_f - eee)%H)/T;
					One <= (((count_f - eee)%H)%T)/O;
					D_Ten <= ((((count_f - eee)%H)%T)%O)/DT;
					D_Hundred <= (((((count_f - eee)%H)%T)%O)%DT)/DH;
				end
			
		end
	end
	
	always @ (posedge CLK_5HZ)begin
		if(!RTSn)
		begin
			count_l <= 0;
			LED_Out <= 8'b0;
		end
		else begin
			count_l <= (count1+count2+count3+count4+count5+count6)/6;
			if(count_l <= eee)
				begin
					LED_Out <= 8'b0;
				end
			else
				begin
					led_case <= (count_l - eee)/led_30;
					
					case(led_case)
						24'd0:	LED_Out=8'b00000001;
						24'd1:	LED_Out=8'b00000011;
						24'd2:	LED_Out=8'b00000111;
						24'd3:	LED_Out=8'b00001111;
						24'd4:	LED_Out=8'b00011111;
						24'd5:	LED_Out=8'b00111111;
						24'd6:	LED_Out=8'b01111111;
						24'd7:	LED_Out=8'b11111111;				
						default:	LED_Out=8'b11111111;
					endcase

				end	
		end
	end
	
endmodule
