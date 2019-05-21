// File to generate a register
// Jesus Abraham Lizarraga Banuelos
// Mar-09-2018
// reg32.sv
//

timeunit 1ns;
timeprecision 100ps;

module reg32
#(
    parameter BIT_WIDTH=32
)
(
 output logic [BIT_WIDTH-1:0] Read_Data,
 input logic  [BIT_WIDTH-1:0] Write_Data,
 input logic clk,rst
);

always_ff @(posedge clk, negedge rst)
begin
 if (!rst)
  begin
    Read_Data <= 32'h00000000;
  end
  else
  begin
     Read_Data<= Write_Data;
  end 
end //always

endmodule