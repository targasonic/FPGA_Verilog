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





/*

���ݬѬ�� Driver ���ڬ�Ѭ� �� ��Ѭ۬ݬ� Driver.sv. ����߬�Ӭ߬�� �ެ֬��լ�� ����Ԭ� �ܬݬѬ��� ��Ӭݬ�֬���
�ެ֬��� start(), �ܬ������ �Ӭ�٬�ӬѬ֬��� �� �ެ֬��լ� Environment::start(). ������ �ެ֬���
�٬Ѭ���ܬѬ֬� �Ԭ֬߬֬�Ѭ�ڬ� ��ݬ��Ѭ۬߬�� ��֬���Ӭ�� �Ӭ�٬լ֬۬��Ӭڬ�. �� ���ެ���� �Ӭ�٬�Ӭ� �Ӭ����֬߬߬��
�� �ܬѬجլ�� �ܬݬѬ�� �Ӭڬ���Ѭݬ�߬�� ���߬ܬ�ڬ� randomize() ��֬�֬ެ֬߬߬�� �ܬݬѬ��� Transaction,
��Ҭ��Ӭݬ֬߬߬�� �ܬѬ� rand �ڬݬ� randc, �٬Ѭ��ݬ߬����� ��ݬ��Ѭ۬߬�ެ� �٬߬Ѭ�֬߬ڬ�ެ�:
	1. task start();
	2. Transaction trans = new trans_e;
	3.
	4. repeat(`NUM_OF_TRANS) begin
	5. if ( trans.randomize) begin
	6. trans.display_inputs();
	7. drive(trans);
	8. cov.sample(trans);
	9. end else begin
	10. $display (" %0d Driver : **ERROR: randomization failed",$time);
	11. trans.errors++;
	12. end
	13. end
	14.
	15. @(posedge input_intf.clock);
	16. trans.stop = 1;
	17. endtask : start
����ݬ� ���� �Ԭ֬߬֬�Ѭ�ڬ� ��ݬ��Ѭ۬߬�� �٬߬Ѭ�֬߬ڬ� ����ڬ٬��ݬ� ���ڬҬܬ�, ��� �Ӭ�Ӭ�լڬ���
�����Ӭ֬���Ӭ���֬� ����Ҭ�֬߬ڬ� �� �� �Ӭ֬ܬ���� ���ڬҬ�� ���ڬҬѬӬݬ�֬��� 1. ����ݬ� �Ӭ�� �߬��ެѬݬ�߬�,
��� ��Ԭ֬߬֬�ڬ��ӬѬ߬߬Ѭ� ���Ѭ߬٬Ѭܬ�ڬ� �Ӭ�Ӭ�լڬ��� �߬� ��ܬ�Ѭ�:
	1. trans.display_inputs();
���Ѭݬ֬� �Ӭ�٬�ӬѬ֬��� �ެ֬��� drive:
	1. drive(trans);
, �ܬ������ �Ӭ�լѬ֬� ��Ԭ֬߬֬�ڬ��ӬѬ߬߬�� ���Ѭ߬٬Ѭܬ�ڬ� �� �����Ӭ֬���Ӭڬ� �� ������ܬ�ݬ��
��֬�֬լѬ��:
	1. @(posedge input_intf.clock);
	2. input_intf.cb.a <= trans.a;
	3. input_intf.cb.b <= trans.b;
	4. input_intf.cb.c <= trans.c;
	5. input_intf.cb.d <= trans.d;
�� �߬Ѭ�֬� ��ݬ��Ѭ� ������ܬ�� ��֬�֬լѬ�� ���֬߬� ������ �� �Ӭ�� ��Ԭ֬߬֬�ڬ��ӬѬ߬߬�� �٬߬Ѭ�֬߬ڬ�
�Ӭ�լѬ���� �� ��լ߬�� ��Ѭܬ��, �߬� ���� �ج֬ݬѬ߬ڬ�, �ڬ٬ެ֬߬ڬ� �ެ֬��� drive(), �ެ�ج߬� ��֬Ѭݬڬ٬�ӬѬ��
�Ҭ�ݬ֬� ��ݬ�ج߬�� ������ܬ�ݬ� ��֬�֬լѬ��.
�����ݬ� ���Ԭ�, �ܬѬ� �ެ� ����ݬѬݬ� ���Ѭ߬٬Ѭܬ�ڬ�, �Ӭ�٬�ӬѬ֬��� �ެ֬��� Coverage::sample(),
�ܬ������ ���Ҭڬ�Ѭ֬� �ڬ߬���ެѬ�ڬ� �� ����ݬѬ߬߬�� ���Ѭ߬٬Ѭܬ�ڬ��.
2018. 8. 9. ���ݬѬ�� Driver
http://systemverilog.ru/klass-driver 2/4
����Ѭ۬Ӭ֬� ���Ӭ����֬� ���� ����ݬ֬լ�ӬѬ�֬ݬ�߬���� �լ֬۬��Ӭڬ� ��ڬ�ݬ� ��Ѭ�, �ܬ������ �٬ѬլѬ߬�
�ܬ�߬��Ѭ߬��� NUM_OF_TRANS. ���ݬ� ��լ�Ҭ��Ӭ� ���� �ܬ�߬��Ѭ߬�� ��Ҭ��Ӭݬ֬߬� �� ��Ѭ۬ݬ�
Globals.sv:
	1. `define NUM_OF_TRANS 100
�����ݬ� �٬ѬӬ֬��֬߬ڬ� �Ԭ֬߬֬�Ѭ�ڬ� �Ӭ�֬� ���Ѭ߬٬Ѭܬ�ڬ� �լ�Ѭ۬Ӭ֬� ����Ѭ߬ѬӬݬڬӬѬ֬� ��ڬԬ߬Ѭ�
����Ѭ߬�Ӭܬ� �Ԭ֬߬֬�Ѭ�ڬ� ��֬���Ӭ�� �Ӭ�٬լ֬۬��Ӭڬ�:
	1. trans.stop = 1;
*/





/*


class FilterDriver #( type T );

  mailbox #( T ) gen2drv;
  mailbox #( T ) drv2scb;
  
  virtual sort_engine_if __if;

  function new( input mailbox #( T ) gen2drv, drv2scb, virtual sort_engine_if _in_if );
    this.gen2drv = gen2drv;
    this.drv2scb = drv2scb;
    this.__if    = _in_if;

    init_if( );
  endfunction
  
  task run( );
    T tr;
    
    forever
      begin
        gen2drv.get( tr );
        
        send_transaction( tr );
        
        drv2scb.put( tr );
      end

  endtask

  function init_if( );
    this.__if.val  <= '0;
    this.__if.data <= '0;
    this.__if.sop  <= '0;
    this.__if.eop  <= '0;
  endfunction
  
  task send_transaction( input T tr );
    wait( __if.ready == 1'b1 )
    
    for( int i = 0; i < tr.size; i++ ) 
      begin
       __if.val  <= 1'b1;
       __if.data <= tr.payload[i];
       __if.sop  <= ( i == ( 0           ) ); 
       __if.eop  <= ( i == ( tr.size - 1 ) );
       @( posedge __if.clk );
      end

    __if.sop <= 1'b0;
    __if.val <= 1'b0;
    __if.eop <= 1'b0;
    @( posedge __if.clk );

  endtask 

endclass

*/