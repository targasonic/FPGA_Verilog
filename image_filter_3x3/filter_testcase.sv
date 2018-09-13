`ifndef _TESTCASE_
`define _TESTCASE_

`include "filter_environment.sv"

program testcase(
	input_interface.input_prt input_intf,
	output_interface.output_prt output_intf
);

FilterEnvironment env;

initial begin
	$display(" Start of program block testcase");
	env = new(input_intf, output_intf);
	env.run();
end

final
$display(" End of program block testcase");

endprogram

`endif