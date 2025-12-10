module ADD_4(
    input wire cin,
    input wire [3:0] a,
    input wire [3:0] b,
    output wire [3:0] res,
    output wire cout
  );

  wire [3:0] G;
  wire [3:0] P;
  wire [2:0] C;

  genvar i;

  generate
    for (i = 0; i < 4; i = i + 1)
    begin : add_bit
      and u_g_and(G[i],a[i],b[i]);
      or u_p_or(P[i],a[i],b[i]);
    end
  endgenerate

  // 采用RTL设计，注意现在没有C[3]
  //   assign C[0]=G[0] | P[0] & cin;
  //   assign C[1]=G[1] | P[1] & G[0] | P[0] & P[1] & cin;
  //   assign C[2]=G[2] | P[2] & G[1] | P[1] & P[2] & G[0] | P[0] & P[1] & P[2] & cin;
  //   assign C[3]=G[3] | P[3] & G[2] | P[3] & P[2] & G[1] | P[3] & P[1] & P[2] & G[0] | P[3] & P[0] & P[1] & P[2] & cin;
  //   assign cout=C[3];
  //   assign res[0]=a[0] ^ b[0] ^ cin;
  //   assign res[1]=a[1] ^ b[1] ^ C[0];
  //   assign res[2]=a[2] ^ b[2] ^ C[1];
  //   assign res[3]=a[3] ^ b[3] ^ C[2];

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

  // 产生C
  or u_or_c0(C[0],G[0],PxCIN[0]);
  or u_or_c1(C[1],G[1],PxG0[0],PxCIN[1]);
  or u_or_c2(C[2],G[2],PxG1[0],PxG0[1],PxCIN[2]);
  or u_or_c3(cout,G[3],P3G2,PxG1[1],PxG0[2],PxCIN[3]);

  // 产生res
  xor u_xor_r0(res[0],a[0],b[0],cin);
  xor u_xor_r1(res[1],a[1],b[1],C[0]);
  xor u_xor_r2(res[2],a[2],b[2],C[1]);
  xor u_xor_r3(res[3],a[3],b[3],C[2]);

endmodule
