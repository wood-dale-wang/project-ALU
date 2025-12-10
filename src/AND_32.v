module AND_32(
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] out
  );

  genvar i;

  generate
    for (i = 0; i < 32; i = i + 1)
    begin : and_bit
      and u_and (out[i], a[i], b[i]);  // 可用位置连接，避免端口名歧义
    end
  endgenerate

endmodule
