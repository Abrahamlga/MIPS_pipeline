// Memory ROM, created by MARS.jar
// Jesus Abraham Lizarraga Banuelos
// April-17-2019
// memory_rom.sv
//

timeunit 1ns;
timeprecision 100ps;

module memory_rom
#(
    parameter BIT_WIDTH=32
)
(
 output logic [BIT_WIDTH-1:0] Read_Data_out,
 input logic  [BIT_WIDTH-1:0] Address_in
);

 logic [BIT_WIDTH-1:0] reg_mem [0:127] ;

always_comb
 begin
  Read_Data_out=reg_mem[Address_in];
    $readmemh("factorial15_idlesw_bymemory_p3_4.mem", reg_mem); //factorial15_idlesw_bymemory_p3_3.mem passing
 end
endmodule
