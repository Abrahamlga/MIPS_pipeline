// Top module, includes UART block and MIPS_arch
// Jesus Abraham Lizarraga Banuelos
// Apr-22-2019
// Top_module.sv
//


timeunit 1ns;
timeprecision 100ps;

module Top_module
#(
   parameter BIT_WIDTH=32,
   parameter REG_WIDTH = $clog2(BIT_WIDTH),
   parameter BIT_SEL=3,
   parameter BIT_CTRL=5
)
(
  input logic clk, rst,
  input i_Rx_Serial, W_UART,
  output logic uart_tx

);

logic uart_busy;
logic  [BIT_WIDTH-1:0] Data_in, Data_out; 
logic uart_wr_i;
logic [7:0] uart_dat_i;
logic clk0, clk1, clk2;
logic o_Tx_Done; 
logic en_rx;
logic [7:0] o_Data;
logic [7:0] DATA_RX;


PLL1 PLL11
(

	.inclk0(clk),
	.c0(clk0), //5MHZ
	.c1(clk1), //115200HZ
	.c2(clk2)  //.0012MHZ
);

MIPS_arch_pipeline MIPS_arch1
(
 .clk(clk),
 .rst(rst),
 .UART_DATA({24'h0,o_Data}),
 .UART_RX(Data_in),
 .W_UART(W_UART)
);

reg32 reg_32out
(
 .Read_Data(Data_out),
 .Write_Data(Data_in),
 .clk(clk),
 .rst(rst)
);
DFT_UART DFT_UART1
(
 .rst(rst),
 .clk(clk0),
 .Data(Data_out),
 .uart_dat_i(uart_dat_i),
 .uart_busy(uart_busy), 
 .uart_wr_i(uart_wr_i),
 .o_Tx_Done(o_Tx_Done)
);

uart_tx UA_TX
  (
    .i_Clock(clk1),
   .i_Tx_DV(uart_wr_i),
   .i_Tx_Byte(uart_dat_i), 
   .o_Tx_Active(uart_busy),
   .o_Tx_Serial(uart_tx),
   .o_Tx_Done(o_Tx_Done)
);

reg8_rx reg8_rx_1
(
 .Read_Data(o_Data),
 .Write_Data(DATA_RX),
 .clk(clk),
 .rst(1'b1),
 .en(en_rx)
);

 uart_rx UA_RX(
   .i_Clock(clk1),
   .i_Rx_Serial(i_Rx_Serial),
   .o_Rx_DV(en_rx),
   .o_Rx_Byte(DATA_RX)
);
	


endmodule
