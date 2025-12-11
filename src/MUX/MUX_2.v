
// 32bit 二选一 选择器
module MUX_2_32bit(
    input wire ch,//选择
    input wire [31:0] ina,
    input wire [31:0] inb,
    output wire [31:0] out
  );

  wire nch;
  not u_not(nch,ch);


  wire [31:0] ao;
  genvar i;
  generate
    for (i = 0; i < 32; i = i + 1)
    begin : and_ao_bit
      and u_and_a(ao[i],nch,ina[i]);
    end
  endgenerate

  wire [31:0] bo;
  genvar j;
  generate
    for (j = 0; j < 32; j = j + 1)
    begin : and_bo_bit
      and u_and_a(bo[j],ch,inb[j]);
    end
  endgenerate

  genvar k;
  generate
    for (k = 0; k < 32; k = k + 1)
    begin : or_out_bit
      or u_or_out(out[k],ao[k],bo[k]);
    end
  endgenerate

endmodule
