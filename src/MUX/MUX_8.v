module MUX_8_32bit(
    input wire [2:0] ch,
    input wire [31:0] in0,
    input wire [31:0] in1,
    input wire [31:0] in2,
    input wire [31:0] in3,
    input wire [31:0] in4,
    input wire [31:0] in5,
    input wire [31:0] in6,
    input wire [31:0] in7,
    output wire [31:0] out
  );

  wire [2:0] nch;//ch的反
  not u_not0(nch[0],ch[0]);
  not u_not1(nch[1],ch[1]);
  not u_not2(nch[2],ch[2]);

  // 解码器部分，按照真值表展开
  wire [7:0] chline;
  and u_and0(chline[0],nch[2],nch[1],nch[0]);//000
  and u_and1(chline[1],nch[2],nch[1],ch[0]);//001
  and u_and2(chline[2],nch[2],ch[1],nch[0]);//010
  and u_and3(chline[3],nch[2],ch[1],ch[0]);//011
  and u_and4(chline[4],ch[2],nch[1],nch[0]);//100
  and u_and5(chline[5],ch[2],nch[1],ch[0]);//101
  and u_and6(chline[6],ch[2],ch[1],nch[0]);//110
  and u_and7(chline[7],ch[2],ch[1],ch[0]);//111

  // 抑制
  wire [31:0] out0;
  AND_1_32 u_and320(.out(out0),.a(chline[0]),.b(in0));
  wire [31:0] out1;
  AND_1_32 u_and321(.out(out1),.a(chline[1]),.b(in1));
  wire [31:0] out2;
  AND_1_32 u_and322(.out(out2),.a(chline[2]),.b(in2));
  wire [31:0] out3;
  AND_1_32 u_and323(.out(out3),.a(chline[3]),.b(in3));
  wire [31:0] out4;
  AND_1_32 u_and324(.out(out4),.a(chline[4]),.b(in4));
  wire [31:0] out5;
  AND_1_32 u_and325(.out(out5),.a(chline[5]),.b(in5));
  wire [31:0] out6;
  AND_1_32 u_and326(.out(out6),.a(chline[6]),.b(in6));
  wire [31:0] out7;
  AND_1_32 u_and327(.out(out7),.a(chline[7]),.b(in7));

  genvar i;
  generate
    for (i = 0; i < 32; i = i + 1)
    begin : or_bit  //按位写入
      or u_or (out[i], out0[i], out1[i], out2[i], out3[i], out4[i], out5[i], out6[i], out7[i]);
    end
  endgenerate

endmodule
