`ifndef _RECEIVER_
`define _RECEIVER_

class FilterDriverReceiver;

virtual output_interface.output_prt output_intf;
mailbox #(Transaction) rcvr2sb;

// Constructor
function new(
	virtual output_interface.output_prt output_intf_new,
	mailbox #(Transaction) rcvr2sb
	);
	this.output_intf = output_intf_new ;
	if(rcvr2sb == null) begin
		$display(" **ERROR: rcvr2sb is null");
		$finish;
	end else
		this.rcvr2sb = rcvr2sb;
endfunction : new

task receive(Transaction trans);
	@(posedge output_intf.clock);
	trans.result = output_intf.cb.result;
endtask

// O¬Ò¬ì¬ñ¬Ó¬Ý¬Ö¬ß¬ß¬í¬Û ¬Ó ¬æ¬Ñ¬Û¬Ý¬Ö Receiver.sv ¬Ü¬Ý¬Ñ¬ã¬ã Receiver ¬ä¬Ñ¬Ü¬Ø¬Ö, ¬Ü¬Ñ¬Ü ¬Ú ¬Õ¬â¬Ñ¬Û¬Ó¬Ö¬â, ¬ã¬à¬Õ¬Ö¬â¬Ø¬Ú¬ä ¬Þ¬Ö¬ä¬à¬Õ start():

// Start method
task start();
Transaction trans = new();
while (!trans.stop) begin
	receive(trans);
	rcvr2sb.put(trans);
end
endtask : start

endclass

`endif

/*
¬±¬à¬Ü¬Ñ ¬ß¬Ö ¬á¬â¬Ú¬ê¬Ö¬Ý ¬ã¬Ú¬Ô¬ß¬Ñ¬Ý stop, ¬Ü¬à¬ä¬à¬â¬í¬Û ¬Ó¬í¬ã¬ä¬Ñ¬Ó¬Ý¬ñ¬Ö¬ä Driver, ¬á¬à¬Ó¬ä¬à¬â¬ñ¬Ö¬ä¬ã¬ñ ¬ã¬Ý¬Ö¬Õ¬å¬ð¬ë¬Ñ¬ñ ¬á¬à¬ã¬Ý¬Ö¬Õ¬à¬Ó¬Ñ¬ä¬Ö¬Ý¬î¬ß¬à¬ã¬ä¬î ¬Õ¬Ö¬Û¬ã¬ä¬Ó¬Ú¬Û:
1) ¬±¬â¬Ú¬ß¬Ú¬Þ¬Ñ¬Ö¬ä¬ã¬ñ ¬ä¬â¬Ñ¬ß¬Ù¬Ñ¬Ü¬è¬Ú¬ñ:
1. receive(trans);
2) ¬±¬â¬Ú¬ß¬ñ¬ä¬Ñ¬ñ ¬ä¬â¬Ñ¬ß¬Ù¬Ñ¬Ü¬è¬Ú¬ñ ¬Ü¬Ý¬Ñ¬Õ¬Ö¬ä¬ã¬ñ ¬Ó ¬á¬à¬é¬ä¬à¬Ó¬í¬Û ¬ñ¬ë¬Ú¬Ü:
1. rcvr2sb.put(trans);
¬¡¬ß¬Ñ¬Ý¬à¬Ô¬Ú¬é¬ß¬à ¬Þ¬Ö¬ä¬à¬Õ¬å Driver::drive() ¬Ó ¬Þ¬Ö¬ä¬à¬Õ¬Ö receive() ¬á¬â¬Ú¬Ö¬Þ ¬ä¬â¬Ñ¬ß¬Ù¬Ñ¬Ü¬è¬Ú¬Ú ¬Þ¬à¬Ø¬ß¬à ¬Ü¬à¬ß¬æ¬Ú¬Ô¬å¬â¬Ú¬â¬à¬Ó¬Ñ¬ä¬î ¬Ó ¬Ù¬Ñ¬Ó¬Ú¬ã¬Ú¬Þ¬à¬ã¬ä¬Ú ¬à¬ä ¬á¬â¬Ú¬ß¬è¬Ú¬á¬Ñ ¬â¬Ñ¬Ò¬à¬ä¬í
¬ä¬Ö¬ã¬ä¬Ú¬â¬å¬Ö¬Þ¬à¬Û ¬ã¬ç¬Ö¬Þ¬í.
¬ª¬Ù ¬à¬á¬Ú¬ã¬Ñ¬ß¬ß¬í¬ç ¬Ó ¬Ü¬Ý¬Ñ¬ã¬ã¬Ö Receiver ¬Þ¬Ö¬ä¬à¬Õ¬à¬Ó ¬á¬â¬Ú ¬Ü¬à¬ß¬æ¬Ú¬Ô¬å¬â¬Ú¬â¬à¬Ó¬Ñ¬ß¬Ú¬Ú ¬Ú¬Ù¬Þ¬Ö¬ß¬ñ¬Ö¬ä¬ã¬ñ ¬ä¬à¬Ý¬î¬Ü¬à ¬Þ¬Ö¬ä¬à¬Õ receive().
*/