// Memory Architecture for RAM
// Jesus Abraham Lizarraga Banuelos
// April-17-2019
// mem_arch_RAM.sv
//

timeunit 1ns;
timeprecision 100ps;
module mem_arch_RAM
#(
    parameter BIT_WIDTH=32
)
(
 output logic [BIT_WIDTH-1:0] Read_Data_out, READ_UART,
 input logic  [BIT_WIDTH-1:0] Write_Data_in, Address_in, WRITE_UART,
 input logic MemWrite, W_UART, clk
);

logic [BIT_WIDTH-1:0] Address;
logic [BIT_WIDTH-1:0] Read_Data_RAM;
logic  [BIT_WIDTH-1:0] ADDR_UART;

logic f_RAM;
mem_ram mem_ram1
(
 .Read_Data_out(Read_Data_RAM),
 .Write_Data_in(Write_Data_in),
 .Address_in(Address),
 .MemWrite(MemWrite),
 .clk(clk),
 .READ_UART(READ_UART),
 .WRITE_UART(WRITE_UART),
 .ADDR_UART(ADDR_UART),
 .W_UART(W_UART)
);

//ROM
//00400000
//RAM
//10010000

always_comb
 begin
  f_RAM=(|Address_in[BIT_WIDTH-1:29] | (|Address_in[BIT_WIDTH-1:28] & |Address_in[27:16]));
  Address =(f_RAM)? Address_in-32'h10010000 : Address_in-32'h00400000;
  Address = {2'h0,Address[BIT_WIDTH-1:2]}; 
  Read_Data_out =(f_RAM)? Read_Data_RAM:32'h00000000; //32'h00000000 Data out of range
 end

// UART PORT
always_comb
begin
  ADDR_UART=(W_UART)? 32'h2 : 32'h3; //32'h10010008: 32'h1001000C;
 end



endmodule
