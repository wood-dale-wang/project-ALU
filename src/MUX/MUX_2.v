
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
  AND_1_32 u_and_ao(.out(ao),.a(nch),.b(ina));

  wire [31:0] bo;
  AND_1_32 u_and_bo(.out(bo),.a(ch),.b(inb));

  OR_32 u_or_out(.a(ao),.b(bo),.out(out));

endmodule
