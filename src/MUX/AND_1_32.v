// 1 32 and门，用于MUX_x_32
module AND_1_32(
    input wire a,
    input wire [31:0] b,
    output wire [31:0] out
  );

  genvar i;

  generate
    for (i = 0; i < 32; i = i + 1)
    begin : and_bit
      and u_and (out[i], a, b[i]);
    end
  endgenerate

endmodule
