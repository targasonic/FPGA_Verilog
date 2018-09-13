module filter #(
	parameter DATA_WIDTH = 8 ,
	parameter COEF_00		= 16'b0000000000000000 ,
	parameter COEF_01		= 16'b0000000000000000 ,
	parameter COEF_02		= 16'b0000000000000000 ,
	parameter COEF_10		= 16'b0000000000000000 ,
	parameter COEF_11		= 16'b0000000100000000 ,
	parameter COEF_12		= 16'b0000000000000000 ,
	parameter COEF_20		= 16'b0000000000000000 ,
	parameter COEF_21		= 16'b0000000000000000 ,
	parameter COEF_22		= 16'b0000000000000000 
	
)(
	input 		clk_i   ,
	input 		reset_i ,
	
	input		[DATA_WIDTH - 1:0]   	data_i  ,
	input 					valid_i ,
	input					frame_i ,

	output reg	[DATA_WIDTH - 1:0]	data_o  ,
	output reg				valid_o ,
	output reg				frame_o
);

wire  [ DATA_WIDTH - 1:0 ] data_lineb , data_linea, flr_o;
reg   [ DATA_WIDTH - 1:0 ] data_line2 = 0 , data_i2 = 0 ;
reg   [ DATA_WIDTH - 1:0 ] a0 = 0 , a1 = 0 , a2 = 0 , b0 = 0 , b1 = 0 , b2 = 0 , c0 = 0 , c1 = 0 , c2 = 0 ;

reg 	     linea_wrreq = 0; 
reg [15 : 0] valid_o_delay ; 
reg [15 : 0] frame_o_delay ;
localparam  out_frame_delay     = 8 ; 

reg [2 : 0] count_v ;

reg lineb_rdreq; 
reg linea_rdreq; 
reg lineb_rdreq_p;
reg linea_rdreq_p;
reg fifo_clr;



always @( posedge clk_i or posedge reset_i )
if( reset_i )  count_v	 = 0 ;	  
else		
					count_v <=  (~frame_o) ?  0 : ( ~valid_i & valid_o_delay[0] & ~count_v[2] ) ? 	count_v + 1 : count_v  ;

// Сдвиговые регистры, для формирования окна 3х3 для фильтрации
always @( posedge clk_i or posedge reset_i )
if( reset_i )
begin
		a0 <= 0; a1 	<= 0 ; a2 <= 0;
		b0 <= 0; b1 	<= 0 ; b2 <= 0;
		c0 <= 0; c1 	<= 0 ; c2 <= 0;	
		data_line2 	<= 0 ;  
		data_i2		<= 0 ;
		lineb_rdreq 	<= 0 ;
		linea_rdreq 	<= 0 ;
		lineb_rdreq_p 	<= 0 ;
		linea_rdreq_p 	<= 0 ;
end
else
begin
		lineb_rdreq 	<= (count_v > 0 ) & valid_i & frame_i;
		linea_rdreq 	<= (count_v > 1 ) & valid_i & frame_i;
		
		lineb_rdreq_p 	<= lineb_rdreq ; 
		linea_rdreq_p	<= linea_rdreq ; 

		data_i2			<= ( valid_i ) ? data_i	: 0 ; 
		data_line2 		<= data_i2;

		a0 <= ( linea_rdreq_p ) ? data_linea : ( lineb_rdreq_p ) ? data_lineb : data_line2;
		b0 <= ( lineb_rdreq_p ) ? data_lineb : data_line2	;
		c0 <= data_line2	;
		
		a1 <= a0;
		b1 <= b0;
		c1 <= c0;

		a2 <= a1;	
		b2 <= b1;
		c2 <= c1;
end

always @( posedge clk_i or posedge reset_i )
if( reset_i )	linea_wrreq <= 0;	 	  
else		linea_wrreq <= lineb_rdreq;

// CLR FIFO после того как закончился кадр
always @( posedge clk_i or posedge reset_i )
if( reset_i )	fifo_clr <= 0;	 	  
else		fifo_clr <= (~frame_i & ~frame_o_delay [0] & ~frame_o_delay [1] & frame_o_delay [out_frame_delay]);


always @( posedge clk_i or posedge reset_i )
if( reset_i )	data_o 	<= 0;	 
else		data_o 	<= flr_o;


// Необходимые для правильной работы, задержки сигналов
always @( posedge clk_i or posedge reset_i )
if( reset_i )
begin
	valid_o_delay 		<= 0;	
	frame_o_delay 		<= 0; 
end
else
begin
	valid_o_delay [0] 	<= valid_i;
	valid_o_delay [1] 	<= valid_o_delay [0];
	valid_o_delay [2] 	<= valid_o_delay [1];
	valid_o_delay [3] 	<= valid_o_delay [2];
	valid_o_delay [4] 	<= valid_o_delay [3];
	valid_o_delay [5] 	<= valid_o_delay [4];
	valid_o_delay [6] 	<= valid_o_delay [5];
	valid_o_delay [7] 	<= valid_o_delay [6];
	valid_o_delay [8] 	<= valid_o_delay [7];
	valid_o 		<= valid_o_delay [out_frame_delay - 1]; 
	frame_o_delay [0] 	<= frame_i;
	frame_o_delay [1] 	<= frame_o_delay [0];
	frame_o_delay [2] 	<= frame_o_delay [1];
	frame_o_delay [3] 	<= frame_o_delay [2];
	frame_o_delay [4] 	<= frame_o_delay [3];
	frame_o_delay [5] 	<= frame_o_delay [4];
	frame_o_delay [6] 	<= frame_o_delay [5];
	frame_o_delay [7] 	<= frame_o_delay [6];
	frame_o_delay [8] 	<= frame_o_delay [7];
	frame_o 		<= frame_o_delay [out_frame_delay] || frame_i ;
end


// Модуль фильтрации, на вход подается 9 коэффицентов и 9 пикселей
matrix_filter filter (
	.clk_i		( clk_i ),
	.d00_in		( a0 ),
	.d01_in		( a1 ),
	.d02_in		( a2 ),
	.d10_in		( b0 ),
	.d11_in		( b1 ),
	.d12_in		( b2 ),
	.d20_in		( c0 ),
	.d21_in		( c1 ),
	.d22_in		( c2 ),
	
	.coef_00	( COEF_00 ),
	.coef_01	( COEF_01 ),
	.coef_02	( COEF_02 ),
	.coef_10	( COEF_10 ),
	.coef_11	( COEF_11 ),
	.coef_12	( COEF_12 ),
	.coef_20	( COEF_20 ),
	.coef_21	( COEF_21 ),
	.coef_22	( COEF_22 ),
		
	.d_out		( flr_o )
);


// FIFO для буфферизации строк
line1 line0_buff (
	.clock 		( clk_i  	) ,
	.data		( data_lineb  	) ,
	.rdreq		( linea_rdreq 	) ,
	.wrreq		( linea_wrreq 	) ,
	.q		( data_linea  	) , 
	.aclr		( fifo_clr )
);

line1 line1_buff (
	.clock 		( clk_i  	) ,
	.data		( data_i	) ,
	.rdreq		( lineb_rdreq 	) ,
	.wrreq		( valid_i 	) ,
	.q		( data_lineb  	) , 
	.aclr		( fifo_clr )
);

endmodule

module matrix_filter
#(
    parameter DATA_IN_WIDTH    = 8
)(
   input       					clk_i	,
	
   input     [DATA_IN_WIDTH - 1 : 0]    	d00_in ,
   input     [DATA_IN_WIDTH - 1 : 0]    	d01_in ,
   input     [DATA_IN_WIDTH - 1 : 0]    	d02_in ,
   input     [DATA_IN_WIDTH - 1 : 0]    	d10_in ,
   input     [DATA_IN_WIDTH - 1 : 0]    	d11_in ,
   input     [DATA_IN_WIDTH - 1 : 0]    	d12_in ,
   input     [DATA_IN_WIDTH - 1 : 0]    	d20_in ,
   input     [DATA_IN_WIDTH - 1 : 0]    	d21_in ,
   input     [DATA_IN_WIDTH - 1 : 0]    	d22_in ,
	
   input     [2 * DATA_IN_WIDTH - 1 : 0]  coef_00,
   input     [2 * DATA_IN_WIDTH - 1 : 0]  coef_01,
   input     [2 * DATA_IN_WIDTH - 1 : 0]  coef_02,
   input     [2 * DATA_IN_WIDTH - 1 : 0]  coef_10,
   input     [2 * DATA_IN_WIDTH - 1 : 0]  coef_11,
   input     [2 * DATA_IN_WIDTH - 1 : 0]  coef_12,
   input     [2 * DATA_IN_WIDTH - 1 : 0]  coef_20,
   input     [2 * DATA_IN_WIDTH - 1 : 0]  coef_21,
   input     [2 * DATA_IN_WIDTH - 1 : 0]  coef_22, 
   output reg[DATA_IN_WIDTH - 1 : 0]    d_out

);

	reg [3 * DATA_IN_WIDTH - 1 : 0] m00 ; 
	reg [3 * DATA_IN_WIDTH - 1 : 0] m01 ; 
	reg [3 * DATA_IN_WIDTH - 1 : 0] m02 ; 
	reg [3 * DATA_IN_WIDTH - 1 : 0] m10 ; 
	reg [3 * DATA_IN_WIDTH - 1 : 0] m11 ; 
	reg [3 * DATA_IN_WIDTH - 1 : 0] m12 ; 
	reg [3 * DATA_IN_WIDTH - 1 : 0] m20 ; 
	reg [3 * DATA_IN_WIDTH - 1 : 0] m21 ; 
	reg [3 * DATA_IN_WIDTH - 1 : 0] m22 ; 
	reg [4 * DATA_IN_WIDTH - 1 : 0] result0 ; 
	reg [4 * DATA_IN_WIDTH - 1 : 0] result1 ; 
	reg [4 * DATA_IN_WIDTH - 1 : 0] result2 ; 
	reg [4 * DATA_IN_WIDTH - 1 : 0] result ; 
	
	always @( posedge clk_i )
	begin
		m00 <= d00_in * coef_00;
		m01 <= d01_in * coef_01;
		m02 <= d02_in * coef_02;
		m10 <= d10_in * coef_10;
		m11 <= d11_in * coef_11;
		m12 <= d12_in * coef_12;
		m20 <= d20_in * coef_20;
		m21 <= d21_in * coef_21;
		m22 <= d22_in * coef_22;
		 
		result0 <=  m00 + m01 + m02 ;
		result1 <=  m10 + m11 + m12 ;
		result2 <=  m20 + m21 + m22 ;
		 
		result <=   result0 + result1 + result2;
		 
		d_out  <=  ( result[4 * DATA_IN_WIDTH - 1 : 8] + result[7] > 255 ) ? 255 : result[15 : 8] + result[7];
		 
	end

	
endmodule





