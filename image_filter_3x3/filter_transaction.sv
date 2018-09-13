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


/*

�� �ܬݬѬ��� Transaction, ���ڬ�Ѭ߬߬�� �� ��Ѭ۬ݬ� Transaction.sv, ��Ҭ��Ӭݬ����� �լѬ߬߬��,
�ܬ������ �����ݬѬ���� �߬� ��֬��ڬ��֬ެ�� ���֬ެ� �� ���ڬ߬ڬެѬ���� ��� �߬ڬ�. 
���ݬ� ��֬Ѭݬڬ٬Ѭ�ڬ� �ެ֬�Ѭ߬ڬ٬ެ� �Ԭ֬߬֬�Ѭ�ڬ� ��ݬ��Ѭ۬߬�� ��֬���Ӭ�� �Ӭ�٬լ֬۬��Ӭڬ� �Ӭ�� �����ݬѬ֬ެ�� �߬�
��֬��ڬ��֬ެ�� ���֬ެ� ��ڬԬ߬Ѭݬ� ��Ҭ��Ӭݬ����� ��ڬ�Ѭެ� rand bit �ڬݬ� randc bit. 
����ڬ߬ڬެѬ֬ެ�� ��ڬԬ߬Ѭݬ� ��Ҭ��Ӭݬ�����, �ܬѬ� bit. 
���Ѭܬج� �� �ܬݬѬ��� ���ڬ�Ѭ߬� �ެ֬��լ� �լݬ� �Ӭ�Ӭ�լ� �լѬ߬߬�� �� ���ѬӬ߬֬߬ڬ� �Ӭ���լ�� ��֬��ڬ��֬ެ�� ���֬�:
	display_inputs() - �Ӭ�Ӭ�լڬ� �Ӭ��լ߬�� ��ڬԬ߬Ѭݬ� (�Ӭ�٬�ӬѬ֬��� �լ�Ѭ۬Ӭ֬���);
	display_outputs() - �Ӭ�Ӭ�լڬ� �Ӭ���լ߬�� ��ڬԬ߬Ѭݬ� (�Ӭ�٬�ӬѬ֬��� �Ҭݬ�ܬ�� ���ѬӬ߬֬߬ڬ�). ��
����� �ެ֬��լ� �Ӭ�٬�ӬѬ֬��� ���߬ܬ�ڬ� $swrite, �ܬ����Ѭ� �٬Ѭ�ڬ��ӬѬ֬� �Ӭ��լ߬�� �լѬ߬߬�� ��
�����ܬ�. ���ݬѬԬ�լѬ�� ����ެ� ���߬ܬ�ڬ� display_outputs() �ެ�ج߬� �Ӭ�٬�ӬѬ�� �Ӭ߬����
��ڬ��֬ެ߬�Ԭ� �Ӭ�٬�Ӭ� $display(), �ܬѬ� ���� ��լ֬ݬѬ߬� �� �ܬݬѬ��� Scoreboard.
compare() ? ���ѬӬ߬ڬӬѬ֬� ���Ѭ߬٬Ѭܬ�ڬ�, ���ڬ߬���� ��� ���Ѭ��� �� �߬�Ӭ�� ���֬ެ� (�Ӭ�٬�ӬѬ֬���
�Ҭݬ�ܬ�� ���ѬӬ߬֬߬ڬ�). 
����լ֬�جڬެ�� ����� ���߬ܬ�ڬ� �ެ֬߬�֬��� �� �٬ѬӬڬ�ڬެ���� ��� �ܬ�ݬڬ�֬��Ӭ�
���ѬӬ߬ڬӬѬ֬ެ�� ��ڬԬ߬Ѭݬ��. ���ݬ� �ܬѬجլ�Ԭ� ����Ӭ֬��֬ެ�Ԭ� �Ӭ���լ߬�Ԭ� ��ڬԬ߬Ѭݬ� �߬֬�Ҭ��լڬެ�
�Ӭ��ѬӬڬ�� �� ���߬ܬ�ڬ� ��ݬ֬լ���ڬ� ���ѬԬެ֬߬�:
	1. if(trans.signal_name !== this.signal_name) begin
	2. $display(" ** ERROR **: trans : signal_name did not match");
	3. compare = 0;
	4. end
	5.
,�Ԭլ� �Ӭެ֬��� signal_name ��ܬѬ٬�ӬѬ֬��� �ڬެ� ��ڬԬ߬Ѭݬ� �լݬ� ����Ӭ֬�ܬ�.

����ެڬެ� ����Ԭ� �� �ܬݬѬ��� Transaction ��Ҭ��Ӭݬ֬߬� �Ӭ���ެ�ԬѬ�֬ݬ�߬�� ��֬�֬ެ֬߬߬��: �Ӭ֬ܬ���
���ڬҬ�� (errors) �� ��ڬԬ߬Ѭ� ����Ѭ߬�Ӭܬ� �Ԭ֬߬֬�Ѭ�ڬ� ��֬���Ӭ�� �Ӭ�٬լ֬۬��Ӭڬ� (stop). 
�� ��ڬ�Ѭ� ���ڬ� ��֬�֬ެ֬߬߬�� �լ�ҬѬӬݬ֬� �ڬլ֬߬�ڬ�ڬܬѬ��� static, ���� �լ֬ݬѬ֬� ���� ��֬�֬ެ֬߬߬�� ��Ҭ�ڬެ�
�լݬ� �Ӭ�֬� ��ܬ٬֬ެ�ݬ���� �ܬݬѬ��� Transaction. 
����� �߬֬ܬڬ� �Ѭ߬Ѭݬ�� ��Ѭ٬լ֬ݬ�֬ެ�� ��Ѭެ���, �ܬ������ ���٬Ӭ�ݬ�֬� �ڬ٬Ҭ֬جѬ�� �ڬ���ݬ�٬�ӬѬ߬ڬ� �Ԭݬ�ҬѬݬ�߬�� ��֬�֬ެ֬߬߬��. 
�� �߬Ѭ�֬� ��ݬ��Ѭ�, �� �ܬѬܬ�� �Ҭ� �ܬݬѬ��� �߬� ����ڬ٬��ݬ� ���ڬҬܬ�, �Ӭ��ܬڬ� ��Ѭ� ��Ӭ֬ݬڬ�ڬӬѬ֬��� �߬� 1 ��Ҭ�ڬ� �լݬ�
�Ӭ�֬� �ܬݬѬ���� �Ӭ֬ܬ��� ���ڬҬ�� errors. 
����� ��Ҭݬ֬Ԭ�Ѭ֬� �Ѭ߬Ѭݬڬ� ��֬٬�ݬ��Ѭ��� ��ڬެ�ݬ��ڬ�. 
���� ��լ߬� ���Ѭ�ڬ�֬�ܬѬ� ��֬�֬ެ֬߬߬Ѭ� stop �Ӭ�����Ѭ֬� �� ���ݬ� ��ڬ߬���߬ڬ٬ڬ����֬Ԭ� ��ڬԬ߬Ѭݬ�. 
����� ��֬�֬ެ֬߬߬Ѭ� ����Ѭ߬ѬӬݬڬӬѬ֬��� �լ�Ѭ۬Ӭ֬��� �� '1', �ܬ�Ԭլ� ���� ��Ԭ֬߬֬�ڬ��ӬѬ� �� ����ݬѬ� �Ӭ��
���Ѭ߬٬Ѭܬ�ڬ�, �� �ܬݬѬ��� ���ڬ֬ެ߬ڬܬ� �� �Ҭݬ�ܬ� ���ѬӬ߬֬߬ڬ� �ެԬ߬�Ӭ֬߬߬� ��ڬܬ�ڬ���� ����
�ڬ٬ެ֬߬֬߬ڬ� �� �٬ѬӬ֬��Ѭ�� ��Ӭ�� ��ѬҬ���.

*/


/*

`include "sort_defines.svh"

class sort_trans_t #( 
  parameter DWIDTH         = 8,
  // should be 2**AWIDTH of sort_engine
  parameter MAX_TRANS_SIZE = 64
);
  rand sort_trans_type_t _type;
  
  rand int size;

  bit [DWIDTH-1:0] payload [$];

  constraint size_c {
    size > 0;
    size <= MAX_TRANS_SIZE; 
  }
  
  function bit is_equal( input sort_trans_t b );
    // we can't rely on size, because it can be not initialized
    // (after monitor, for example)
    if( payload.size() != b.payload.size() )
      return 0;

    for( int i = 0; i < payload.size(); i++ )
      begin
        if( payload[i] != b.payload[i] )
          begin
            return 0;
          end
      end

    return 1;

  endfunction

  function void sort();
    payload.sort();
  endfunction

  function void print();
    $display("type = %s", _type.name() );
    $display("size = %d", size );
    for( int i = 0; i < size; i++ )
      begin
        $display("[%d] = %04h", i, payload[i] );
      end
  endfunction

  function void post_randomize();
    $display("%m: in post_randomize");
    
    payload = {};

    for( int i = 0; i < size; i++ )
      begin
        case( _type )
          RANDOM: 
            begin
              payload.push_back( $urandom() );
            end

          INCREASING:
            begin
              payload.push_back( i );
            end

          DECREASING:
            begin
              payload.push_back( size - i - 1 );
            end

          CONSTANT:
            begin
              if( i == 0 ) begin
                payload.push_back( $urandom() );
              end else begin
                payload.push_back( payload[0] );
              end
            end

          default:
            begin
              $error("Unknown: type = %s ", _type );
              $fatal();
            end

        endcase
      end

  endfunction

endclass


*/