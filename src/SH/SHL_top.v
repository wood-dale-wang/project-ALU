//左移的顶级模块
module SHL_top(
    input wire [5:0] n,//实际上是0-32,32是用来完全移除的
    input wire [31:0] in,
    output wire [31:0] out
  );

  // 1
  wire [31:0] shl_1_out;
  SHL_1 u_shl_1(
          .in(in),
          .out(shl_1_out)
        );
  wire [31:0] level_1_out;
  MUX_2_32bit u_mux_l_1(
                .ch(n[0]),
                .ina(in),
                .inb(shl_1_out),
                .out(level_1_out)
              );

  //2
  wire [31:0] shl_2_out;
  SHL_2 u_shl_2(
          .in(level_1_out),
          .out(shl_2_out)
        );
  wire [31:0] level_2_out;
  MUX_2_32bit u_mux_l_2(
                .ch(n[1]),
                .ina(level_1_out),
                .inb(shl_2_out),
                .out(level_2_out)
              );

  //4
  wire [31:0] shl_4_out;
  SHL_4 u_shl_4(
          .in(level_2_out),
          .out(shl_4_out)
        );
  wire [31:0] level_4_out;
  MUX_2_32bit u_mux_l_4(
                .ch(n[2]),
                .ina(level_2_out),
                .inb(shl_4_out),
                .out(level_4_out)
              );
  //8
  wire [31:0] shl_8_out;
  SHL_8 u_shl_8(
          .in(level_4_out),
          .out(shl_8_out)
        );
  wire [31:0] level_8_out;
  MUX_2_32bit u_mux_l_8(
                .ch(n[3]),
                .ina(level_4_out),
                .inb(shl_8_out),
                .out(level_8_out)
              );
  //16
  wire [31:0] shl_16_out;
  SHL_16 u_shl_16(
           .in(level_8_out),
           .out(shl_16_out)
         );
  wire [31:0] level_16_out;
  MUX_2_32bit u_mux_l_16(
                .ch(n[4]),
                .ina(level_8_out),
                .inb(shl_16_out),
                .out(level_16_out)
              );
  //32
  wire [31:0] shl_32_out;
  genvar k;
  generate
    for (k = 0; k < 32; k = k + 1)
    begin : zero32
      xor u_xor (shl_32_out[k], n[0], n[0]);//产生0
    end
  endgenerate
  MUX_2_32bit u_mux_l_32(
                .ch(n[5]),
                .ina(level_16_out),
                .inb(shl_32_out),
                .out(out)
              );
endmodule
