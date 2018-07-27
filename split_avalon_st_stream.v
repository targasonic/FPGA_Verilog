module test #(
  parameter   DATA_WIDTH          = 32,
  parameter   EMPTY_WIDTH         = 2,
  parameter   PAC_MAX_WIDTH       = 16
)(
	// clock & async reset
	input 			                        clk_i,
	input 			                        reset_i,

	input         [PAC_MAX_WIDTH-1:0]   packet_max_size_i,

	// sink interface
	input 			                        asi_snk_valid_i,
	output 		                          asi_snk_ready_o,
	input         [DATA_WIDTH-1:0] 	    asi_snk_data_i,
	input         [EMPTY_WIDTH-1:0] 	  asi_snk_empty_i,
	input 			                        asi_snk_startofpacket_i,
	input 			                        asi_snk_endofpacket_i,

	// source interface
	output reg			                    aso_src_valid_o,
	input 			                        aso_src_ready_i,
	output reg    [DATA_WIDTH-1:0]      aso_src_data_o,
	output reg    [EMPTY_WIDTH-1:0] 	  aso_src_empty_o,
	output reg			                    aso_src_startofpacket_o,
	output reg			                    aso_src_endofpacket_o
);

localparam  BUFFER_DATA_WIDTH                        = 128 ;    
localparam  BUFFER_CNTR_WIDTH                        = 7 ;     
localparam  DATA_WIDTH_BYTES                         = DATA_WIDTH / 8 ;  

reg [BUFFER_CNTR_WIDTH - 1:0]   buf_pos_wr           = 0 ;
reg [BUFFER_CNTR_WIDTH - 1:0]   buf_pos_rd           = 0 ;
reg [BUFFER_CNTR_WIDTH - 1:0]   buf_pos_rd_1         = 0 ;
reg [BUFFER_CNTR_WIDTH - 1:0]   buf_pos_rd_2         = 0 ;
reg [BUFFER_CNTR_WIDTH - 1:0]   buf_pos_rd_3         = 0 ;
reg [BUFFER_CNTR_WIDTH - 1:0]   buf_pos_wr_1         = 0 ;
reg [BUFFER_CNTR_WIDTH - 1:0]   buf_pos_wr_2         = 0 ;
reg [BUFFER_CNTR_WIDTH - 1:0]   buf_pos_wr_3         = 0 ;

reg [7:0]                       data_in_buf [BUFFER_DATA_WIDTH - 1 : 0] ;
reg                             sop_in_buf  [BUFFER_DATA_WIDTH - 1 : 0] ;
reg                             eop_in_buf  [BUFFER_DATA_WIDTH - 1 : 0] ;
reg [15:0]                      max_in_buf  [BUFFER_DATA_WIDTH - 1 : 0] ;


reg [15:0]                      buf_bytes_count      = 0 ;
reg [7:0 ]                      buf_bytes_plus       = 0 ;
reg [7:0 ]                      buf_bytes_minus      = 0 ;


// Запись входного потока в буффер в линейном формате:
//
//  data_in   00  04
//            01  05
//            02  06  
//            03  --
//
//  empty     0   1
//  start     1   0
//  end       0   1
//  max_pac   M   M
//
// ----------------------------------------
//
//  data_buf   00  01 02  03  04  05  06
//  start       1   0  0   0   0   0   0 
//  end         0   0  0   0   0   0   1
//  max_pac     M   M  M   M   M   M   M

integer   i;
always @( posedge clk_i or posedge reset_i )
  if( reset_i )
    begin
      for( i = 0; i < BUFFER_DATA_WIDTH; i = i + 1 )
        begin
            data_in_buf   [ i ]       = 0 ;
            sop_in_buf    [ i ]       = 0 ;
            eop_in_buf    [ i ]       = 0 ;
            max_in_buf    [ i ]       = 0 ;
            buf_pos_wr                = 0 ;
        end
    end
  else
    begin
      if( asi_snk_valid_i && ( packet_max_size_i != 0 ) && asi_snk_ready_o)
        begin 
            // local temp _ variables
            buf_pos_wr_1                                  = buf_pos_wr + 1;
            buf_pos_wr_2                                  = buf_pos_wr + 2;
            buf_pos_wr_3                                  = buf_pos_wr + 3;

            sop_in_buf  [ buf_pos_wr   ]                  =   asi_snk_startofpacket_i ;
            sop_in_buf  [ buf_pos_wr_1 ]                  =   0 ;
            sop_in_buf  [ buf_pos_wr_2 ]                  =   0 ;
            sop_in_buf  [ buf_pos_wr_3 ]                  =   0 ;
            
            max_in_buf  [ buf_pos_wr   ]                  =   packet_max_size_i;
            max_in_buf  [ buf_pos_wr_1 ]                  =   packet_max_size_i;
            max_in_buf  [ buf_pos_wr_2 ]                  =   packet_max_size_i;
            max_in_buf  [ buf_pos_wr_3 ]                  =   packet_max_size_i;

            eop_in_buf  [ buf_pos_wr   ]                  =   ( asi_snk_empty_i == 3 )  ?  asi_snk_endofpacket_i : 0 ;
            eop_in_buf  [ buf_pos_wr_1 ]                  =   ( asi_snk_empty_i == 2 )  ?  asi_snk_endofpacket_i : 0 ;
            eop_in_buf  [ buf_pos_wr_2 ]                  =   ( asi_snk_empty_i == 1 )  ?  asi_snk_endofpacket_i : 0 ;
            eop_in_buf  [ buf_pos_wr_3 ]                  =   ( asi_snk_empty_i == 0 )  ?  asi_snk_endofpacket_i : 0 ;

            data_in_buf [ buf_pos_wr   ]                  =   asi_snk_data_i    [ 31:24 ];   
            data_in_buf [ buf_pos_wr_1 ]                  =   asi_snk_data_i    [ 23:16 ];
            data_in_buf [ buf_pos_wr_2 ]                  =   asi_snk_data_i    [ 15:8  ];   
            data_in_buf [ buf_pos_wr_3 ]                  =   asi_snk_data_i    [ 7:0   ];

            buf_pos_wr                                   =   buf_pos_wr + (4 - asi_snk_empty_i);
        end  
        else
            buf_pos_wr                                   =   buf_pos_wr;
    end

reg   [15:0]                      o_packet_out  = 0 ;
reg   [3:0 ]                      step_in_buff  = 0 ;
reg   [1:0 ]                      pos_eof_in    = 0 ;    // position of EOF in the  in_buffer


// Проверка переполнения буфера и готовности принимать входнные данные
assign  asi_snk_ready_o = ( buf_bytes_count < BUFFER_DATA_WIDTH - DATA_WIDTH_BYTES - DATA_WIDTH_BYTES - DATA_WIDTH_BYTES) && (~reset_i);


// Generate output signals AVALON-ST:
always @( posedge clk_i or posedge reset_i )
  if( reset_i )
    begin
        aso_src_startofpacket_o   = 0 ;
        aso_src_endofpacket_o     = 0 ;
        aso_src_empty_o           = 0 ;
        aso_src_data_o            = 0 ;
        aso_src_valid_o           = 0 ;
        o_packet_out              = 0 ;
        pos_eof_in                = 0 ;
        step_in_buff              = 0 ;
        buf_pos_rd                = 0 ;
        buf_bytes_minus           = 0 ;
    end
  else
  if ( ( buf_bytes_plus != buf_bytes_minus  ) && ( aso_src_ready_i  || ~aso_src_valid_o ) )
    begin
          // local temp _ variables
                    buf_pos_rd_1                  = buf_pos_rd + 1 ;
                    buf_pos_rd_2                  = buf_pos_rd + 2 ;
                    buf_pos_rd_3                  = buf_pos_rd + 3 ;

          // Calculate o_packet_out (remainder of bytes to output data):
          if ( o_packet_out == 0 || sop_in_buf [ buf_pos_rd ] )  
                    o_packet_out                  = max_in_buf [ buf_pos_rd ] ;

          // Generate aso_src_startofpacket_o signal:
                    aso_src_startofpacket_o       = ( ( o_packet_out == max_in_buf [ buf_pos_rd ] ) || ( o_packet_out == 0 ) )    ?     1     :     0 ; 

          // Generate aso_src_endofpacket_o   signal:   
          if     ( ( o_packet_out > 0 ) & ( o_packet_out <= 4 ) )   
                    aso_src_endofpacket_o         = 1 ;
          else    
                    aso_src_endofpacket_o         = eop_in_buf [ buf_pos_rd   ] || eop_in_buf [ buf_pos_rd_1 ] || 
                                                    eop_in_buf [ buf_pos_rd_2 ] || eop_in_buf [ buf_pos_rd_3 ] ; 

          // Calculate pos_eof_in (position of flag EOF in the buffer_in, [0 : 3] ):
                    pos_eof_in [1]                = ( ~eop_in_buf [ buf_pos_rd   ] & ~eop_in_buf [ buf_pos_rd_1 ] ) ;
                    pos_eof_in [0]                = ( ~eop_in_buf [ buf_pos_rd   ] & 
                                                   (( ~eop_in_buf [ buf_pos_rd_1 ] & ~eop_in_buf [ buf_pos_rd_2 ] ) || eop_in_buf [ buf_pos_rd_1 ] ) ) ;

          // Calculate step_in_buff :
          if     ( aso_src_endofpacket_o == 0 ) 
                    step_in_buff                  = 4 ;
          else                                    
                    step_in_buff                  = ( o_packet_out <= ( pos_eof_in + 1 ) )  ?   o_packet_out    :   ( pos_eof_in + 1 ) ;

          // Generate aso_src_empty_o signal:
                    aso_src_empty_o               = 4 - step_in_buff ;

          // Generate aso_src_data_o signals:
                    aso_src_data_o [31:24]        = ( step_in_buff >= 1 )   ?   data_in_buf [ buf_pos_rd   ]   : 8'h00 ;
                    aso_src_data_o [23:16]        = ( step_in_buff >= 2 )   ?   data_in_buf [ buf_pos_rd_1 ]   : 8'h00 ;
                    aso_src_data_o [15:8 ]        = ( step_in_buff >= 3 )   ?   data_in_buf [ buf_pos_rd_2 ]   : 8'h00 ;
                    aso_src_data_o [ 7:0 ]        = ( step_in_buff >= 4 )   ?   data_in_buf [ buf_pos_rd_3 ]   : 8'h00 ;

          // Calculate buf_pos_rd (rd position in the buffer_in): 
                    buf_pos_rd                    = buf_pos_rd      + step_in_buff ;

          // Calculate o_packet_out (remainder of bytes to output data):
                    o_packet_out                  = ( o_packet_out > step_in_buff )    ?   ( o_packet_out - step_in_buff )    :     0 ;

                    buf_bytes_minus               = buf_bytes_minus + step_in_buff ;

                    aso_src_valid_o               = 1;                   
      end  
      else
      begin
          if ( aso_src_valid_o )
                    aso_src_valid_o               = ( ~aso_src_ready_i )  ?  1  : 0 ;
                       
                    buf_pos_rd                    = buf_pos_rd ;
                    buf_bytes_minus               = buf_bytes_minus ;
      end



// Calculate received bytes 
always @( posedge clk_i or posedge reset_i )
if      ( reset_i )
      	buf_bytes_plus   <= 0;
else if ( asi_snk_valid_i && ( packet_max_size_i != 0 ) )
	      buf_bytes_plus   <= buf_bytes_plus + ( asi_snk_ready_o ? (4 - asi_snk_empty_i) : 0 );


// Calculate bytes in the buffer_in 
always @( posedge clk_i or posedge reset_i )
if( reset_i )
        buf_bytes_count   = 0;
else
  begin
        buf_bytes_count   = ( asi_snk_valid_i && ( packet_max_size_i != 0 ) && ( asi_snk_ready_o ) )  ?   buf_bytes_count + (4 - asi_snk_empty_i)     : buf_bytes_count ;
        buf_bytes_count   = ( aso_src_valid_o &&  aso_src_ready_i  )                                  ?   buf_bytes_count - (4 - aso_src_empty_o)     : buf_bytes_count ;
  end






endmodule



