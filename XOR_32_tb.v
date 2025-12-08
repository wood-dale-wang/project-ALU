
module XOR_32_tb;

  // Parameters

  //Ports
  reg [31:0] a;
  reg [31:0] b;
  wire [31:0] out;

  XOR_32  XOR_32_inst (
           .a(a),
           .b(b),
           .out(out)
         );

  initial
  begin
    a<=32'hFFFFFFFF;
    b<=32'h0000FFFF;
    #10;

    a<=32'h0000FFFF;
    b<=32'hFFFF0000;
    #10;

    a<=3;
    b<=2;
    #10;

    $finish;
  end

  initial
  begin
    $dumpfile("xor.vcd"); // 生成vcd文件，记录仿真信息
    $dumpvars(0,XOR_32_tb); // 指定记录层数，记录信号
  end

endmodule
