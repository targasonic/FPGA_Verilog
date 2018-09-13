`ifndef _ENVIRONMENT
`define _ENVIRONMENT

`include "filter_transaction.sv"
//`include "filter_coverage.sv"
`include "filter_driver.sv"
`include "filter_receiver.sv"
`include "filter_scoreboard.sv"

class FilterEnvironment;

// ¬£ ¬ß¬Ñ¬é¬Ñ¬Ý¬Ö ¬à¬á¬Ú¬ã¬Ñ¬ß¬Ú¬ñ ¬Ü¬Ý¬Ñ¬ã¬ã¬Ñ ¬à¬Ò¬ì¬ñ¬Ó¬Ý¬ñ¬ð¬ä¬ã¬ñ ¬Ó¬Ú¬â¬ä¬å¬Ñ¬Ý¬î¬ß¬í¬Ö ¬Ú¬ß¬ä¬Ö¬â¬æ¬Ö¬Û¬ã¬í:
virtual input_interface.input_prt input_intf ;
virtual output_interface.output_prt output_intf ;


// ¬¥¬Ñ¬Ý¬Ö¬Ö ¬à¬Ò¬ì¬ñ¬Ó¬Ý¬ñ¬ð¬ä¬ã¬ñ ¬Ü¬à¬Þ¬á¬à¬ß¬Ö¬ß¬ä¬í ¬ä¬Ö¬ã¬ä¬à¬Ó¬à¬Ô¬à ¬à¬Ü¬â¬å¬Ø¬Ö¬ß¬Ú¬ñ:
FilterDriver 		 drvr;
FilterDriverReceiver rcvr;
FilterScoreboard 	 sb;
mailbox #(Transaction) rcvr2sb;

/*
¬±¬â¬Ú¬Þ¬Ö¬é¬Ñ¬ß¬Ú¬Ö
¬£ SystemVerilog ¬Ö¬ã¬ä¬î ¬à¬Ò¬í¬é¬ß¬í¬Ö ¬á¬à¬é¬ä¬à¬Ó¬í¬Ö ¬ñ¬ë¬Ú¬Ü¬Ú: 
mailbox rcvr2sb[2];

¬Ú ¬á¬Ñ¬â¬Ñ¬Þ¬Ö¬ä¬â¬Ú¬Ù¬Ú¬â¬à¬Ó¬Ñ¬ß¬ß¬í¬Ö: 
mailbox #(Transaction) rcvr2sb[2];

¬°¬Ò¬í¬é¬ß¬í¬Ö ¬á¬à¬é¬ä¬à¬Ó¬í¬Ö ¬ñ¬ë¬Ú¬Ü¬Ú ¬á¬à¬Ù¬Ó¬à¬Ý¬ñ¬ð¬ä ¬á¬Ö¬â¬Ö¬Õ¬Ñ¬Ó¬Ñ¬ä¬î ¬Õ¬Ñ¬ß¬ß¬í¬Ö ¬â¬Ñ¬Ù¬Ý¬Ú¬é¬ß¬í¬ç ¬ä¬Ú¬á¬à¬Ó, ¬Ñ ¬á¬Ñ¬â¬Ñ¬Þ¬Ö¬ä¬â¬Ú¬Ù¬Ú¬â¬à¬Ó¬Ñ¬ß¬ß¬í¬Ö ? ¬ä¬à¬Ý¬î¬Ü¬à ¬à¬Õ¬ß¬à¬Ô¬à
(¬Ó ¬ß¬Ñ¬ê¬Ö¬Þ ¬ã¬Ý¬å¬é¬Ñ¬Ö ¬ä¬Ú¬á¬Ñ Transaction). ¬³¬Ú¬Þ¬å¬Ý¬ñ¬ä¬à¬â VCS ¬â¬Ñ¬Ù¬â¬Ö¬ê¬Ñ¬Ö¬ä ¬Ú¬ã¬á¬à¬Ý¬î¬Ù¬à¬Ó¬Ñ¬ß¬Ú¬Ö ¬á¬à¬é¬ä¬à¬Ó¬í¬ç ¬ñ¬ë¬Ú¬Ü¬à¬Ó ¬Ý¬ð¬Ò¬à¬Ô¬à ¬ä¬Ú¬á¬Ñ, ¬Ñ ¬Ó¬à¬ä
ModelSim ? ¬ä¬à¬Ý¬î¬Ü¬à ¬á¬Ñ¬â¬Ñ¬Þ¬Ö¬ä¬â¬Ú¬Ù¬Ú¬â¬à¬Ó¬Ñ¬ß¬ß¬í¬Ö. ¬£¬à ¬Þ¬ß¬à¬Ô¬Ú¬ç ¬ã¬Ý¬å¬é¬Ñ¬ñ¬ç ¬Ú¬ã¬á¬à¬Ý¬î¬Ù¬à¬Ó¬Ñ¬ß¬Ú¬Ö ¬á¬Ñ¬â¬Ñ¬Þ¬Ö¬ä¬â¬Ú¬Ù¬Ú¬â¬à¬Ó¬Ñ¬ß¬ß¬í¬ç ¬á¬à¬é¬ä¬à¬Ó¬í¬ç
¬ñ¬ë¬Ú¬Ü¬à¬Ó ¬ã¬á¬Ñ¬ã¬Ñ¬Ö¬ä ¬à¬ä ¬à¬ê¬Ú¬Ò¬Ü¬Ú ¬ß¬Ö¬ã¬à¬à¬ä¬Ó¬Ö¬ä¬ã¬ä¬Ó¬Ú¬ñ ¬ä¬Ú¬á¬à¬Ó (type mismatch). ¬¥¬Ý¬ñ ¬ä¬à¬Ô¬à, ¬é¬ä¬à¬Ò¬í ¬ß¬Ñ¬ê¬Ö IP-¬ñ¬Õ¬â¬à ¬ß¬Ö ¬Ò¬í¬Ý¬à
¬é¬å¬Ó¬ã¬ä¬Ó¬Ú¬ä¬Ö¬Ý¬î¬ß¬à ¬Ü ¬ã¬Ú¬Þ¬å¬Ý¬ñ¬ä¬à¬â¬å, ¬Ò¬å¬Õ¬Ö¬Þ ¬Ú¬ã¬á¬à¬Ý¬î¬Ù¬à¬Ó¬Ñ¬ä¬î ¬ä¬à¬Ý¬î¬Ü¬à ¬á¬Ñ¬â¬Ñ¬Þ¬Ö¬ä¬â¬Ú¬Ù¬Ú¬â¬à¬Ó¬Ñ¬ß¬ß¬í¬Ö ¬á¬à¬é¬ä¬à¬Ó¬í¬Ö ¬ñ¬ë¬Ú¬Ü¬Ú.
*/

function new (	virtual input_interface.input_prt input_intf_new ,
				virtual output_interface.output_prt output_intf_new );
	this.input_intf = input_intf_new ;
	this.output_intf = output_intf_new ;
	$display(" endfunction : new ");
endfunction : new

/*

¬²¬Ñ¬ã¬ã¬Þ¬à¬ä¬â¬Ú¬Þ ¬á¬à¬Õ¬â¬à¬Ò¬ß¬Ö¬Ö ¬Þ¬Ö¬ä¬à¬Õ build():
1) ¬£ ¬è¬Ú¬Ü¬Ý¬Ö foreach ¬ã¬à¬Ù¬Õ¬Ñ¬ð¬ä¬ã¬ñ ¬á¬à¬é¬ä¬à¬Ó¬í¬Ö ¬ñ¬ë¬Ú¬Ü¬Ú:

foreach(rcvr2sb[i])
rcvr2sb[i] = new();

2) ¬³¬à¬Ù¬Õ¬Ñ¬Ö¬ä¬ã¬ñ ¬Õ¬â¬Ñ¬Û¬Ó¬Ö¬â:

drvr= new(input_intf);

, ¬Ü¬à¬ä¬à¬â¬à¬Þ¬å ¬á¬Ö¬â¬Ö¬Õ¬Ñ¬Ö¬ä¬ã¬ñ ¬Ó¬ç¬à¬Õ¬ß¬à¬Û ¬Ú¬ß¬ä¬Ö¬â¬æ¬Ö¬Û¬ã.

3) ¬³¬à¬Ù¬Õ¬Ñ¬Ö¬ä¬ã¬ñ ¬Ò¬Ý¬à¬Ü ¬ã¬â¬Ñ¬Ó¬ß¬Ö¬ß¬Ú¬ñ:

sb = new(rcvr2sb);

¬¯¬Ö¬ã¬Þ¬à¬ä¬â¬ñ ¬ß¬Ñ ¬ä¬à, ¬é¬ä¬à ¬à¬ß ¬á¬à¬Õ¬Ü¬Ý¬ð¬é¬Ö¬ß ¬Ü ¬Õ¬Ó¬å¬Þ ¬á¬à¬é¬ä¬à¬Ó¬í¬Þ ¬ñ¬ë¬Ú¬Ü¬Ñ¬Þ, ¬Ó ¬Ü¬à¬ß¬ã¬ä¬â¬å¬Ü¬ä¬à¬â ¬á¬Ö¬â¬Ö¬Õ¬Ñ¬Ö¬ä¬ã¬ñ ¬ä¬à¬Ý¬î¬Ü¬à ¬à¬Õ¬ß¬à ¬ß¬Ñ¬Ù¬Ó¬Ñ¬ß¬Ú¬Ö ¬Ò¬Ö¬Ù ¬Ú¬ß¬Õ¬Ö¬Ü¬ã¬Ñ.

4) ¬£ ¬è¬Ú¬Ü¬Ý¬Ö foreach ¬ã¬à¬Ù¬Õ¬Ñ¬Ö¬ä¬ã¬ñ 2 ¬á¬â¬Ú¬Ö¬Þ¬ß¬Ú¬Ü¬Ñ:

foreach(rcvr[i])
rcvr[i] = new(output_intf[i], rcvr2sb[i]);

¬¬¬Ñ¬Ø¬Õ¬à¬Þ¬å ¬á¬â¬Ú¬Ö¬Þ¬ß¬Ú¬Ü¬å ¬á¬Ö¬â¬Ö¬Õ¬Ñ¬Ö¬ä¬ã¬ñ ¬ã¬Ó¬à¬Û ¬Ú¬ß¬ä¬Ö¬â¬æ¬Ö¬Û¬ã ¬Ú ¬á¬à¬é¬ä¬à¬Ó¬í¬Û ¬ñ¬ë¬Ú¬Ü.
*/

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

/*

class SortEnvironment #( type T );
  
  SortGenerator   #( T ) gen;
  SortDriver      #( T ) drv;
  SortMonitor     #( T ) mon;
  SortScoreboard  #( T ) scb;

  mailbox #( T ) gen2drv, drv2scb, mon2scb;
  
  function void build( virtual sort_engine_if _in_if, virtual sort_engine_if _out_if );
    gen2drv = new( );
    drv2scb = new( );
    mon2scb = new( );

    gen = new( gen2drv                   );
    drv = new( gen2drv, drv2scb, _in_if  );
    mon = new( mon2scb,          _out_if );
    scb = new( drv2scb, mon2scb          );
  endfunction 
  
  task run( );
    fork
      gen.run( 100 );
      drv.run( );
      mon.run( );
      scb.run( );
    join
  endtask 

endclass


*/

