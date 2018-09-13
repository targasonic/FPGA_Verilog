import filter_tb::*;

`ifndef _TB_TOP_
`define _TB_TOP_


`include "filter_interface.sv"


module tb_top();

//---------------------------------------------------
// Объявление и генерация тактового сигнала
//---------------------------------------------------
bit clock;

initial
forever #10 clock = ~clock;

//---------------------------------------------------
// Объявление входного интерфейса
//---------------------------------------------------

input_interface input_intf(clock);

//---------------------------------------------------
// Объявление выходного интерфейса
//---------------------------------------------------

output_interface output_intf(clock);

//---------------------------------------------------
// Объявление программного блока testcase
//---------------------------------------------------

testcase TC (input_intf, output_intf);

//---------------------------------------------------
// Объявление тестируемых схем
//---------------------------------------------------

cmacc dut_cmacc_m (
	.data_i		( input_intf.data_i ),
	.valid_i	( input_intf.valid_i ),
	.frame_i	( input_intf.frame_i ),
	.reset_i	( input_intf.reset    ),
	.data_o		( output_intf.data_o  ),
	.valid_o	( output_intf.valid_o ),
	.frame_o	( output_intf.frame_o )
);

/*
old_scheme old_scheme_dut(
.a(input_intf.a),
.b(input_intf.b),
.c(input_intf.c),
.d(input_intf.d),
.result(output_intf[0].result)
);

new_scheme new_scheme_dut(
.a(input_intf.a),
.b(input_intf.b),
.c(input_intf.c),
.d(input_intf.d),
.result(output_intf[1].result)
);
*/
endmodule : tb_top

`endif




/*
`include "../rtl/cmacc.v"

`timescale 1 ns / 1 ns
module top_tb;


typedef struct packed{
bit   [2:0][15:0] c ;
} c_type;

typedef struct { 
	c_type coefs;
	bit	[15:0]      in;
	bit	[31:0]      out;
} dut_type;
struct { c_type coefs; bit [15:0] in, out; } dut = '{ 0, 0, 0 };


typedef struct { 
	bit	[7:0]	data_i;
	bit			valid_i;
	bit			frame_i;
	bit	[7:0]	data_o;
	bit			valid_o;
	bit			frame_o;
} dut_cmacc_type;

struct { 
	bit	[7:0]	data_i;
	bit			valid_i;
	bit			frame_i;
	bit	[7:0]	data_o;
	bit			valid_o;
	bit			frame_o;	
} dut_cmacc = '{ 0, 0, 0, 0, 0, 0 };


logic clk;
initial
begin
  clk = 1'b0;
  forever
    begin
      #10ns
      clk = !clk;
    end
end

logic reset;
initial
  begin
    reset <= 1'b1;
    #100ns
    reset <= 1'b0;
  end



localparam FRAME_V = 128;
localparam FRAME_H = 128;

integer 	pic_mem [FRAME_V - 1:0][FRAME_V - 1:0] ; 
//initial $readmemh("imgUni.txt", pic_mem);
integer pic_h;
integer pic_v;
initial
begin
	for (pic_h = 0 ; pic_h < FRAME_V; pic_h = pic_h + 1)
		for (pic_v = 0 ; pic_v < FRAME_V; pic_v = pic_v + 1)
			pic_mem [pic_h][pic_v] = pic_h + pic_v;	
		
	//#10
	//for (pic_k=0 ; pic_k<9; pic_k=pic_k+1) $display("%d:%e", pic_k, pic_mem[pic_k]);

end

// Vsync Hsync Signals: Генерация сигналов синхронизации кадра, котоыре будут подаваться на проверяемый модуль
reg [ 15:0 ]   i = 0;
reg [ 15:0 ]   j = 0;
reg [ 15:0 ]   countV = 0;
reg [ 15:0 ]   countH = 0;
reg 				hsync_pre = 0;

always @(posedge clk)
begin
	if (reset)		dut_cmacc.data_i <= 0;
	else
						dut_cmacc.data_i <= pic_mem[countV][countH] ; 
end

always @(posedge clk)
begin
	if (reset)		dut_cmacc.valid_i <= 0;
	else
						dut_cmacc.valid_i <= (countH < FRAME_H) ;
end

always @(posedge clk)
begin
	if (reset)		dut_cmacc.frame_i <= 0;
	else
						dut_cmacc.frame_i <= (countV < FRAME_V ) ?  1 :  0 ;
end

always @(posedge clk)
begin
	if (reset)		countH 	<= 0;
	else
						countH 	<= (countH < FRAME_H + 10) ?    countH + 1'b1 : 0	;
end

always @(posedge clk)
begin
	if (reset)
	begin
						hsync_pre <= 0;
						countV 	 <= 0;
	end
	else
	begin
		hsync_pre <=  dut_cmacc.valid_i;
		if (( hsync_pre ) && ( ~ dut_cmacc.valid_i ))
						countV <= (countV < FRAME_V + 5) ? countV + 1'b1 : 0 ;
	end
end






integer test_count = 0 ;

initial  
begin  
	repeat(500)@(posedge clk)
	begin  		
		test_count 			<= test_count + 1 ; 
		dut.in 				<= test_count ;
		dut.coefs.c[0]		<= 1 ;
		dut.coefs.c[1]		<= 2 ;
		dut.coefs.c[2]		<= 3 ;
		
	//	$display($time," Data to Filter: dut.out =  %d",  dut.out ); 		
	end  		
end 
*/
/*
real 		mem [8:0] ; 
initial $readmemh("../coefficients_float.txt", mem);
integer k;
initial
begin
	#10
	for (k=0 ; k<9; k=k+1) $display("%d:%e",k,mem[k]);
end
*/

/*
filterFPGA dut_filter_m (
	.clk   	( clk   ),
	.coefs	( dut.coefs ),
	.in    	( dut.in    ),
	.out   	( dut.out   )
);
*/
/*
cmacc dut_cmacc_m (
	.clk_i	( clk  ),
	.data_i	( dut_cmacc.data_i ),
	.valid_i	( dut_cmacc.valid_i ),
	.frame_i	( dut_cmacc.frame_i ),
	.reset_i	( reset ),
	.data_o	( dut_cmacc.data_o  ),
	.valid_o	( dut_cmacc.valid_o ),
	.frame_o	( dut_cmacc.frame_o )
);

endmodule

*/
