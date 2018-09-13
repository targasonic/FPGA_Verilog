`ifndef _SCOREBOARD_
`define _SCOREBOARD_

class FilterScoreboard;

mailbox #(Transaction) rcvr2sb;

// Constructor
function new(mailbox #(Transaction) rcvr2sb);
	this.rcvr2sb = rcvr2sb;
endfunction : new

task start();

	Transaction new_trans;

	while (!new_trans.stop) begin
		rcvr2sb.get(new_trans);
		$display(" %0d : Scoreboard : Transactions received ",$time);
		$display(" %0d : Scoreboard : NEW scheme outputs: \n %s ", $time, new_trans.display_outputs());
		if (new_trans.compare(new_trans)) begin
			$display(" %0d : Scoreboard : Equal outputs ",$time);
		end else begin
			$display(" %0d : Scoreboard : **ERROR: Unequal outputs ",$time);
			new_trans.errors++;
		end
	end

endtask : start

endclass

`endif




/*

���ݬѬ�� Scoreboard ���ڬ�Ѭ� �� ��Ѭ۬ݬ� Scoreboard.sv. ����߬�Ӭ߬�� �ެ֬��� �ܬݬѬ���
Scoreboard::start() ����ݬ֬լ�ӬѬ�֬ݬ�߬� �Ҭ֬�֬� ����ݬѬ߬߬�� ���ڬ֬ެ߬ڬܬѬެ� ���Ѭ߬٬Ѭܬ�ڬ� �ڬ�
������Ӭ�� ���ڬܬ��:
1. rcvr2sb[0].get(old_trans);
2. rcvr2sb[1].get(new_trans);
�� ���ѬӬ߬ڬӬѬ֬� �ڬ�:
1. if (old_trans.compare(new_trans)) begin
2. $display(" %0d : Scoreboard : Equal outputs ",$time);
3. end else begin
4. $display(" %0d : Scoreboard : **ERROR: Unequal outputs ",$time);
5. old_trans.errors++;
6. end
���ݬ� ���ѬӬ߬֬߬ڬ� �Ӭ�٬�ӬѬ֬��� �ެ֬��� Transaction::compare. ����ݬ� ���Ѭ߬٬Ѭܬ�ڬ� �߬�
���Ӭ�ѬլѬ��, ��� �Ӭ֬ܬ��� ���ڬҬ�� ��Ӭ֬ݬڬ�ڬӬѬ֬��� �߬� 1. ����� �լ֬۬��Ӭڬ� �Ӭ���ݬ߬����� �լ� ��֬�
����, ���ܬ� �լ�Ѭ۬Ӭ֬� �߬� �Ӭ���ѬӬڬ� ��ڬԬ߬Ѭ� stop.
����� �ܬݬѬ��� Scoreboard:

*/
