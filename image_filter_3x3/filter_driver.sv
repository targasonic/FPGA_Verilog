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

¬¬¬Ý¬Ñ¬ã¬ã Driver ¬à¬á¬Ú¬ã¬Ñ¬ß ¬Ó ¬æ¬Ñ¬Û¬Ý¬Ö Driver.sv. ¬°¬ã¬ß¬à¬Ó¬ß¬í¬Þ ¬Þ¬Ö¬ä¬à¬Õ¬à¬Þ ¬ï¬ä¬à¬Ô¬à ¬Ü¬Ý¬Ñ¬ã¬ã¬Ñ ¬ñ¬Ó¬Ý¬ñ¬Ö¬ä¬ã¬ñ
¬Þ¬Ö¬ä¬à¬Õ start(), ¬Ü¬à¬ä¬à¬â¬í¬Û ¬Ó¬í¬Ù¬í¬Ó¬Ñ¬Ö¬ä¬ã¬ñ ¬Ó ¬Þ¬Ö¬ä¬à¬Õ¬Ö Environment::start(). ¬¿¬ä¬à¬ä ¬Þ¬Ö¬ä¬à¬Õ
¬Ù¬Ñ¬á¬å¬ã¬Ü¬Ñ¬Ö¬ä ¬Ô¬Ö¬ß¬Ö¬â¬Ñ¬è¬Ú¬ð ¬ã¬Ý¬å¬é¬Ñ¬Û¬ß¬í¬ç ¬ä¬Ö¬ã¬ä¬à¬Ó¬í¬ç ¬Ó¬à¬Ù¬Õ¬Ö¬Û¬ã¬ä¬Ó¬Ú¬Û. ¬³ ¬á¬à¬Þ¬à¬ë¬î¬ð ¬Ó¬í¬Ù¬à¬Ó¬Ñ ¬Ó¬ã¬ä¬â¬à¬Ö¬ß¬ß¬à¬Û
¬Ó ¬Ü¬Ñ¬Ø¬Õ¬à¬Û ¬Ü¬Ý¬Ñ¬ã¬ã ¬Ó¬Ú¬â¬ä¬å¬Ñ¬Ý¬î¬ß¬à¬Û ¬æ¬å¬ß¬Ü¬è¬Ú¬Ú randomize() ¬á¬Ö¬â¬Ö¬Þ¬Ö¬ß¬ß¬í¬Ö ¬Ü¬Ý¬Ñ¬ã¬ã¬Ñ Transaction,
¬à¬Ò¬ì¬ñ¬Ó¬Ý¬Ö¬ß¬ß¬í¬Ö ¬Ü¬Ñ¬Ü rand ¬Ú¬Ý¬Ú randc, ¬Ù¬Ñ¬á¬à¬Ý¬ß¬ñ¬ð¬ä¬ã¬ñ ¬ã¬Ý¬å¬é¬Ñ¬Û¬ß¬í¬Þ¬Ú ¬Ù¬ß¬Ñ¬é¬Ö¬ß¬Ú¬ñ¬Þ¬Ú:
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
¬¦¬ã¬Ý¬Ú ¬á¬â¬Ú ¬Ô¬Ö¬ß¬Ö¬â¬Ñ¬è¬Ú¬Ú ¬ã¬Ý¬å¬é¬Ñ¬Û¬ß¬í¬ç ¬Ù¬ß¬Ñ¬é¬Ö¬ß¬Ú¬Û ¬á¬â¬à¬Ú¬Ù¬à¬ê¬Ý¬Ñ ¬à¬ê¬Ú¬Ò¬Ü¬Ñ, ¬ä¬à ¬Ó¬í¬Ó¬à¬Õ¬Ú¬ä¬ã¬ñ
¬ã¬à¬à¬ä¬Ó¬Ö¬ä¬ã¬ä¬Ó¬å¬ð¬ë¬Ö¬Ö ¬ã¬à¬à¬Ò¬ë¬Ö¬ß¬Ú¬Ö ¬Ú ¬Ü ¬Ó¬Ö¬Ü¬ä¬à¬â¬å ¬à¬ê¬Ú¬Ò¬à¬Ü ¬á¬â¬Ú¬Ò¬Ñ¬Ó¬Ý¬ñ¬Ö¬ä¬ã¬ñ 1. ¬¦¬ã¬Ý¬Ú ¬Ó¬ã¬Ö ¬ß¬à¬â¬Þ¬Ñ¬Ý¬î¬ß¬à,
¬ä¬à ¬ã¬Ô¬Ö¬ß¬Ö¬â¬Ú¬â¬à¬Ó¬Ñ¬ß¬ß¬Ñ¬ñ ¬ä¬â¬Ñ¬ß¬Ù¬Ñ¬Ü¬è¬Ú¬ñ ¬Ó¬í¬Ó¬à¬Õ¬Ú¬ä¬ã¬ñ ¬ß¬Ñ ¬ï¬Ü¬â¬Ñ¬ß:
	1. trans.display_inputs();
¬¥¬Ñ¬Ý¬Ö¬Ö ¬Ó¬í¬Ù¬í¬Ó¬Ñ¬Ö¬ä¬ã¬ñ ¬Þ¬Ö¬ä¬à¬Õ drive:
	1. drive(trans);
, ¬Ü¬à¬ä¬à¬â¬í¬Û ¬Ó¬í¬Õ¬Ñ¬Ö¬ä ¬ã¬Ô¬Ö¬ß¬Ö¬â¬Ú¬â¬à¬Ó¬Ñ¬ß¬ß¬å¬ð ¬ä¬â¬Ñ¬ß¬Ù¬Ñ¬Ü¬è¬Ú¬ð ¬Ó ¬ã¬à¬à¬ä¬Ó¬Ö¬ä¬ã¬ä¬Ó¬Ú¬Ú ¬ã ¬á¬â¬à¬ä¬à¬Ü¬à¬Ý¬à¬Þ
¬á¬Ö¬â¬Ö¬Õ¬Ñ¬é¬Ú:
	1. @(posedge input_intf.clock);
	2. input_intf.cb.a <= trans.a;
	3. input_intf.cb.b <= trans.b;
	4. input_intf.cb.c <= trans.c;
	5. input_intf.cb.d <= trans.d;
¬£ ¬ß¬Ñ¬ê¬Ö¬Þ ¬ã¬Ý¬å¬é¬Ñ¬Ö ¬á¬â¬à¬ä¬à¬Ü¬à¬Ý ¬á¬Ö¬â¬Ö¬Õ¬Ñ¬é¬Ú ¬à¬é¬Ö¬ß¬î ¬á¬â¬à¬ã¬ä ¬Ú ¬Ó¬ã¬Ö ¬ã¬Ô¬Ö¬ß¬Ö¬â¬Ú¬â¬à¬Ó¬Ñ¬ß¬ß¬í¬Ö ¬Ù¬ß¬Ñ¬é¬Ö¬ß¬Ú¬ñ
¬Ó¬í¬Õ¬Ñ¬ð¬ä¬ã¬ñ ¬Ó ¬à¬Õ¬ß¬à¬Þ ¬ä¬Ñ¬Ü¬ä¬Ö, ¬ß¬à ¬á¬â¬Ú ¬Ø¬Ö¬Ý¬Ñ¬ß¬Ú¬Ú, ¬Ú¬Ù¬Þ¬Ö¬ß¬Ú¬Ó ¬Þ¬Ö¬ä¬à¬Õ drive(), ¬Þ¬à¬Ø¬ß¬à ¬â¬Ö¬Ñ¬Ý¬Ú¬Ù¬à¬Ó¬Ñ¬ä¬î
¬Ò¬à¬Ý¬Ö¬Ö ¬ã¬Ý¬à¬Ø¬ß¬í¬Ö ¬á¬â¬à¬ä¬à¬Ü¬à¬Ý¬í ¬á¬Ö¬â¬Ö¬Õ¬Ñ¬é¬Ú.
¬±¬à¬ã¬Ý¬Ö ¬ä¬à¬Ô¬à, ¬Ü¬Ñ¬Ü ¬Þ¬í ¬á¬à¬ã¬Ý¬Ñ¬Ý¬Ú ¬ä¬â¬Ñ¬ß¬Ù¬Ñ¬Ü¬è¬Ú¬ð, ¬Ó¬í¬Ù¬í¬Ó¬Ñ¬Ö¬ä¬ã¬ñ ¬Þ¬Ö¬ä¬à¬Õ Coverage::sample(),
¬Ü¬à¬ä¬à¬â¬í¬Û ¬ã¬à¬Ò¬Ú¬â¬Ñ¬Ö¬ä ¬Ú¬ß¬æ¬à¬â¬Þ¬Ñ¬è¬Ú¬ð ¬à ¬á¬à¬ã¬Ý¬Ñ¬ß¬ß¬í¬ç ¬ä¬â¬Ñ¬ß¬Ù¬Ñ¬Ü¬è¬Ú¬ñ¬ç.
2018. 8. 9. ¬¬¬Ý¬Ñ¬ã¬ã Driver
http://systemverilog.ru/klass-driver 2/4
¬¥¬â¬Ñ¬Û¬Ó¬Ö¬â ¬á¬à¬Ó¬ä¬à¬â¬ñ¬Ö¬ä ¬ï¬ä¬å ¬á¬à¬ã¬Ý¬Ö¬Õ¬à¬Ó¬Ñ¬ä¬Ö¬Ý¬î¬ß¬à¬ã¬ä¬î ¬Õ¬Ö¬Û¬ã¬ä¬Ó¬Ú¬Û ¬é¬Ú¬ã¬Ý¬à ¬â¬Ñ¬Ù, ¬Ü¬à¬ä¬à¬â¬à¬Ö ¬Ù¬Ñ¬Õ¬Ñ¬ß¬à
¬Ü¬à¬ß¬ã¬ä¬Ñ¬ß¬ä¬à¬Û NUM_OF_TRANS. ¬¥¬Ý¬ñ ¬å¬Õ¬à¬Ò¬ã¬ä¬Ó¬Ñ ¬ï¬ä¬Ñ ¬Ü¬à¬ß¬ã¬ä¬Ñ¬ß¬ä¬Ñ ¬à¬Ò¬ì¬ñ¬Ó¬Ý¬Ö¬ß¬Ñ ¬Ó ¬æ¬Ñ¬Û¬Ý¬Ö
Globals.sv:
	1. `define NUM_OF_TRANS 100
¬±¬à¬ã¬Ý¬Ö ¬Ù¬Ñ¬Ó¬Ö¬â¬ê¬Ö¬ß¬Ú¬ñ ¬Ô¬Ö¬ß¬Ö¬â¬Ñ¬è¬Ú¬Ú ¬Ó¬ã¬Ö¬ç ¬ä¬â¬Ñ¬ß¬Ù¬Ñ¬Ü¬è¬Ú¬Û ¬Õ¬â¬Ñ¬Û¬Ó¬Ö¬â ¬å¬ã¬ä¬Ñ¬ß¬Ñ¬Ó¬Ý¬Ú¬Ó¬Ñ¬Ö¬ä ¬ã¬Ú¬Ô¬ß¬Ñ¬Ý
¬à¬ã¬ä¬Ñ¬ß¬à¬Ó¬Ü¬Ú ¬Ô¬Ö¬ß¬Ö¬â¬Ñ¬è¬Ú¬Ú ¬ä¬Ö¬ã¬ä¬à¬Ó¬í¬ç ¬Ó¬à¬Ù¬Õ¬Ö¬Û¬ã¬ä¬Ó¬Ú¬Û:
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