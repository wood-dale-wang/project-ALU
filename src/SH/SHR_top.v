//右移的顶级模块
module SHR_top(
    input wire [5:0] n,//实际上是0-32,32是用来完全移除的
    input wire [31:0] in,
    output wire [31:0] out
  );

  // 1
  wire [31:0] SHR_1_out;
  SHR_1 u_SHR_1(
          .in(in),
          .out(SHR_1_out)
        );
  wire [31:0] level_1_out;
  MUX_2_32bit u_mux_l_1(
                .ch(n[0]),
                .ina(in),
                .inb(SHR_1_out),
                .out(level_1_out)
              );

  //2
  wire [31:0] SHR_2_out;
  SHR_2 u_SHR_2(
          .in(level_1_out),
          .out(SHR_2_out)
        );
  wire [31:0] level_2_out;
  MUX_2_32bit u_mux_l_2(
                .ch(n[1]),
                .ina(level_1_out),
                .inb(SHR_2_out),
                .out(level_2_out)
              );

  //4
  wire [31:0] SHR_4_out;
  SHR_4 u_SHR_4(
          .in(level_2_out),
          .out(SHR_4_out)
        );
  wire [31:0] level_4_out;
  MUX_2_32bit u_mux_l_4(
                .ch(n[2]),
                .ina(level_2_out),
                .inb(SHR_4_out),
                .out(level_4_out)
              );
  //8
  wire [31:0] SHR_8_out;
  SHR_8 u_SHR_8(
          .in(level_4_out),
          .out(SHR_8_out)
        );
  wire [31:0] level_8_out;
  MUX_2_32bit u_mux_l_8(
                .ch(n[3]),
                .ina(level_4_out),
                .inb(SHR_8_out),
                .out(level_8_out)
              );
  //16
  wire [31:0] SHR_16_out;
  SHR_16 u_SHR_16(
           .in(level_8_out),
           .out(SHR_16_out)
         );
  wire [31:0] level_16_out;
  MUX_2_32bit u_mux_l_16(
                .ch(n[4]),
                .ina(level_8_out),
                .inb(SHR_16_out),
                .out(level_16_out)
              );
  //32
  wire [31:0] SHR_32_out;
  genvar k;
  generate
    for (k = 0; k < 32; k = k + 1)
    begin : zero32
      xor u_xor (SHR_32_out[k], n[0], n[0]);//产生0
    end
  endgenerate
  MUX_2_32bit u_mux_l_32(
                .ch(n[5]),
                .ina(level_16_out),
                .inb(SHR_32_out),
                .out(out)
              );
endmodule
