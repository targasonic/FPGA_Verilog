`ifndef _DRIVER_
`define _DRIVER_

//`include "Globals.sv"

class FilterDriver;

virtual input_interface.input_prt input_intf;
Transaction trans_e;
//FilterCoverage cov = new();

// Constructor
function new(virtual input_interface.input_prt input_intf_new);
	this.input_intf = input_intf_new;
	trans_e = new();
endfunction : new

task drive(Transaction trans);

	@(posedge input_intf.clk);
	input_intf.cb.data_i  <= trans.a;
	input_intf.cb.valid_i <= trans.valid_i;
	input_intf.cb.frame_i <= trans.frame_i;

endtask : drive

// Start method
task start();
Transaction trans = new trans_e;

	 repeat(`NUM_OF_TRANS) begin
		 if (trans.randomize) begin
			 trans.display_inputs();
			 drive(trans);
			// cov.sample(trans);
		 end else begin
			 $display (" %0d Driver : **ERROR: randomization failed",$time);
			 trans.errors++;
		 end
	 end

@(posedge input_intf.clock);
trans.stop = 1;
endtask : start

endclass

`endif
