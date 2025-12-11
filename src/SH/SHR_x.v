// shR不同位数的模块 统一存放

// 32bit 一位右移(即向高位移动一位，补零)
module SHR_1(
    input wire [31:0] in,
    output wire [31:0] out
  );

  wire zero;
  xor(zero,in[0],in[0]);//产生0

  buf u_buf_0(out[31],zero);

  genvar i;
  generate
    for (i = 0; i < 31; i = i + 1)
    begin : buf_bit
      buf u_buf (out[i], in[i+1]);
    end
  endgenerate

endmodule

// 32bit 右移两位
module SHR_2(
    input wire [31:0] in,
    output wire [31:0] out
  );

  wire zero;
  xor(zero,in[0],in[0]);//产生0

  buf u_buf_0(out[31],zero);
  buf u_buf_1(out[30],zero);

  genvar i;
  generate
    for (i = 0; i < 30; i = i + 1)
    begin : buf_bit
      buf u_buf (out[i], in[i+2]);
    end
  endgenerate

endmodule

// 32bit 右移四位
module SHR_4(
    input wire [31:0] in,
    output wire [31:0] out
  );

  wire zero;
  xor(zero,in[0],in[0]);//产生0

  genvar i;
  generate//高位补0
    for (i = 0; i < 4; i = i + 1)
    begin : buf_0_bit
      buf u_buf (out[31-i],zero);  
    end
  endgenerate

  generate//低位
    for (i = 0; i < 32-4; i = i + 1)
    begin : buf_bit
      buf u_buf (out[i], in[i+4]);
    end
  endgenerate

endmodule

// 32bit 右移八位
module SHR_8(
    input wire [31:0] in,
    output wire [31:0] out
  );

  wire zero;
  xor(zero,in[0],in[0]);//产生0

  genvar i;
  generate//高位补0
    for (i = 0; i < 8; i = i + 1)
    begin : buf_0_bit
      buf u_buf (out[31-i],zero);  
    end
  endgenerate

  generate//低位
    for (i = 0; i < 32-8; i = i + 1)
    begin : buf_bit
      buf u_buf (out[i], in[i+8]);
    end
  endgenerate

endmodule

// 32bit 右移十六位
module SHR_16(
    input wire [31:0] in,
    output wire [31:0] out
  );

  wire zero;
  xor(zero,in[0],in[0]);//产生0

  genvar i;
  generate//高位补0
    for (i = 0; i < 16; i = i + 1)
    begin : buf_0_bit
      buf u_buf (out[31-i],zero);  
    end
  endgenerate

  generate//低位
    for (i = 0; i < 32-16; i = i + 1)
    begin : buf_bit
      buf u_buf (out[i], in[i+16]);
    end
  endgenerate

endmodule
