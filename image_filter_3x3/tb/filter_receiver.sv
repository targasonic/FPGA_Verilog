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

// O皆科竿皇看盆盼盼秒相 皇 祆癸相看盆 Receiver.sv 眉看癸研研 Receiver 砌癸眉盅盆, 眉癸眉 盹 盈砂癸相皇盆砂, 研眇盈盆砂盅盹砌 盾盆砌眇盈 start():

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
