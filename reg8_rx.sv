// File to generate a register
// Jesus Abraham Lizarraga Banuelos
// Mar-09-2018
// reg32.sv
//

timeunit 1ns;
timeprecision 100ps;

module reg8_rx
#(
    parameter BIT_WIDTH=32
)
(
 output logic [7:0] Read_Data,
 input logic  [7:0] Write_Data,
 input logic clk,rst,en
);

always_ff @(posedge clk, negedge rst)
begin
 if (!rst)
  begin
    Read_Data = 8'h00;
  end
  else
  begin
     if(en)
     Read_Data= Write_Data;
  end 
end //always

endmodule