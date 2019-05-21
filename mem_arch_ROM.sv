// Memory Architecture, same structure for ROM and RAM
// Jesus Abraham Lizarraga Banuelos
// March-24-2018
// mem_arch_ROM.sv
//

timeunit 1ns;
timeprecision 100ps;
module mem_arch_ROM
#(
    parameter BIT_WIDTH=32
)
(
 output logic [BIT_WIDTH-1:0] Read_Data_out,
 input logic  [BIT_WIDTH-1:0] Address_in
);

logic [BIT_WIDTH-1:0] Address;
logic [BIT_WIDTH-1:0] Read_Data_ROM;
logic f_RAM;

memory_rom mem_rom
(
 .Address_in(Address),
 .Read_Data_out(Read_Data_ROM)
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
  Read_Data_out =(f_RAM)? 32'h00000000:Read_Data_ROM;
 end

endmodule
