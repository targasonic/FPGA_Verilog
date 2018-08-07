
`timescale 1 ns / 1 ns
module filter_tb();

localparam              DATA_WIDTH  = 8 ;  
localparam              COEF_WIDTH  = 16 ;  
localparam              FRAME_V     = 1280 ; 
localparam              FRAME_H     = 720 ; 

reg 					clk_i		= 0 ;
reg 					reset_i	    = 1 ;
reg 					reset	    = 1 ;
reg  [DATA_WIDTH - 1:0]	data_i  	= 0 ;
wire                    valid_i 	= 0 ;  

reg hsync_pre;
reg sig_hsync;

reg 						frame_i 	= 0;

wire   [DATA_WIDTH - 1:0]   data_o  ;
wire                        valid_o ;
wire                        frame_o ;

reg 						test_mode 			= 0 ;
reg [ 15 : 0 ]				test_error_count 	= 0 ;
reg [ 15 : 0 ] 				test_frame_count 	= 0 ;
reg [ DATA_WIDTH - 1 : 0 ] 	data_o_test			= 0 ;
reg [ DATA_WIDTH - 1 : 0 ] 	count_o_test		= 0 ;
reg [ DATA_WIDTH - 1 : 0 ] 	strings_test		= 0 ;
reg 						frame_o_pre			= 0 ;
reg 						valid_o_pre			= 0 ;


filter dut (
	.clk_i		( clk_i  ),
	.data_i		( data_i ),
	.valid_i	( sig_hsync & frame_i ),
	.frame_i	( frame_i ),
	.reset_i	( reset_i ),
	.data_o		( data_o  ),
	.valid_o	( valid_o ),
	.frame_o	( frame_o )
);


// CLK Generate:
always
	#10 clk_i = ~clk_i;

// Reset Generate: Генерация сигналов резет для тест бенча и проверяемого модуля
reg	 	int_reset = 0 ;
initial
begin
	if  (int_reset == 0 ) 
	begin
				reset_i			= 1'b1;
		#45 	reset_i 		= 1'b0;
	end
	else
	begin
				reset_i			= 1'b1;
		#45 	reset_i 		= 1'b0;
		#505	reset_i			= 1'b1;
		#95 	reset_i 		= 1'b0;
	end
end
initial
begin
	if  (int_reset == 0 ) 
	begin
				reset			= 1'b1;
		#120	reset 			= 1'b0;
	end
	else
	begin
				reset			= 1'b1;
		#120 	reset 			= 1'b0;
		#505	reset			= 1'b1;
		#150 	reset 			= 1'b0;
	end
end

// Vsync Hsync Signals: Генерация сигналов синхронизации кадра, котоыре будут подаваться на проверяемый модуль
reg [ 15:0 ]   i = 0;
reg [ 15:0 ]   j = 0;
reg [ 15:0 ]   countV;
reg [ 15:0 ]   countH;

always @(posedge clk_i)
begin
	if (reset)		sig_hsync <= 0;
	else			sig_hsync <= (countH < FRAME_H) ;
end
always @(posedge clk_i)
begin
	if (reset)		frame_i <= 0;
	else			frame_i <= (countV < FRAME_V ) ?  1 :  0 ;
//	else			frame_i <= (countV < FRAME_V ) ?  1 : (countV == FRAME_V ) ? hsync_pre : 0 ;
end
always @(posedge clk_i)
begin
	if (reset)		countH <= 0;
	else			countH <= (countH < FRAME_H + 10) ?    countH + 1'b1 : 0	;
end
always @(posedge clk_i)
begin
	if (reset)		countV <= 0;
	else
	begin
	hsync_pre <= sig_hsync;
	if (( hsync_pre ) && ( ~sig_hsync ))
					countV <= (countV < FRAME_V + 5) ? countV + 1'b1 : 0 ;
	end
end

// Генерация данных на вход, в зависимости от режима проверки:
always @(posedge clk_i or posedge reset )
begin 
	if ( reset )		data_i	<= 0 ;
	else				
	begin
		case (test_mode)
		0: 
			data_i	<= (countH < FRAME_H) 				? countH + 1	: 0 ;									// ( ( j << 4 ) + i [ 3:0 ] )  	: 0  ;
		1: 	
			data_i	<= (countH < FRAME_H) 				? countV + 1	: 0 ;									// ( ( j << 4 ) + i [ 3:0 ] )  	: 0  ;
		endcase
	end
end



//  Проверка генерации сигналов кадровой, строчной синхронизации, формирование выходных данных
always @(posedge clk_i)
if (reset)		
begin
		test_frame_count <= 0 ;
end
else
begin
		frame_o_pre 		<= frame_o;
		valid_o_pre 		<= valid_o;


	//	test_frame_count 	<= (~frame_o * frame_o_pre) ? test_frame_count + 1 : test_frame_count ;
		count_o_test 		= ( valid_o ) ?  count_o_test + 1 : 0 ;
		case (test_mode)
		0: 
		begin
			if ( valid_o )
				test_error_count = (data_o == count_o_test) ?  test_error_count : test_error_count + 1 ;	
			test_mode = (test_frame_count == 2) ? 1 : 0 ; 			
		end

		1: 	
		begin		
			if ( valid_o )
				if (strings_test > 1)	test_error_count = (data_o == strings_test ) ?  test_error_count : test_error_count + 1;
			if (~frame_o)
				strings_test = 	0 ;
			else
				strings_test =	(valid_o_pre && ~valid_o) ?  strings_test + 1 : strings_test ;
		end
		endcase

		if (~frame_o * frame_o_pre) 
		begin
			test_frame_count = test_frame_count + 1;
			$display($time," Result of FRAME OUT SYNC SIGNALS TEST: ERRORS =  %d, Checked Frames = %d ",  test_error_count , test_frame_count ); 
		end
end



// Проверка работы фильтра:

wire	[ DATA_WIDTH - 1 : 0]	d_out ;							
reg 	[ DATA_WIDTH - 1 : 0]	d_in [9:0] 	;
reg 	[ COEF_WIDTH - 1 : 0]	coef [9:0] 	;

matrix_filter dut_filter (
	.clk_i		( clk_i    ),
	.d00_in		( d_in[0]  ),
	.d01_in		( d_in[1]  ),
	.d02_in		( d_in[2]  ),
	.d10_in		( d_in[3]  ),
	.d11_in		( d_in[4]  ),
	.d12_in		( d_in[5]  ),
	.d20_in		( d_in[6]  ),
	.d21_in		( d_in[7]  ),
	.d22_in		( d_in[8]  ),
	
	.coef_00	( coef[0]  ),
	.coef_01	( coef[1]  ),
	.coef_02	( coef[2]  ),
	.coef_10	( coef[3]  ),
	.coef_11	( coef[4]  ),
	.coef_12	( coef[5]  ),
	.coef_20	( coef[6]  ),
	.coef_21	( coef[7]  ),
	.coef_22	( coef[8]  ),
	
	.d_out		( d_out )
); 

real 	cc		[9:0] ; // Таблица дробных частей коэффицентов 0.5 0.250 0.125 ....
real 	coef_rl [9:0] ; // Таблица 
integer c 				= 0 ;
integer cbit 			= 0 ;
integer test_count 		= 32; 
integer filter_error 	= 0 ;
real 	filter_sum 		= 0 ;
reg [7:0] res_tb ,  d_out_pre ;
reg [7:0] res_tb_pre [9:0] ;

// Заполняем таблицу дробных коэффицентов
initial
begin
	for ( c = 0 ; c < 8; c = c + 1)
		begin
			cc[c] = 2 << ( 7 - c );
			cc[c] = 1 / cc[c] ;
		end
end
// Проверка правильности расчета отфильтрованных значений:
initial  
begin  
	repeat(500)@(posedge clk_i)
	begin  		
		test_count 		= test_count + 1 ; 
		filter_sum 		= 0 ;
		res_tb 			= 0 ;
		for ( c = 0 ; c < 9; c = c + 1)
		begin
			d_in[c] 	= $urandom%(test_count >> 5); 		 
			coef[c] 	= $urandom%(test_count * 10);		
			coef_rl[c] 	= coef[c][15 : 8];	
			for ( cbit = 0 ; cbit < 8 ; cbit = cbit + 1)
			begin
				coef_rl[c]	= ( coef[c][cbit] ) ?  coef_rl[c] + cc[cbit] : coef_rl[c];
			end
			filter_sum = filter_sum + ( d_in [c] * coef_rl [c] )  ;
		end
		
		res_tb = (filter_sum > 255) ? 255 : filter_sum ;			
					
		if (res_tb_pre[4] == d_out) 
			$display($time," The test is passed: res_tb = %d ; res_function = %d ; ", res_tb_pre[4], d_out);
		else
		begin
			$display($time," Data to Filter");  
			$display($time," d_in[0] = %d ; d_in[1] = %d ; d_in[2] = %d;", d_in[0], d_in[1] , d_in[2]);  
			$display($time," d_in[3] = %d ; d_in[4] = %d ; d_in[5] = %d;", d_in[3], d_in[4] , d_in[5]); 
			$display($time," d_in[6] = %d ; d_in[7] = %d ; d_in[8] = %d;", d_in[6], d_in[7] , d_in[8]); 			
			$display($time," -----------------------------------------------------------------------------------------"); 
			$display($time," Coefs to Filter");  	
			$display($time," coef[0] = %b ; coef[1] = %b ; coef[2] = %b ", coef[0], coef[1], coef[2] );  
			$display($time," coef[3] = %b ; coef[4] = %b ; coef[5] = %b ", coef[3], coef[4], coef[5] ); 
			$display($time," coef[6] = %b ; coef[7] = %b ; coef[8] = %b ", coef[6], coef[7], coef[8] );   			
			$display($time," -----------------------------------------------------------------------------------------");  			
			$display($time," Coefs in Real Format");  			
			$display($time," coef_rl[0] = %e ; coef_rl[1] = %e ; coef_rl[2] = %e ", coef_rl[0], coef_rl[1], coef_rl[2] );  
			$display($time," coef_rl[3] = %e ; coef_rl[4] = %e ; coef_rl[5] = %e ", coef_rl[3], coef_rl[4], coef_rl[5] ); 
			$display($time," coef_rl[6] = %e ; coef_rl[7] = %e ; coef_rl[8] = %e ", coef_rl[6], coef_rl[7], coef_rl[8] ); 
			$display($time," -----------------------------------------------------------------------------------------"); 
			$display($time," Result of Function: %d ",  d_out ); 
			$display($time," Result of TestBench: %d",  res_tb_pre[4] );  	
			filter_error = filter_error + 1	;	
		end
		res_tb_pre[0]	<= res_tb ; 
		res_tb_pre[1]	<= res_tb_pre[0] ; 
		res_tb_pre[2]	<= res_tb_pre[1] ;  
		res_tb_pre[3]	<= res_tb_pre[2] ;   
		res_tb_pre[4]	<= res_tb_pre[3] ; 		
	end  
	$display($time," Result of FILTER TEST: ERRORS =  %d",  (filter_error - 1 ) ); 
end  
 
 
endmodule
