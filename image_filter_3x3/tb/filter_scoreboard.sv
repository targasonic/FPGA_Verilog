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


