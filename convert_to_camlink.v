module convert_to_cam_link_format
(
	input  			nRESET  ,
	input 			CLK_IN  ,
	input 			CLK_OUT ,
	input [63:0] 	DATA_IN_A_B_C_D ,
	input 			DATA_VALID ,

	output 			OUT_CLK    ,
	output 			OUT_LINE   ,
	output 			OUT_FRAME  ,
	output [15:0] 	OUT_VIDEO_DATA
);

	parameter		video_win_size_x					= 640 ;		
	parameter  		convert_to_cam_link_format_wait 	= 0   ; 
	parameter		convert_to_cam_link_format_convert 	= 1   ;
	
	reg [1:0]  		convert_to_cam_link_format_state;	
	reg [15:0] 		wait_end_command_counter ;
	reg [15:0] 		counter ;
	
	reg 			sig_out_line  ;
	reg 			sig_out_frame ;
	reg 			sig_out_clk   ;
	reg [15:0] 		sig_out_data  ;
	
	reg 			fifo_from_adc_sig_rdreq   ;
	reg 			fifo_from_adc_sig_wrfull  ;
	reg 			fifo_from_adc_sig_rdfull  ;
	wire [14:0] 	fifo_from_adc_sig_rdusedw ;
	
	assign OUT_CLK 	  		= CLK_OUT 		  ;
	assign OUT_LINE 		= sig_out_line    ;
	assign OUT_FRAME	  	= sig_out_frame   ;
	assign OUT_VIDEO_DATA   = sig_out_data    ;
	
	always @ (posedge CLK_OUT) 
	begin
		if (nRESET==0)
		begin
			sig_out_line 						= 0 ;
			sig_out_frame 						= 0 ;
			sig_out_clk							= 0 ;	
			sig_out_data						= 0 ;
			convert_to_cam_link_format_state	= convert_to_cam_link_format_wait ;
		end
		else 
		begin
			case (convert_to_cam_link_format_state)
				convert_to_cam_link_format_wait:
				begin
					if (fifo_from_adc_sig_rdusedw > video_win_size_x)
					begin
						convert_to_cam_link_format_state = convert_to_cam_link_format_convert ;
						fifo_from_adc_sig_rdreq 		 = 1 ;
						end
					else
						begin
						convert_to_cam_link_format_state = convert_to_cam_link_format_wait ;
						end
					end
						
				convert_to_cam_link_format_convert:
				begin
					if (counter < video_win_size_x)
					begin
						counter 						 = counter + 1 ;
						sig_out_line					 = 1 ;
						sig_out_data					 = fifo_from_adc_sig_q ;
					end
					else
					begin
						counter 						 = 0 ;
						sig_out_line					 = 0 ;
						sig_out_data					 = 0 ;
						convert_to_cam_link_format_state = convert_to_cam_link_format_convert ;
					end
				end
			endcase	
		end		
	end
			
fifo_from_video_adc fifo_from_video_adc_inst ( 
		.data    	( DATA_IN_A_B_C_D 			), 
		.rdclk  	( CLK_OUT 					), 
		.rdreq 		( fifo_from_adc_sig_rdreq	), 
		.wrclk  	( CLK_IN					),
		.wrreq  	( DATA_VALID				), 
		.q  		( fifo_from_adc_sig_q		),
		.rdusedw 	( fifo_from_adc_sig_rdusedw	) 		
);	
	
	
endmodule




