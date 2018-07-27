module contrast_video
(
	input  			nRESET ,
	
	input 			IN_CLK ,
	input 			IN_LINE	,
	input 			IN_FRAME ,
	input [15:0] 	IN_VIDEO_DATA ,
	
	output 			OUT_CLK ,
	output 			OUT_LINE ,
	output 			OUT_FRAME ,
	output [15:0] 	OUT_VIDEO_DATA ,

	// Avalon control interface
	input  			AV_CLK ,				
	input  			AV_nRES ,				
	input  			AV_CS ,				
	input  [2:0] 	AV_ADDR , 		
	input  			AV_nRD ,				
	input  			AV_nWR ,				
	input  [31:0] 	AV_WRITEDATA , 
	output [31:0] 	AV_READDATA ,	
	output 			AV_WAITREQ ,			
	output 			AV_IRQ ,
	
	// stereo vision
	input  			MODE_CAMERA ,
	input  			STEREO_MODE_ON ,
	output  [31:0] 	ZOOM_TO_SLAVE ,
	input 	[31:0]	ZOOM_FROM_MASTER ,
	
	output 	[15:0]  ZOOM_TO_RTP
);

	parameter 			video_win_size_x		= 640;	
	parameter 			video_win_size_y		= 512;
	parameter [5:0]  	video_width	  			= 8;			
	parameter [31:0] 	video_in_max_value		= 65535;		
	parameter [31:0] 	video_out_max_value		= 65535; 		
	
	reg 			contrast_video_on 	 	= 1; 
	reg 	[15:0] 	zoom_numerator			= 255;
	reg 	[15:0] 	zoom_denominator		= 65535; 
	reg 	[15:0] 	zoom_numerator_av		= 255;
	reg 	[15:0] 	zoom_denominator_av		= 65535; 
	
	reg 	[15:0] 	zoom_data_in_min_av		= 5;
	reg 	[15:0] 	zoom_data_in_min		= 5;
	
	reg 			line_signal;
	reg 			frame_signal;
	reg 	[31:0] 	data_signal;

// Avalon Interface
	reg 			nRD;
	reg 			nWR;
	reg 	[31:0] 	av_tmp_readdata;
	reg 	[31:0] 	frame_int_time_ns_av;
	reg 	[31:0] 	adc_delay_av; 
	reg 			WaitReq_i;
	wire 			WR_CS;
	wire 			RD_CS;
	reg 			av_irq_reg;
	reg 	[31:0] 	av_readdata_reg; 
	
	assign 			AV_WAITREQ 		= WaitReq_i;
	assign 			WR_CS 	  		= (~(AV_nWR) && AV_CS);
	assign 			RD_CS 	  		= (~(AV_nRD) && AV_CS);
	assign 			AV_IRQ 			= av_irq_reg;
	assign 			AV_READDATA		= av_readdata_reg;

// Stereo Vision Interface
	reg 	[31:0] 	zoom_to_slave_reg;
	reg 	[31:0] 	zoom_from_master_reg;
	reg 	[15:0] 	zoom_to_rtp_reg;
	
	assign			ZOOM_TO_SLAVE 	= zoom_to_slave_reg;
	assign 			ZOOM_TO_RTP		= zoom_to_rtp_reg;

	assign 			OUT_CLK			= IN_CLK;
	assign 			OUT_FRAME 		= frame_signal;
	assign 			OUT_LINE  		= line_signal;
	assign 			OUT_VIDEO_DATA	= data_signal;	
	

	
	// stereo vision
	always @ (posedge IN_CLK) 
		begin
			if (!nRESET)
			begin
				zoom_to_slave_reg [15:0] 	= 65535;
				zoom_to_slave_reg [31:16] 	= 0;
			end
			else
			begin
				if (contrast_video_on) 
				begin
					zoom_to_slave_reg [15:0] 	= zoom_denominator;
					zoom_to_slave_reg [31:16] 	= zoom_data_in_min;				
				end
				else
				begin
					zoom_to_slave_reg [15:0] 	= 65535;
					zoom_to_slave_reg [31:16] 	= 0;						
				end
			end
		end		

	
	// video zoom proccess
	always @ (posedge IN_CLK) 
		begin
			if (nRESET==0)
			begin
				frame_signal	= IN_FRAME;
				line_signal 	= IN_LINE;
				data_signal 	= IN_VIDEO_DATA;	
			end
			else
			begin			
			frame_signal	= IN_FRAME;	
			line_signal 	= IN_LINE;		
			// for slave camera:					
				if ((MODE_CAMERA) && (STEREO_MODE_ON)) // if SLAVE CAMERA
				begin
					if (IN_LINE == 1)
					begin
						if 		(IN_VIDEO_DATA >= ZOOM_FROM_MASTER[15:0]) 	data_signal 	= video_out_max_value;		
						else if (IN_VIDEO_DATA <= ZOOM_FROM_MASTER[31:16])  data_signal 	= 0;	
						else 												data_signal 	= ( ( ( IN_VIDEO_DATA - ZOOM_FROM_MASTER[31:16] )*video_out_max_value)
																								/ ( ZOOM_FROM_MASTER[15:0] - ZOOM_FROM_MASTER[31:16] ) ) ;	
					end
					else if 	(IN_LINE == 0)								data_signal 	= IN_VIDEO_DATA;	
					end		
					zoom_to_rtp_reg			= (video_in_max_value / ZOOM_FROM_MASTER[15:0]);	
				end
			// for master camera:
				else
				begin		
					if (contrast_video_on)
					begin
						if (IN_LINE == 1)
						begin
							if 			(IN_VIDEO_DATA >= zoom_denominator)   data_signal 	= video_out_max_value;		
							else if 	(IN_VIDEO_DATA <= zoom_data_in_min)	  data_signal 	= 0;	
							else 											  data_signal	= ( ( ( IN_VIDEO_DATA - zoom_data_in_min)*video_out_max_value )
																								/ ( zoom_denominator - zoom_data_in_min ) );	
							end
							else if (IN_LINE == 0)	data_signal 	= IN_VIDEO_DATA;					
							zoom_to_rtp_reg		= (65535 / zoom_denominator);
						end
						else
						begin							
							data_signal 		= IN_VIDEO_DATA;	
							zoom_to_rtp_reg		= 1;
						end
					end	
				end
		end		


	// AVALON Interface
	always @ (posedge AV_CLK) 
		begin
			if (AV_nRES == 0)
				begin
					WaitReq_i 			= 1;
					av_irq_reg 			= 2'b0;	
					av_tmp_readdata	= 0;
				end
			else
				begin
					if (WaitReq_i == 1)
						begin
							if (WR_CS == 1) 
								begin
								case (AV_ADDR)
									0:	contrast_video_on = AV_WRITEDATA;
									1:	begin
											zoom_numerator		= AV_WRITEDATA[31:16];
											zoom_denominator	= AV_WRITEDATA[15:0];
										end		
									2: zoom_data_in_min	= AV_WRITEDATA[15:0];
								endcase
								WaitReq_i = 0;
								end
							else if (RD_CS == 1)
								begin
									WaitReq_i = 0;
								end
						end
					else if (WaitReq_i == 0)
						begin
							WaitReq_i = 1;
						end
				end
		end	

	always @ (posedge AV_CLK) 
		begin
			if (RD_CS == 1)
			begin
				case (AV_ADDR)
					0: 
					begin
						if  ((MODE_CAMERA) && (STEREO_MODE_ON)) av_tmp_readdata  = ZOOM_FROM_MASTER[15:0]; // if SLAVE CAMERA
						else av_tmp_readdata  = zoom_denominator;
					end 
				default:	av_tmp_readdata= 0;
				endcase
				av_readdata_reg = av_tmp_readdata;
			end
		end	
	

endmodule	
