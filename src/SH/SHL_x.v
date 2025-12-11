// shl不同位数的模块 统一存放

// 32bit 一位左移(即向高位移动一位，补零)
module SHL_1(
    input wire [31:0] in,
    output wire [31:0] out
  );

  wire zero;
  xor(zero,in[0],in[0]);//产生0

  and u_and_0(out[0],zero, zero);

  genvar i;
  generate
    for (i = 1; i < 32; i = i + 1)
    begin : and_bit
      buf u_buf (out[i], in[i-1]);
    end
  endgenerate

endmodule

// 32bit 左移两位
module SHL_2(
    input wire [31:0] in,
    output wire [31:0] out
  );

  wire zero;
  xor(zero,in[0],in[0]);//产生0

  and u_and_0(out[0],zero, zero);
  and u_and_1(out[1],zero, zero);

  genvar i;
  generate
    for (i = 2; i < 32; i = i + 1)
    begin : and_bit
      buf u_buf (out[i], in[i-2]);
    end
  endgenerate

endmodule

// 32bit 左移四位
module SHL_4(
    input wire [31:0] in,
    output wire [31:0] out
  );

  wire zero;
  xor(zero,in[0],in[0]);//产生0

  genvar i;
  generate//低位补0
    for (i = 0; i < 4; i = i + 1)
    begin : and_0_bit
      and u_and (out[i], zero, zero);  // outputs 0
    end
  endgenerate

  generate//高位
    for (i = 4; i < 32; i = i + 1)
    begin : and_bit
      buf u_buf (out[i], in[i-4]);
    end
  endgenerate

endmodule

// 32bit 左移八位
module SHL_8(
    input wire [31:0] in,
    output wire [31:0] out
  );

  wire zero;
  xor(zero,in[0],in[0]);//产生0

  genvar i;
  generate//低位补0
    for (i = 0; i < 8; i = i + 1)
    begin : and_0_bit
      and u_and (out[i],zero, zero);  // outputs 0
    end
  endgenerate

  generate//高位
    for (i = 8; i < 32; i = i + 1)
    begin : and_bit
      buf u_buf (out[i], in[i-8]);
    end
  endgenerate

endmodule

// 32bit 左移十六位
module SHL_16(
    input wire [31:0] in,
    output wire [31:0] out
  );

  wire zero;
  xor(zero,in[0],in[0]);//产生0

  genvar i;
  // out[31:16] = in[15:0]
  generate
    for (i = 0; i < 16; i = i + 1)
    begin : high_bits
      buf b (out[31 - i], in[15 - i]);
    end
  endgenerate

  // out[15:0] = 0
  generate
    for (i = 0; i < 16; i = i + 1)
    begin : low_bits
      and a (out[i], zero, zero);  // outputs 0
    end
  endgenerate

endmodule
