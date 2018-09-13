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


endmodule : tb_top

`endif
