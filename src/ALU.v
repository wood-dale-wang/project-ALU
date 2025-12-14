module alu_32bit_unsigned (
    input  wire [2:0]  opcode,      // 操作码
    input  wire [31:0] a,           // 操作数1
    input  wire [31:0] b,           // 操作数2（移位/截断数量取低5位）
    input  wire        cin,         // 进位输入（仅ADD使用）
    output wire [31:0] result,      // 运算结果
    output wire        cout         // 进位输出（仅ADD有效）
  );

  wire [5:0] n;  // 截断/移位位数（0~31+32）
  genvar i;
  generate
    for (i = 0; i < 6; i = i + 1)
    begin : get_n
      buf u_buf(n[i], b[i]);
    end
  endgenerate

  //NOT组件
  wire [31:0] not_out;
  NOT_32  NOT_32_inst (
            .in(a),
            .out(not_out)
          );

  // AND组件
  wire [31:0] and_out;
  AND_32  AND_32_inst(
            .a(a),
            .b(b),
            .out(and_out)
          );

  // OR组件
  wire [31:0] or_out;
  OR_32  OR_32_inst(
           .a(a),
           .b(b),
           .out(or_out)
         );

  // XOR组件
  wire [31:0] xor_out;
  XOR_32  XOR_32_inst(
            .a(a),
            .b(b),
            .out(xor_out)
          );

  // SHL
  wire [31:0] shl_out;
  SHL_top  SHL_top_inst (
             .n(n),
             .in(a),
             .out(shl_out)
           );

  // SHR
  wire [31:0] shr_out;
  SHR_top  SHR_top_inst (
             .n(n),
             .in(a),
             .out(shr_out)
           );

  // CUT
  wire [31:0] cut_out;
  CUT_32  CUT_32_inst (
            .n(n),
            .in(a),
            .out(cut_out)
          );

  // 32位超前进位加法器
  wire [31:0] add_out;
  wire cout_tmp;
  ADD_32  ADD_32_inst (
            .cin(cin),
            .a(a),
            .b(b),
            .res(add_out),
            .cout(cout_tmp)
          );

  MUX_8_32bit  MUX_8_32bit_inst (
                 .ch(opcode),
                 .in0(not_out),// NOT
                 .in1(and_out),// AND
                 .in2(or_out),// OR
                 .in3(xor_out),// XOR
                 .in4(shl_out),// SHL
                 .in5(shr_out),// SHR
                 .in6(cut_out),// CUT: 保留低 n 位
                 .in7(add_out),// ADD
                 .out(result)
               );

    wire tmp_have_cout;// 只有opcode==7的时候才放行cout
    and u_and_have_cout(tmp_have_cout,opcode[0],opcode[1],opcode[2]);
    and u_and_cout(cout,cout_tmp,tmp_have_cout);

endmodule
