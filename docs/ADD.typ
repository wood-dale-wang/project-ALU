= 32位超前进位加法器

== 超前进位加法器原理

对于一般的行波进位加法器中的每一个组件（全加器），我们有：

$cases(S_i=A plus.o B plus.o C_i,
C_(i+1)=A_i circle.filled.tiny B_i + A_i circle.filled.tiny C_i + B_i circle.filled.tiny C_i)$

令~$G_i=A_i circle.filled.tiny B_i, P_i=A_i+B_i$，则~$C_(i+1)=G_i+P_i circle.filled.tiny C_i$~。

可见，进位中的~$G_i$~和~$P_i$~不依赖前面的数据，仅依赖本位数据，于是，我们可以将行波进位加法器改为：

$cases(
  C_1&=G_0+P_0 circle.filled.tiny C_("in"),
  C_2&=G_1+P_1 circle.filled.tiny C_1,&=G_1+P_1 circle.filled.tiny G_0 + P_0 circle.filled.tiny P_1 circle.filled.tiny C_("in"),
  C_3&=G_2+P_2 circle.filled.tiny C_2,
  &=G_2+P_2 circle.filled.tiny G_1 + P_1 circle.filled.tiny P_2 circle.filled.tiny G_0+P_0 circle.filled.tiny P_1 circle.filled.tiny P_2 circle.filled.tiny C_("in"),
  C_4&=G_3+P_3 circle.filled.tiny C_3,
  &=G_3+P_3 circle.filled.tiny G_2+P_2 circle.filled.tiny P_3 circle.filled.tiny G_1+P_1 circle.filled.tiny P_2 circle.filled.tiny P_3 circle.filled.tiny G_0+P_0 circle.filled.tiny P_1 circle.filled.tiny P_2 circle.filled.tiny P_3 circle.filled.tiny C_("in"),
  C_("out")&=C_4
)$

可见，这个四位行波进位加法器其实不需要一个一个计算，每一个进位实际上都可以直接通过输入数据进行计算。

又由于$S_i=A plus.o B plus.o C_i$，我们可以构建一个四位超前进位加法器，见`ADD_4.v`