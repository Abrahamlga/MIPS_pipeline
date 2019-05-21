
// DFT UART block  Design For Test
// Jesus Abraham Lizarraga Banuelos
// Mar-31-2018
// DFT_UART.sv
//

timeunit 1ns;
timeprecision 100ps;

module DFT_UART
#(
   parameter BIT_WIDTH=32,
   parameter REG_WIDTH = $clog2(BIT_WIDTH),
   parameter BIT_SEL=3,
   parameter BIT_CTRL=5
)
(
 input logic  [BIT_WIDTH-1:0] Data,
 input rst, clk, uart_busy,o_Tx_Done,
 output logic [7:0] uart_dat_i,
 output logic uart_wr_i
);


localparam IDLE= 5'd0,COUNT3= 5'd1,
	   COUNT2= 5'd2,COUNT1= 5'd3,
           COUNT0= 5'd4,FINISH_ST=5'd5, 
			  IDLE_C3=5'd6, IDLE_C2=5'd7,
			  IDLE_C1=5'd8, IDLE_C0=5'd9,
			  WAIT_ST=5'd10;
			    
			  
logic [4:0] state, nstate;
logic  [BIT_WIDTH-1:0] data_tmp;
logic f_work, f_count3, f_count2, f_count1, f_count0;
logic [7:0] tmp_uart_dat_i;
logic tmp_uart_wr_i;
logic [16:0] Clock_Count=32'h0;


always_comb
begin
 uart_dat_i= tmp_uart_dat_i;
 uart_wr_i = tmp_uart_wr_i;
end


always_ff @(posedge clk, negedge rst)
begin
 if(!rst)
  data_tmp=32'h0;
  else begin
    data_tmp=Data;
  end
end //always

always_comb
begin
 nstate= state;
 case (state)
//  IDLE: nstate =  (~uart_busy  &f_work)? COUNT3: IDLE;
//  COUNT3: nstate =  (f_count3 & uart_busy)? IDLE_C3: COUNT3;
//  IDLE_C3:  nstate =  (~uart_busy & o_Tx_Done &f_work)? COUNT2: IDLE_C3;
//  COUNT2: nstate =  (f_count2 & uart_busy)? IDLE_C2: COUNT2;
//  IDLE_C2:  nstate =  (~uart_busy & o_Tx_Done &f_work)? COUNT1: IDLE_C2;
//  COUNT1: nstate =  (f_count1 & uart_busy)? IDLE_C1: COUNT1;
//  IDLE_C1:  nstate =  (~uart_busy & o_Tx_Done &f_work)? COUNT0: IDLE_C1;
//  COUNT0: nstate =  (f_count0 & uart_busy)? IDLE_C0: COUNT0;
//  IDLE_C0:  nstate =  (~uart_busy & o_Tx_Done &f_work)? COUNT3: IDLE_C0;

   IDLE: nstate =  (~uart_busy  &f_work)? COUNT3: IDLE;
  COUNT3: nstate =  (f_count3 & uart_busy)? IDLE_C3: COUNT3;
  IDLE_C3:  nstate =  (~uart_busy & o_Tx_Done &f_work)? COUNT2: IDLE_C3;
  COUNT2: nstate =  (f_count2 & uart_busy)? IDLE_C2: COUNT2;
  IDLE_C2:  nstate =  (~uart_busy & o_Tx_Done &f_work)? COUNT1: IDLE_C2;
  COUNT1: nstate =  (f_count1 & uart_busy)? IDLE_C1: COUNT1;
  IDLE_C1:  nstate =  (~uart_busy & o_Tx_Done &f_work)? COUNT0: IDLE_C1;
  COUNT0: nstate =  (f_count0 & uart_busy)? IDLE_C0: COUNT0;
  IDLE_C0:  nstate =  (~uart_busy & o_Tx_Done &f_work)? COUNT3: IDLE_C0;

 
  
   default: nstate =  (~uart_busy &f_work)? COUNT3: IDLE;
 endcase //state
end

always_ff @(posedge clk, negedge rst)
begin
 if (!rst)
  begin
    state<= IDLE;
  end
  else
  begin
   state<=nstate;
  end 
end


//assign tmp_uart_wr_i=(o_Tx_Done)?1'b1:1'b0;

always @(*)
begin
 tmp_uart_dat_i=8'hAA;
 f_count3=1'b0;
 f_count2=1'b0;
 f_count1=1'b0;
 f_count0=1'b0;
 f_work=1'b0;
 tmp_uart_wr_i=1'b0;

 
 case (state)
  IDLE: begin
   f_work=1'b1;
  end //IDLE case 
  
  COUNT3: begin
    tmp_uart_dat_i=data_tmp[31:24];
    //tmp_uart_dat_i=8'hF1;
	 	 f_count3=1'b1;
    tmp_uart_wr_i=1'b1; 
  end //COUNT3 case 
  COUNT2: begin
    tmp_uart_dat_i=data_tmp[23:16];
	 //tmp_uart_dat_i=8'hE2;
	 	 f_count2=1'b1;
	 tmp_uart_wr_i=1'b1; 
  end //COUNT2 case 
  COUNT1: begin
    tmp_uart_dat_i=data_tmp[15:8];
	 //tmp_uart_dat_i=8'hD3;
	  	 f_count1=1'b1;
	 tmp_uart_wr_i=1'b1; 
  end //COUNT1 case 
  COUNT0: begin
    tmp_uart_dat_i=data_tmp[7:0];
 	 //tmp_uart_dat_i=8'hC4;
	  	 f_count0=1'b1;
	 tmp_uart_wr_i=1'b1; 
  end //COUNT0 case 
  
  IDLE_C3: begin
   f_work=1'b1;
  end //IDLE_C3 case 
  IDLE_C2: begin
   f_work=1'b1;
  end //IDLE_C2 case 
  IDLE_C1: begin
   f_work=1'b1;
  end //IDLE_C1 case 
  IDLE_C0: begin
   f_work=1'b1;
  end //IDLE_C0 case  

  FINISH_ST: begin
  end //FINISH_ST case

 endcase
end //always

endmodule
