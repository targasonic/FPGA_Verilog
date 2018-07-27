module stereo_vision_control
(
	input nRESET,
	input CLK,
	//
	inout STEREO_SDA,	
	inout STEREO_SCL,
	//
	input MODE_CAMERA, // 0 master, 1 slave
	//
	input  GAIN_TO_SLAVE,
	output GAIN_FROM_MASTER,
	input  [31:0] INT_TIME_TO_SLAVE,
	output [31:0] INT_TIME_FROM_MASTER,
	input  [31:0] ZOOM_TO_SLAVE,
	output [31:0] ZOOM_FROM_MASTER
);

	parameter [6:0]  control_start_word = 42;

	reg sda_in;
	reg scl_in;
	reg sda_out;
	reg scl_out;
	reg sda = 1;
	//reg scl;

	// Declare states of state machine
	reg state_master;
	parameter state_master_pause  = 0, state_master_tx = 1;
	
	reg state_slave;
	parameter state_slave_pause  = 0, state_slave_rx = 1;

	reg [15:0] counter_master;
	reg [15:0] counter_slave;
	
	reg [71:0] data_input; 
	reg [71:0] data_out;
	reg 	   gain_from_master_reg;
	reg [31:0] int_time_from_master_reg;
	reg [31:0] zoom_from_master_reg;
	
	assign GAIN_FROM_MASTER 	  = gain_from_master_reg;
	assign INT_TIME_FROM_MASTER = int_time_from_master_reg;
	assign ZOOM_FROM_MASTER 	  = zoom_from_master_reg;	
	assign STEREO_SDA           = (!MODE_CAMERA)? sda_out : 1'bz; // if master then STEREO_SDA <- sda_out
	assign STEREO_SCL           = (!MODE_CAMERA)? scl_out : 1'bz; // if master then STEREO_SCL <- scl_out
	

	always @ (*)
	begin 
		if (MODE_CAMERA) 
		begin		
			sda_in <= STEREO_SDA;
			scl_in <= STEREO_SCL;
		end 
		else
		begin
			sda_out <= sda;
			scl_out <= CLK;
		end
	end
	
	// i2c master proccess
	always @ (posedge CLK)
		begin
			if ((nRESET) && (!MODE_CAMERA))
				begin
					case (state_master)
						state_master_pause:
						begin
							sda = 1;
							data_out[0]		= 0;
							data_out[6:1]   = control_start_word;
							data_out[7]     = GAIN_TO_SLAVE;
							data_out[39:8]  = INT_TIME_TO_SLAVE;
							data_out[71:40] = ZOOM_TO_SLAVE;
							if (counter_master < 50)
								begin 
								counter_master = counter_master + 1;
								end
							else
								begin
								counter_master = 0;
								state_master <= state_master_tx;
								end
						end
						
						state_master_tx:	
						begin
							if (counter_master < 72)
								begin 
								sda = data_out[counter_master];
								counter_master = counter_master + 1;
								end
							else
								begin
								sda = 1;
								counter_master = 0;
								state_master <= state_master_pause;
								end
						end
						
						default:	
						begin
							counter_master = 0;
							state_master <= state_master_pause;
						end
					endcase	
				end
			else 
			begin
				sda = 1;
				counter_master = 0;
				state_master <= state_master_pause;
			end
			
		end

	// i2c SLAVE proccess
	always @ (posedge scl_in)
		begin
			if ((nRESET) && (MODE_CAMERA))
				begin
					case (state_slave)
						state_slave_pause:
						begin
							if (data_input[6:1] == control_start_word)
							begin
								gain_from_master_reg 	 = data_input[7];
								int_time_from_master_reg = data_input[39:8];
								zoom_from_master_reg	 = data_input[71:40];
							end			
							if (!sda_in)
							begin
								data_input[0] = sda_in;
								counter_slave = 1;
								state_slave <= state_slave_rx;
							end
						end
						
						state_slave_rx:	
						begin
							if (counter_slave < 72)
								begin 
								data_input[counter_slave] =  sda_in;
								counter_slave = counter_slave + 1;
								end
							else
								begin
								counter_slave = 0;
								state_slave <= state_slave_pause;
								end
						end
						
						default:	
						begin
							counter_slave = 0;
							state_slave <= state_slave_pause;
						end
					endcase	
				end
			
		end
	

endmodule
