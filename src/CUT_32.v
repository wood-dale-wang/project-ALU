module CUT_32(
    input wire [5:0] n,
    input wire [31:0] in,
    output wire [31:0] out
  );

  wire tmp_nn;
  not u_not_nn(tmp_nn,n[0]);

  wire [31:0] one;
  genvar i;
  generate
    for (i = 0; i < 32 ; i = i + 1 )
    begin : write_one
      or u_or(one[i],n[0],tmp_nn);
    end
  endgenerate

  wire [31:0] shl_out;
  SHL_top u_shl(
            .n(n),
            .in(one),
            .out(shl_out)
          );

  wire [31:0] mask;

  generate
    for (i = 0; i < 32 ; i = i + 1 )
    begin : not_n
      not u_not(mask[i],shl_out[i]);
      and u_and(out[i],in[i],mask[i]);
    end
  endgenerate

endmodule
