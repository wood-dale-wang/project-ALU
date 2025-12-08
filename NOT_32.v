module NOT_32(
    input wire [31:0] in,
    output wire [31:0] out
  );

  genvar i;

  generate
    for (i = 0; i < 32; i = i + 1)
    begin : not_bit
      not u_not (out[i], in[i]);  // 可用位置连接，避免端口名歧义
    end
  endgenerate

endmodule
