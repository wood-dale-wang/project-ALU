module alu_32bit_unsigned (
    input  wire [2:0]  opcode,      // 操作码
    input  wire [31:0] a,           // 操作数1
    input  wire [31:0] b,           // 操作数2（移位/截断数量取低5位）
    input  wire        cin,         // 进位输入（仅ADD使用）
    output wire [31:0] result,      // 运算结果
    output wire        cout         // 进位输出（仅ADD有效）
  );

  wire [5:0] n = b[5:0];  // 截断/移位位数（0~31+32）

  reg [31:0] res;
  reg        co;

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

  always @(*)
  begin
    co = 1'b0;
    case (opcode)
      3'b000:
        res = not_out;                     // NOT
      3'b001:
        res = and_out;                      // AND
      3'b010:
        res = or_out;                        // OR
      3'b011:
        res = xor_out;                        // XOR
      3'b100:
        res = shl_out;                    // SHL
      3'b101:
        res = shr_out;                      // SHR
      3'b110:
        res = cut_out;                   // CUT: 保留低 n 位
      3'b111:
      begin                               // ADD with carry
        res <= add_out;
        co <= cout_tmp;
      end
      default:
      begin
        res = 32'd0;
        co = 1'b0;
      end
    endcase
  end

  assign result = res;
  assign cout  = (opcode == 3'b111) ? co : 1'b0;

endmodule
