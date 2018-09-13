`ifndef _TRANSACTION_
`define _TRANSACTION_

class Transaction;

static int errors = 0;
static bit stop = 0;

rand bit [7:0] data_i;
rand bit       valid_i;
rand bit       frame_i;

bit [7:0]	data_o;
bit			valid_o;
bit			frame_o;

// Display transaction's inputs
virtual function void display_inputs();
	$display(" Transaction inputs: a = %h, b = %h, c = %h ", data_i, valid_i, frame_i);
endfunction : display_inputs

// Display transaction's outputs
virtual function string display_outputs();
	$swrite(display_outputs, "result = %h", result);
endfunction : display_outputs

// Compare transactions
virtual function bit compare(Transaction trans);

compare = 1;

if (trans == null) begin
	$display(" ** ERROR ** : trans : received a null object ");
	compare = 0;
end else begin
	if(trans.data_o !== this.data_o) begin
	$display(" ** ERROR **: trans : result did not match");
	compare = 0;
end
end

endfunction : compare

endclass

`endif
