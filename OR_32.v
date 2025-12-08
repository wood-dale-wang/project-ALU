module OR_32(
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] out
  );

  genvar i;

  generate
    for (i = 0; i < 32; i = i + 1)
    begin : or_bit
      or u_or (out[i], a[i], b[i]);  // 可用位置连接，避免端口名歧义
    end
  endgenerate

endmodule
