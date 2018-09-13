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

// O�Ҭ��Ӭݬ֬߬߬�� �� ��Ѭ۬ݬ� Receiver.sv �ܬݬѬ�� Receiver ��Ѭܬج�, �ܬѬ� �� �լ�Ѭ۬Ӭ֬�, ���լ֬�جڬ� �ެ֬��� start():

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
����ܬ� �߬� ���ڬ�֬� ��ڬԬ߬Ѭ� stop, �ܬ������ �Ӭ���ѬӬݬ�֬� Driver, ���Ӭ����֬��� ��ݬ֬լ���Ѭ� ����ݬ֬լ�ӬѬ�֬ݬ�߬���� �լ֬۬��Ӭڬ�:
1) ����ڬ߬ڬެѬ֬��� ���Ѭ߬٬Ѭܬ�ڬ�:
1. receive(trans);
2) ����ڬ߬��Ѭ� ���Ѭ߬٬Ѭܬ�ڬ� �ܬݬѬլ֬��� �� ������Ӭ�� ���ڬ�:
1. rcvr2sb.put(trans);
���߬Ѭݬ�Ԭڬ�߬� �ެ֬��լ� Driver::drive() �� �ެ֬��լ� receive() ���ڬ֬� ���Ѭ߬٬Ѭܬ�ڬ� �ެ�ج߬� �ܬ�߬�ڬԬ��ڬ��ӬѬ�� �� �٬ѬӬڬ�ڬެ���� ��� ���ڬ߬�ڬ�� ��ѬҬ���
��֬��ڬ��֬ެ�� ���֬ެ�.
���� ���ڬ�Ѭ߬߬�� �� �ܬݬѬ��� Receiver �ެ֬��լ�� ���� �ܬ�߬�ڬԬ��ڬ��ӬѬ߬ڬ� �ڬ٬ެ֬߬�֬��� ���ݬ�ܬ� �ެ֬��� receive().
*/