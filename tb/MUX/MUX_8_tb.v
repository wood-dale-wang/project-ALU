
module MUX_8_32bit_tb;

  // Parameters

  //Ports
  reg [2:0] ch;
  reg [31:0] in0;
  reg [31:0] in1;
  reg [31:0] in2;
  reg [31:0] in3;
  reg [31:0] in4;
  reg [31:0] in5;
  reg [31:0] in6;
  reg [31:0] in7;
  wire [31:0] out;

  MUX_8_32bit  MUX_8_32bit_inst (
                 .ch(ch),
                 .in0(in0),
                 .in1(in1),
                 .in2(in2),
                 .in3(in3),
                 .in4(in4),
                 .in5(in5),
                 .in6(in6),
                 .in7(in7),
                 .out(out)
               );

  initial
  begin
    ch<=0;
    in0<=1;
    in1<=2;
    in2<=3;
    in3<=4;
    in4<=5;
    in5<=6;
    in6<=7;
    in7<=8;
    #10;

    ch<=1;#10;
    ch<=2;#10;
    ch<=3;#10;
    ch<=4;#10;
    ch<=5;#10;
    ch<=6;#10;
    ch<=7;#10;
    ch<=8;#10;

    $finish;
  end

  initial
  begin
    $dumpfile("mux8.vcd"); // 生成vcd文件，记录仿真信息
    $dumpvars(0,MUX_8_32bit_inst); // 指定记录层数，记录信号
  end

endmodule
