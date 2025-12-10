= 32位超前进位加法器

== 超前进位加法器原理

对于一般的行波进位加法器中的每一个组件（全加器），我们有：

$cases(
  S_i=A plus.o B plus.o C_i,
  C_(i+1)=A_i circle.filled.tiny B_i + A_i circle.filled.tiny C_i + B_i circle.filled.tiny C_i
)$

令~$G_i=A_i circle.filled.tiny B_i, P_i=A_i+B_i$，则~$C_(i+1)=G_i+P_i circle.filled.tiny C_i$~。

可见，进位中的~$G_i$~和~$P_i$~不依赖前面的数据，仅依赖本位数据，于是，我们可以将行波进位加法器改为：

$cases(
  C_1&=G_0+P_0 circle.filled.tiny C_("in"),
  C_2&=G_1+P_1 circle.filled.tiny C_1, &=G_1+P_1 circle.filled.tiny G_0 + P_0 circle.filled.tiny P_1 circle.filled.tiny C_("in"),
  C_3&=G_2+P_2 circle.filled.tiny C_2,
  &=G_2+P_2 circle.filled.tiny G_1 + P_1 circle.filled.tiny P_2 circle.filled.tiny G_0+P_0 circle.filled.tiny P_1 circle.filled.tiny P_2 circle.filled.tiny C_("in"),
  C_4&=G_3+P_3 circle.filled.tiny C_3,
  &=G_3+P_3 circle.filled.tiny G_2+P_2 circle.filled.tiny P_3 circle.filled.tiny G_1+P_1 circle.filled.tiny P_2 circle.filled.tiny P_3 circle.filled.tiny G_0+P_0 circle.filled.tiny P_1 circle.filled.tiny P_2 circle.filled.tiny P_3 circle.filled.tiny C_("in"),
  C_("out")&=C_4
)$

可见，这个四位行波进位加法器其实不需要一个一个计算，每一个进位实际上都可以直接通过输入数据进行计算。

又由于$S_i=A plus.o B plus.o C_i$，我们可以构建一个四位超前进位加法器，见`ADD_4.v`。

== 扩展化-32位超前进位加法器

由上面的分析，可见其表达式是有规律的，我们可以尝试直接构建32位超前进位加法器，见`ADD_32.v`。

其中，python脚本`generate.py`是用于简化重复书写的代码生成器。

== 模块化

可以发现，计算本位结果的计算式和计算各位$G_i$和$P_i$式子固定，就是$S_i=A plus.o B plus.o C_i$和$G_i=A_i circle.filled.tiny B_i, P_i=A_i+B_i$，这部分可以按位进行模块化；但是计算进位的计算式会随着位的改变而改变（增加），这部分就只能按照加法器的规模进行模块化了。

于是，一个超前进位加法器可以由 n 个全加器（带$G_i$和$P_i$输出），和一个进位发生器组成。

例如，一个4位超前进位加法器：

全加器定义：

```Verilog
module add_1bit(
    input wire cin,
    input wire a,
    input wire b,
    output wire S,
    output wire G,
    output wire P
  );
  xor u_xor(S,a,b,cin);
  and u_and(G,a,b);
  or u_or(P,a,b);
endmodule
```

进位生成器：

```Verilog
module CLA_4bit(
    input wire [3:0] G,
    input wire [3:0] P,
    input wire cin,
    output wire [2:0] CI,
    output wire cout
  );
  // 产生cin相关位
  wire [3:0] PxCIN;
  and u_and_p0cin(PxCIN[0],P[0],cin);
  and u_and_p1cin(PxCIN[1],P[1],P[0],cin);
  and u_and_p2cin(PxCIN[2],P[2],P[1],P[0],cin);
  and u_and_p3cin(PxCIN[3],P[3],P[2],P[1],P[0],cin);

  // 产生G0相关位
  wire [2:0] PxG0;
  and u_and_p1g0(PxG0[0],P[1],G[0]);
  and u_and_p2g0(PxG0[1],P[2],P[1],G[0]);
  and u_and_p3g0(PxG0[2],P[3],P[2],P[1],G[0]);

  // 产生G1相关位
  wire [1:0] PxG1;
  and u_and_p2g1(PxG1[0],P[2],G[1]);
  and u_and_p3g1(PxG1[1],P[3],P[2],G[1]);

  // 产生P3G2
  wire P3G2;
  and u_and_p3g2(P3G2,P[3],G[2]);

  // 产生进位
  or u_or_c0(CI[0],G[0],PxCIN[0]);
  or u_or_c1(CI[1],G[1],PxG0[0],PxCIN[1]);
  or u_or_c2(CI[2],G[2],PxG1[0],PxG0[1],PxCIN[2]);
  or u_or_c3(cout,G[3],P3G2,PxG1[1],PxG0[2],PxCIN[3]);
endmodule
```

这样就可以组一个4位超前进位加法器了，顶级模块如下：

```Verilog
module ADD_4bit(
  input wire [3:0] a,
  input wire [3:0] b,
  input wire cin,
  output wire [3:0] res,
  output wire cout
  );

  wire [3:0] G;
  wire [3:0] P;
  wire [2:0] C;

  add_1bit a0(
    .cin(cin),
    .a(a[0]),
    .b(b[0]),
    .S(res[0]),
    .G(G[0]),
    .P(P[0])
  );

  add_1bit a1(
    .cin(C[0]),
    .a(a[1]),
    .b(b[1]),
    .S(res[1]),
    .G(G[1]),
    .P(P[1])
  );

  add_1bit a2(
    .cin(C[1]),
    .a(a[2]),
    .b(b[2]),
    .S(res[2]),
    .G(G[2]),
    .P(P[2])
  );

  add_1bit a3(
    .cin(C[2]),
    .a(a[3]),
    .b(b[3]),
    .S(res[3]),
    .G(G[3]),
    .P(P[3])
  );

  CLA_4bit cla(
    .G(G),
    .P(P),
    .cin(cin),
    .CI(C),
    .cout(cout)
  );

endmodule
```

其中，值得注意的是作为全加器的输入的进位线组C最初是没有初始化的，而要依赖依赖其输出的cla组件进行CI的计算，这看似循环依赖，但是仔细观察，cla组件需要的G和P数据不依赖进位数据，而只有结果是依赖进位的，所以并没有循环依赖。
