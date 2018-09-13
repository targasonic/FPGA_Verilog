`ifndef _ENVIRONMENT
`define _ENVIRONMENT

`include "filter_transaction.sv"
//`include "filter_coverage.sv"
`include "filter_driver.sv"
`include "filter_receiver.sv"
`include "filter_scoreboard.sv"

class FilterEnvironment;

// �� �߬Ѭ�Ѭݬ� ���ڬ�Ѭ߬ڬ� �ܬݬѬ��� ��Ҭ��Ӭݬ����� �Ӭڬ���Ѭݬ�߬�� �ڬ߬�֬��֬۬��:
virtual input_interface.input_prt input_intf ;
virtual output_interface.output_prt output_intf ;


// ���Ѭݬ֬� ��Ҭ��Ӭݬ����� �ܬ�ެ��߬֬߬�� ��֬���Ӭ�Ԭ� ��ܬ��ج֬߬ڬ�:
FilterDriver 		 drvr;
FilterDriverReceiver rcvr;
FilterScoreboard 	 sb;
mailbox #(Transaction) rcvr2sb;

/*
����ڬެ֬�Ѭ߬ڬ�
�� SystemVerilog �֬��� ��Ҭ��߬�� ������Ӭ�� ���ڬܬ�: 
mailbox rcvr2sb[2];

�� ��Ѭ�Ѭެ֬��ڬ٬ڬ��ӬѬ߬߬��: 
mailbox #(Transaction) rcvr2sb[2];

���Ҭ��߬�� ������Ӭ�� ���ڬܬ� ���٬Ӭ�ݬ��� ��֬�֬լѬӬѬ�� �լѬ߬߬�� ��Ѭ٬ݬڬ�߬�� ��ڬ���, �� ��Ѭ�Ѭެ֬��ڬ٬ڬ��ӬѬ߬߬�� ? ���ݬ�ܬ� ��լ߬�Ԭ�
(�� �߬Ѭ�֬� ��ݬ��Ѭ� ��ڬ�� Transaction). ���ڬެ�ݬ���� VCS ��Ѭ٬�֬�Ѭ֬� �ڬ���ݬ�٬�ӬѬ߬ڬ� ������Ӭ�� ���ڬܬ�� �ݬ�Ҭ�Ԭ� ��ڬ��, �� �Ӭ��
ModelSim ? ���ݬ�ܬ� ��Ѭ�Ѭެ֬��ڬ٬ڬ��ӬѬ߬߬��. ���� �ެ߬�Ԭڬ� ��ݬ��Ѭ�� �ڬ���ݬ�٬�ӬѬ߬ڬ� ��Ѭ�Ѭެ֬��ڬ٬ڬ��ӬѬ߬߬�� ������Ӭ��
���ڬܬ�� ���Ѭ�Ѭ֬� ��� ���ڬҬܬ� �߬֬����Ӭ֬���Ӭڬ� ��ڬ��� (type mismatch). ���ݬ� ���Ԭ�, ����Ҭ� �߬Ѭ�� IP-��լ�� �߬� �Ҭ�ݬ�
���Ӭ��Ӭڬ�֬ݬ�߬� �� ��ڬެ�ݬ�����, �Ҭ�լ֬� �ڬ���ݬ�٬�ӬѬ�� ���ݬ�ܬ� ��Ѭ�Ѭެ֬��ڬ٬ڬ��ӬѬ߬߬�� ������Ӭ�� ���ڬܬ�.
*/

function new (	virtual input_interface.input_prt input_intf_new ,
				virtual output_interface.output_prt output_intf_new );
	this.input_intf = input_intf_new ;
	this.output_intf = output_intf_new ;
	$display(" endfunction : new ");
endfunction : new

/*

���Ѭ��ެ���ڬ� ���լ��Ҭ߬֬� �ެ֬��� build():
1) �� ��ڬܬݬ� foreach ���٬լѬ���� ������Ӭ�� ���ڬܬ�:

foreach(rcvr2sb[i])
rcvr2sb[i] = new();

2) ����٬լѬ֬��� �լ�Ѭ۬Ӭ֬�:

drvr= new(input_intf);

, �ܬ�����ެ� ��֬�֬լѬ֬��� �Ӭ��լ߬�� �ڬ߬�֬��֬۬�.

3) ����٬լѬ֬��� �Ҭݬ�� ���ѬӬ߬֬߬ڬ�:

sb = new(rcvr2sb);

���֬�ެ���� �߬� ���, ���� ��� ���լܬݬ��֬� �� �լӬ�� ������Ӭ�� ���ڬܬѬ�, �� �ܬ�߬����ܬ��� ��֬�֬լѬ֬��� ���ݬ�ܬ� ��լ߬� �߬Ѭ٬ӬѬ߬ڬ� �Ҭ֬� �ڬ߬լ֬ܬ��.

4) �� ��ڬܬݬ� foreach ���٬լѬ֬��� 2 ���ڬ֬ެ߬ڬܬ�:

foreach(rcvr[i])
rcvr[i] = new(output_intf[i], rcvr2sb[i]);

���Ѭجլ�ެ� ���ڬ֬ެ߬ڬܬ� ��֬�֬լѬ֬��� ��Ӭ�� �ڬ߬�֬��֬۬� �� ������Ӭ�� ���ڬ�.
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

