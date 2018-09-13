`ifndef _INTERFACE_
`define _INTERFACE_

//---------------------------------------------------
// Input interface
//---------------------------------------------------
interface input_interface(input bit clock);

	logic		reset = 0;
	logic [7:0]	data_i;
	logic		valid_i;
	logic		frame_i;

	clocking cb @(posedge clock);
		output reset;
		output data_i;
		output valid_i;
		output frame_i;
	endclocking

	modport input_prt(clocking cb, input clock);

endinterface

//---------------------------------------------------
// Output interface
//---------------------------------------------------

interface output_interface(input bit clock);

	logic [7:0]	data_o;
	logic		valid_o;
	logic		frame_o;

	clocking cb @(posedge clock);
		input data_o;
		input valid_o;
		input frame_o;
	endclocking

	modport output_prt(clocking cb, input clock);

endinterface

`endif
