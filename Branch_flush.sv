// Branch_flush.
// File to select 1 output with 4 inputs
// Jesus Abraham Lizarraga Banuelos
// Mar-21-2018
// Branch_flush..sv
//

timeunit 1ns;
timeprecision 100ps;

module Branch_flush
#(
    parameter BIT_WIDTH=32,
    parameter BIT_SEL=2
)
(
 input logic PCEn_in,
 output logic PCEn_out_FLUSH
);

always_comb
begin
 PCEn_out_FLUSH= PCEn_in;
end

endmodule
 
