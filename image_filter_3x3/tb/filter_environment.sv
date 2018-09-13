`ifndef _ENVIRONMENT
`define _ENVIRONMENT

`include "filter_transaction.sv"
//`include "filter_coverage.sv"
`include "filter_driver.sv"
`include "filter_receiver.sv"
`include "filter_scoreboard.sv"

class FilterEnvironment;

// 派 盼癸祇癸看盆 眇矜盹研癸盼盹竿 眉看癸研研癸 眇皆科竿皇看竿突砌研竿 皇盹砂砌砍癸看秋盼秒盆 盹盼砌盆砂祆盆相研秒:
virtual input_interface.input_prt input_intf ;
virtual output_interface.output_prt output_intf ;


// 洛癸看盆盆 眇皆科竿皇看竿突砌研竿 眉眇盾矜眇盼盆盼砌秒 砌盆研砌眇皇眇皈眇 眇眉砂砍盅盆盼盹竿:
FilterDriver 		 drvr;
FilterDriverReceiver rcvr;
FilterScoreboard 	 sb;
mailbox #(Transaction) rcvr2sb;


function new (	virtual input_interface.input_prt input_intf_new ,
				virtual output_interface.output_prt output_intf_new );
	this.input_intf = input_intf_new ;
	this.output_intf = output_intf_new ;
	$display(" endfunction : new ");
endfunction : new

function void build();
	$display("void build");
	foreach(rcvr2sb)
	rcvr2sb 	= new();
	drvr 		= new(input_intf);
	sb 			= new(rcvr2sb);
	foreach(rcvr)
	rcvr		= new(output_intf, rcvr2sb);
	$display(" endfunction : build");
endfunction : build

task (reset);
	$display(" reset ");
	// Drive all DUT inputs to a known state
	input_intf.cb.reset   <= 0;
	input_intf.cb.data_i  <= 0;
	input_intf.cb.valid_i <= 0;
	input_intf.cb.frame_i <= 0;

	$display(" endtask : reset ");
endtask : reset

task cfg_dut();
	$display(" cfg_dut");
endtask : cfg_dut

task start();
	$display(" start");
	fork
	drvr.start();
	rcvr.start();
	sb.start();
	join_any
	$display(" endtask : start ");
endtask : start

task wait_for_end();
	$display(" ask wait_for_end");
	repeat(100) @(input_intf.clock);
	$display(" end ask wait_for_end");
endtask : wait_for_end

task report();
	Transaction trans;
	$display("task report");
	$display("=====================================");
	if (trans.errors == 1)
		$display(" Test completed with 1 error");
	else if (trans.errors)
		$display(" Test completed with %d errors", trans.errors);
	else
		$display(" Test completed without errors");
		$display("=====================================");
		$display(" %0d :" , trans.errors);
endtask : report

task run();
	$display(" task run() ");
	build();
	reset();
	cfg_dut();
	start();
	wait_for_end();
	report();
	$display(" endtask : run");
endtask : run

endclass

endif



endclass
