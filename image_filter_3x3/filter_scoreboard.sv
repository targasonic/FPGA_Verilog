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

¬¬¬Ý¬Ñ¬ã¬ã Scoreboard ¬à¬á¬Ú¬ã¬Ñ¬ß ¬Ó ¬æ¬Ñ¬Û¬Ý¬Ö Scoreboard.sv. ¬°¬ã¬ß¬à¬Ó¬ß¬à¬Û ¬Þ¬Ö¬ä¬à¬Õ ¬Ü¬Ý¬Ñ¬ã¬ã¬Ñ
Scoreboard::start() ¬á¬à¬ã¬Ý¬Ö¬Õ¬à¬Ó¬Ñ¬ä¬Ö¬Ý¬î¬ß¬à ¬Ò¬Ö¬â¬Ö¬ä ¬á¬à¬ã¬Ý¬Ñ¬ß¬ß¬í¬Ö ¬á¬â¬Ú¬Ö¬Þ¬ß¬Ú¬Ü¬Ñ¬Þ¬Ú ¬ä¬â¬Ñ¬ß¬Ù¬Ñ¬Ü¬è¬Ú¬Ú ¬Ú¬Ù
¬á¬à¬é¬ä¬à¬Ó¬í¬ç ¬ñ¬ë¬Ú¬Ü¬à¬Ó:
1. rcvr2sb[0].get(old_trans);
2. rcvr2sb[1].get(new_trans);
¬Ú ¬ã¬â¬Ñ¬Ó¬ß¬Ú¬Ó¬Ñ¬Ö¬ä ¬Ú¬ç:
1. if (old_trans.compare(new_trans)) begin
2. $display(" %0d : Scoreboard : Equal outputs ",$time);
3. end else begin
4. $display(" %0d : Scoreboard : **ERROR: Unequal outputs ",$time);
5. old_trans.errors++;
6. end
¬¥¬Ý¬ñ ¬ã¬â¬Ñ¬Ó¬ß¬Ö¬ß¬Ú¬ñ ¬Ó¬í¬Ù¬í¬Ó¬Ñ¬Ö¬ä¬ã¬ñ ¬Þ¬Ö¬ä¬à¬Õ Transaction::compare. ¬¦¬ã¬Ý¬Ú ¬ä¬â¬Ñ¬ß¬Ù¬Ñ¬Ü¬è¬Ú¬Ú ¬ß¬Ö
¬ã¬à¬Ó¬á¬Ñ¬Õ¬Ñ¬ð¬ä, ¬ä¬à ¬Ó¬Ö¬Ü¬ä¬à¬â ¬à¬ê¬Ú¬Ò¬à¬Ü ¬å¬Ó¬Ö¬Ý¬Ú¬é¬Ú¬Ó¬Ñ¬Ö¬ä¬ã¬ñ ¬ß¬Ñ 1. ¬¿¬ä¬Ú ¬Õ¬Ö¬Û¬ã¬ä¬Ó¬Ú¬ñ ¬Ó¬í¬á¬à¬Ý¬ß¬ñ¬ð¬ä¬ã¬ñ ¬Õ¬à ¬ä¬Ö¬ç
¬á¬à¬â, ¬á¬à¬Ü¬Ñ ¬Õ¬â¬Ñ¬Û¬Ó¬Ö¬â ¬ß¬Ö ¬Ó¬í¬ã¬ä¬Ñ¬Ó¬Ú¬ä ¬ã¬Ú¬Ô¬ß¬Ñ¬Ý stop.
¬¬¬à¬Õ ¬Ü¬Ý¬Ñ¬ã¬ã¬Ñ Scoreboard:

*/
