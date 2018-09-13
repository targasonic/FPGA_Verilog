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

¬£ ¬Ü¬Ý¬Ñ¬ã¬ã¬Ö Transaction, ¬à¬á¬Ú¬ã¬Ñ¬ß¬ß¬à¬Þ ¬Ó ¬æ¬Ñ¬Û¬Ý¬Ö Transaction.sv, ¬à¬Ò¬ì¬ñ¬Ó¬Ý¬ñ¬ð¬ä¬ã¬ñ ¬Õ¬Ñ¬ß¬ß¬í¬Ö,
¬Ü¬à¬ä¬à¬â¬í¬Ö ¬á¬à¬ã¬í¬Ý¬Ñ¬ð¬ä¬ã¬ñ ¬ß¬Ñ ¬ä¬Ö¬ã¬ä¬Ú¬â¬å¬Ö¬Þ¬í¬Ö ¬ã¬ç¬Ö¬Þ¬í ¬Ú ¬á¬â¬Ú¬ß¬Ú¬Þ¬Ñ¬ð¬ä¬ã¬ñ ¬à¬ä ¬ß¬Ú¬ç. 
¬¥¬Ý¬ñ ¬â¬Ö¬Ñ¬Ý¬Ú¬Ù¬Ñ¬è¬Ú¬Ú ¬Þ¬Ö¬ç¬Ñ¬ß¬Ú¬Ù¬Þ¬Ñ ¬Ô¬Ö¬ß¬Ö¬â¬Ñ¬è¬Ú¬Ú ¬ã¬Ý¬å¬é¬Ñ¬Û¬ß¬í¬ç ¬ä¬Ö¬ã¬ä¬à¬Ó¬í¬ç ¬Ó¬à¬Ù¬Õ¬Ö¬Û¬ã¬ä¬Ó¬Ú¬Û ¬Ó¬ã¬Ö ¬á¬à¬ã¬í¬Ý¬Ñ¬Ö¬Þ¬í¬Ö ¬ß¬Ñ
¬ä¬Ö¬ã¬ä¬Ú¬â¬å¬Ö¬Þ¬í¬Ö ¬ã¬ç¬Ö¬Þ¬í ¬ã¬Ú¬Ô¬ß¬Ñ¬Ý¬í ¬à¬Ò¬ì¬ñ¬Ó¬Ý¬ñ¬ð¬ä¬ã¬ñ ¬ä¬Ú¬á¬Ñ¬Þ¬Ú rand bit ¬Ú¬Ý¬Ú randc bit. 
¬±¬â¬Ú¬ß¬Ú¬Þ¬Ñ¬Ö¬Þ¬í¬Ö ¬ã¬Ú¬Ô¬ß¬Ñ¬Ý¬í ¬à¬Ò¬ì¬ñ¬Ó¬Ý¬ñ¬ð¬ä¬ã¬ñ, ¬Ü¬Ñ¬Ü bit. 
¬´¬Ñ¬Ü¬Ø¬Ö ¬Ó ¬Ü¬Ý¬Ñ¬ã¬ã¬Ö ¬à¬á¬Ú¬ã¬Ñ¬ß¬í ¬Þ¬Ö¬ä¬à¬Õ¬í ¬Õ¬Ý¬ñ ¬Ó¬í¬Ó¬à¬Õ¬Ñ ¬Õ¬Ñ¬ß¬ß¬í¬ç ¬Ú ¬ã¬â¬Ñ¬Ó¬ß¬Ö¬ß¬Ú¬ñ ¬Ó¬í¬ç¬à¬Õ¬à¬Ó ¬ä¬Ö¬ã¬ä¬Ú¬â¬å¬Ö¬Þ¬í¬ç ¬ã¬ç¬Ö¬Þ:
	display_inputs() - ¬Ó¬í¬Ó¬à¬Õ¬Ú¬ä ¬Ó¬ç¬à¬Õ¬ß¬í¬Ö ¬ã¬Ú¬Ô¬ß¬Ñ¬Ý¬í (¬Ó¬í¬Ù¬í¬Ó¬Ñ¬Ö¬ä¬ã¬ñ ¬Õ¬â¬Ñ¬Û¬Ó¬Ö¬â¬à¬Þ);
	display_outputs() - ¬Ó¬í¬Ó¬à¬Õ¬Ú¬ä ¬Ó¬í¬ç¬à¬Õ¬ß¬í¬Ö ¬ã¬Ú¬Ô¬ß¬Ñ¬Ý¬í (¬Ó¬í¬Ù¬í¬Ó¬Ñ¬Ö¬ä¬ã¬ñ ¬Ò¬Ý¬à¬Ü¬à¬Þ ¬ã¬â¬Ñ¬Ó¬ß¬Ö¬ß¬Ú¬ñ). ¬£
¬ï¬ä¬à¬Þ ¬Þ¬Ö¬ä¬à¬Õ¬Ö ¬Ó¬í¬Ù¬í¬Ó¬Ñ¬Ö¬ä¬ã¬ñ ¬æ¬å¬ß¬Ü¬è¬Ú¬ñ $swrite, ¬Ü¬à¬ä¬à¬â¬Ñ¬ñ ¬Ù¬Ñ¬á¬Ú¬ã¬í¬Ó¬Ñ¬Ö¬ä ¬Ó¬ç¬à¬Õ¬ß¬í¬Ö ¬Õ¬Ñ¬ß¬ß¬í¬Ö ¬Ó
¬ã¬ä¬â¬à¬Ü¬å. ¬¢¬Ý¬Ñ¬Ô¬à¬Õ¬Ñ¬â¬ñ ¬ï¬ä¬à¬Þ¬å ¬æ¬å¬ß¬Ü¬è¬Ú¬ð display_outputs() ¬Þ¬à¬Ø¬ß¬à ¬Ó¬í¬Ù¬í¬Ó¬Ñ¬ä¬î ¬Ó¬ß¬å¬ä¬â¬Ú
¬ã¬Ú¬ã¬ä¬Ö¬Þ¬ß¬à¬Ô¬à ¬Ó¬í¬Ù¬à¬Ó¬Ñ $display(), ¬Ü¬Ñ¬Ü ¬ï¬ä¬à ¬ã¬Õ¬Ö¬Ý¬Ñ¬ß¬à ¬Ó ¬Ü¬Ý¬Ñ¬ã¬ã¬Ö Scoreboard.
compare() ? ¬ã¬â¬Ñ¬Ó¬ß¬Ú¬Ó¬Ñ¬Ö¬ä ¬ä¬â¬Ñ¬ß¬Ù¬Ñ¬Ü¬è¬Ú¬Ú, ¬á¬â¬Ú¬ß¬ñ¬ä¬í¬Ö ¬à¬ä ¬ã¬ä¬Ñ¬â¬à¬Û ¬Ú ¬ß¬à¬Ó¬à¬Û ¬ã¬ç¬Ö¬Þ¬í (¬Ó¬í¬Ù¬í¬Ó¬Ñ¬Ö¬ä¬ã¬ñ
¬Ò¬Ý¬à¬Ü¬à¬Þ ¬ã¬â¬Ñ¬Ó¬ß¬Ö¬ß¬Ú¬ñ). 
¬³¬à¬Õ¬Ö¬â¬Ø¬Ú¬Þ¬à¬Ö ¬ï¬ä¬à¬Û ¬æ¬å¬ß¬Ü¬è¬Ú¬Ú ¬Þ¬Ö¬ß¬ñ¬Ö¬ä¬ã¬ñ ¬Ó ¬Ù¬Ñ¬Ó¬Ú¬ã¬Ú¬Þ¬à¬ã¬ä¬Ú ¬à¬ä ¬Ü¬à¬Ý¬Ú¬é¬Ö¬ã¬ä¬Ó¬Ñ
¬ã¬â¬Ñ¬Ó¬ß¬Ú¬Ó¬Ñ¬Ö¬Þ¬í¬ç ¬ã¬Ú¬Ô¬ß¬Ñ¬Ý¬à¬Ó. ¬¥¬Ý¬ñ ¬Ü¬Ñ¬Ø¬Õ¬à¬Ô¬à ¬á¬â¬à¬Ó¬Ö¬â¬ñ¬Ö¬Þ¬à¬Ô¬à ¬Ó¬í¬ç¬à¬Õ¬ß¬à¬Ô¬à ¬ã¬Ú¬Ô¬ß¬Ñ¬Ý¬Ñ ¬ß¬Ö¬à¬Ò¬ç¬à¬Õ¬Ú¬Þ¬à
¬Ó¬ã¬ä¬Ñ¬Ó¬Ú¬ä¬î ¬Ó ¬æ¬å¬ß¬Ü¬è¬Ú¬ð ¬ã¬Ý¬Ö¬Õ¬å¬ð¬ë¬Ú¬Û ¬æ¬â¬Ñ¬Ô¬Þ¬Ö¬ß¬ä:
	1. if(trans.signal_name !== this.signal_name) begin
	2. $display(" ** ERROR **: trans : signal_name did not match");
	3. compare = 0;
	4. end
	5.
,¬Ô¬Õ¬Ö ¬Ó¬Þ¬Ö¬ã¬ä¬à signal_name ¬å¬Ü¬Ñ¬Ù¬í¬Ó¬Ñ¬Ö¬ä¬ã¬ñ ¬Ú¬Þ¬ñ ¬ã¬Ú¬Ô¬ß¬Ñ¬Ý¬Ñ ¬Õ¬Ý¬ñ ¬á¬â¬à¬Ó¬Ö¬â¬Ü¬Ú.

¬±¬à¬Þ¬Ú¬Þ¬à ¬ï¬ä¬à¬Ô¬à ¬Ó ¬Ü¬Ý¬Ñ¬ã¬ã¬Ö Transaction ¬à¬Ò¬ì¬ñ¬Ó¬Ý¬Ö¬ß¬í ¬Ó¬ã¬á¬à¬Þ¬à¬Ô¬Ñ¬ä¬Ö¬Ý¬î¬ß¬í¬Ö ¬á¬Ö¬â¬Ö¬Þ¬Ö¬ß¬ß¬í¬Ö: ¬Ó¬Ö¬Ü¬ä¬à¬â
¬à¬ê¬Ú¬Ò¬à¬Ü (errors) ¬Ú ¬ã¬Ú¬Ô¬ß¬Ñ¬Ý ¬à¬ã¬ä¬Ñ¬ß¬à¬Ó¬Ü¬Ú ¬Ô¬Ö¬ß¬Ö¬â¬Ñ¬è¬Ú¬Ú ¬ä¬Ö¬ã¬ä¬à¬Ó¬í¬ç ¬Ó¬à¬Ù¬Õ¬Ö¬Û¬ã¬ä¬Ó¬Ú¬Û (stop). 
¬¬ ¬ä¬Ú¬á¬Ñ¬Þ ¬ï¬ä¬Ú¬ç ¬á¬Ö¬â¬Ö¬Þ¬Ö¬ß¬ß¬í¬ç ¬Õ¬à¬Ò¬Ñ¬Ó¬Ý¬Ö¬ß ¬Ú¬Õ¬Ö¬ß¬ä¬Ú¬æ¬Ú¬Ü¬Ñ¬ä¬à¬â static, ¬é¬ä¬à ¬Õ¬Ö¬Ý¬Ñ¬Ö¬ä ¬ï¬ä¬Ú ¬á¬Ö¬â¬Ö¬Þ¬Ö¬ß¬ß¬í¬Ö ¬à¬Ò¬ë¬Ú¬Þ¬Ú
¬Õ¬Ý¬ñ ¬Ó¬ã¬Ö¬ç ¬ï¬Ü¬Ù¬Ö¬Þ¬á¬Ý¬ñ¬â¬à¬Ó ¬Ü¬Ý¬Ñ¬ã¬ã¬Ñ Transaction. 
¬¿¬ä¬à ¬ß¬Ö¬Ü¬Ú¬Û ¬Ñ¬ß¬Ñ¬Ý¬à¬Ô ¬â¬Ñ¬Ù¬Õ¬Ö¬Ý¬ñ¬Ö¬Þ¬à¬Û ¬á¬Ñ¬Þ¬ñ¬ä¬Ú, ¬Ü¬à¬ä¬à¬â¬í¬Û ¬á¬à¬Ù¬Ó¬à¬Ý¬ñ¬Ö¬ä ¬Ú¬Ù¬Ò¬Ö¬Ø¬Ñ¬ä¬î ¬Ú¬ã¬á¬à¬Ý¬î¬Ù¬à¬Ó¬Ñ¬ß¬Ú¬ñ ¬Ô¬Ý¬à¬Ò¬Ñ¬Ý¬î¬ß¬í¬ç ¬á¬Ö¬â¬Ö¬Þ¬Ö¬ß¬ß¬í¬ç. 
¬£ ¬ß¬Ñ¬ê¬Ö¬Þ ¬ã¬Ý¬å¬é¬Ñ¬Ö, ¬Ó ¬Ü¬Ñ¬Ü¬à¬Þ ¬Ò¬í ¬Ü¬Ý¬Ñ¬ã¬ã¬Ö ¬ß¬Ö ¬á¬â¬à¬Ú¬Ù¬à¬ê¬Ý¬Ñ ¬à¬ê¬Ú¬Ò¬Ü¬Ñ, ¬Ó¬ã¬ñ¬Ü¬Ú¬Û ¬â¬Ñ¬Ù ¬å¬Ó¬Ö¬Ý¬Ú¬é¬Ú¬Ó¬Ñ¬Ö¬ä¬ã¬ñ ¬ß¬Ñ 1 ¬à¬Ò¬ë¬Ú¬Û ¬Õ¬Ý¬ñ
¬Ó¬ã¬Ö¬ç ¬Ü¬Ý¬Ñ¬ã¬ã¬à¬Ó ¬Ó¬Ö¬Ü¬ä¬à¬â ¬à¬ê¬Ú¬Ò¬à¬Ü errors. 
¬¿¬ä¬à ¬à¬Ò¬Ý¬Ö¬Ô¬é¬Ñ¬Ö¬ä ¬Ñ¬ß¬Ñ¬Ý¬Ú¬Ù ¬â¬Ö¬Ù¬å¬Ý¬î¬ä¬Ñ¬ä¬à¬Ó ¬ã¬Ú¬Þ¬å¬Ý¬ñ¬è¬Ú¬Ú. 
¬¦¬ë ¬à¬Õ¬ß¬Ñ ¬ã¬ä¬Ñ¬ä¬Ú¬é¬Ö¬ã¬Ü¬Ñ¬ñ ¬á¬Ö¬â¬Ö¬Þ¬Ö¬ß¬ß¬Ñ¬ñ stop ¬Ó¬í¬ã¬ä¬å¬á¬Ñ¬Ö¬ä ¬Ó ¬â¬à¬Ý¬Ú ¬ã¬Ú¬ß¬ç¬â¬à¬ß¬Ú¬Ù¬Ú¬â¬å¬ð¬ë¬Ö¬Ô¬à ¬ã¬Ú¬Ô¬ß¬Ñ¬Ý¬Ñ. 
¬¿¬ä¬Ñ ¬á¬Ö¬â¬Ö¬Þ¬Ö¬ß¬ß¬Ñ¬ñ ¬å¬ã¬ä¬Ñ¬ß¬Ñ¬Ó¬Ý¬Ú¬Ó¬Ñ¬Ö¬ä¬ã¬ñ ¬Õ¬â¬Ñ¬Û¬Ó¬Ö¬â¬à¬Þ ¬Ó '1', ¬Ü¬à¬Ô¬Õ¬Ñ ¬ä¬à¬ä ¬ã¬Ô¬Ö¬ß¬Ö¬â¬Ú¬â¬à¬Ó¬Ñ¬Ý ¬Ú ¬á¬à¬ã¬Ý¬Ñ¬Ý ¬Ó¬ã¬Ö
¬ä¬â¬Ñ¬ß¬Ù¬Ñ¬Ü¬è¬Ú¬Ú, ¬Ñ ¬Ü¬Ý¬Ñ¬ã¬ã¬í ¬á¬â¬Ú¬Ö¬Þ¬ß¬Ú¬Ü¬Ñ ¬Ú ¬Ò¬Ý¬à¬Ü¬Ñ ¬ã¬â¬Ñ¬Ó¬ß¬Ö¬ß¬Ú¬ñ ¬Þ¬Ô¬ß¬à¬Ó¬Ö¬ß¬ß¬à ¬æ¬Ú¬Ü¬ã¬Ú¬â¬å¬ð¬ä ¬ï¬ä¬à
¬Ú¬Ù¬Þ¬Ö¬ß¬Ö¬ß¬Ú¬Ö ¬Ú ¬Ù¬Ñ¬Ó¬Ö¬â¬ê¬Ñ¬ð¬ä ¬ã¬Ó¬à¬ð ¬â¬Ñ¬Ò¬à¬ä¬å.

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