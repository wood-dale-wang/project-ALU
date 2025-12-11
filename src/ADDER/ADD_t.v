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