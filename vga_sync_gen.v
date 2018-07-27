module vga_sync_generator(			nreset,
									pixel_clk,    
                                    hsync,
                                    vsync,
                                    blank_N,
                                    pixel_clk_N,
									rd_req,
									rd_req_countV_out);

// frame out parametersrs
parameter FRAME_X_SIZE	= 640;
parameter FRAME_Y_SIZE	= 512;

// horizontal parameters
parameter H_ACTIVE_VIDEO= 1024;
parameter H_FRONT_PORCH = 26; 
parameter H_SYNC_PULSE 	= 136;  
parameter H_BACK_PORCH 	= 162; 
parameter H_BLANK_PIX 	= H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;
parameter H_TOTAL_PIX 	= H_ACTIVE_VIDEO + H_BLANK_PIX;
 
// vertical parameters
parameter V_ACTIVE_VIDEO= 768;                           
parameter V_FRONT_PORCH = 3;  
parameter V_SYNC_PULSE 	= 6;	  
parameter V_BACK_PORCH 	= 29; 
parameter V_BLANK_PIX 	= V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH;
parameter V_TOTAL_PIX 	= V_ACTIVE_VIDEO + V_BLANK_PIX;
                   
input nreset;						 
input pixel_clk;
 
output hsync;
output vsync;
output blank_N;
output pixel_clk_N;
output rd_req;
output [10:0] rd_req_countV_out;
 
reg [10:0] countV;
reg [11:0] countH;

reg [10:0] rd_req_countV;

reg hsync_pre;
reg rd_req_pre;
reg sig_hsync;
reg sig_vsync;
reg sig_rdreq;
reg sig_blank_N;

assign rd_req_countV_out = rd_req_countV;
assign pixel_clk_N 		 = ~pixel_clk; 
 
assign hsync 					= sig_hsync; 
assign vsync  					= sig_vsync;
assign rd_req 					= sig_rdreq;
assign blank_N  				= sig_blank_N;


always @(posedge pixel_clk)
begin
	if (nreset)
	begin
	sig_blank_N  = ~((countV < V_BLANK_PIX) || (countH < H_BLANK_PIX));  // Blank сигнал
	end
end

always @(posedge pixel_clk)
begin
	if (nreset)
	begin
	sig_hsync  = ~((countH >= H_FRONT_PORCH-1) && (countH <= H_FRONT_PORCH + H_SYNC_PULSE-1));
	end
end

always @(posedge pixel_clk)
begin
	if (nreset)
	begin
	sig_rdreq = (countV > V_BACK_PORCH + V_SYNC_PULSE -1 + 44) && (countV <= V_BACK_PORCH + V_SYNC_PULSE -1 + FRAME_Y_SIZE + 44) && ( ((countH > H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH + 80 -1) && (countH <= H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH + 80 + FRAME_X_SIZE -1)) );
	end
end

always @(posedge pixel_clk)
begin
	if (nreset)
	begin
	sig_vsync  = (countV >= V_FRONT_PORCH-1) && (countV <= V_FRONT_PORCH + V_SYNC_PULSE-1);
	end
end
 
always @(posedge pixel_clk)
begin
	if (nreset)
	begin
    if (countH < H_TOTAL_PIX)
        countH <= countH + 1'b1;
    else
        countH <= 0;
	end
end
  
always @(posedge pixel_clk)
begin
	if (nreset)
	begin
	 hsync_pre <= hsync;
	 if ((!hsync_pre) && (hsync))
		begin
			if (countV < V_TOTAL_PIX)
			  countV <= countV + 1'b1;
			else
			  countV <= 0;
		end
	end
end

 
always @(posedge pixel_clk)
begin
	if (nreset)
	begin
	 rd_req_pre <= rd_req;
	 if ((!rd_req_pre) && (rd_req))
		begin
			if (rd_req_countV < FRAME_Y_SIZE)
			  rd_req_countV <= rd_req_countV + 1'b1;
			else
			  rd_req_countV <= 0;
		end
	end
end


endmodule
