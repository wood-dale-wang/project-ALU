module ADD_t(
    input wire cin,
    input wire [3:0] a,
    input wire [3:0] b,
    output wire [3:0] res,
    output wire cout
  );

  wire C[2:0];

  assign C[0]=a[0] & b[0] | a[0] & cin | b[0] & cin;
  assign res[0]=a[0] ^ b[0] ^ cin;

  assign C[1]=a[1] & b[1] | a[1] & C[0] | b[1] & C[0];
  assign res[1]=a[1] ^ b[1] ^ C[0];

  assign C[2]=a[2] & b[2] | a[2] & C[1] | b[2] & C[1];
  assign res[2]=a[2] ^ b[2] ^ C[1];

  assign cout=a[3] & b[3] | a[3] & C[2] | b[3] & C[2];
  assign res[3]=a[3] ^ b[3] ^ C[2];

endmodule
