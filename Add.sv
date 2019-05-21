// File Add,  ADD operation
// Jesus Abraham Lizarraga Banuelos
// Apr-17-2018
// Add.sv
//

timeunit 1ns;
timeprecision 100ps;

module Add
#(
    parameter BIT_WIDTH=32,
    parameter BIT_SEL=3
)
(
 output logic [BIT_WIDTH-1:0] AddResult,
 input logic  [BIT_WIDTH-1:0] SrcA, SrcB
);

always_comb
begin
  AddResult=SrcA+SrcB;
end

endmodule
