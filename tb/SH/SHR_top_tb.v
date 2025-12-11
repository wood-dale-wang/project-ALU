`timescale 1ns / 1ps
module SHR_top_tb;
  //Ports
  reg [5:0] n;
  reg [31:0] in;
  wire [31:0] out;

  SHR_top  SHR_top_inst (
             .n(n),
             .in(in),
             .out(out)
           );

  initial
  begin
    n<=0;
    in<=32'hFFFFFFFF;
    #10;

    n<=1;
    #10;

    n<=2;
    #10;

    n<=3;
    #10;

    n<=4;
    #10;

    n<=15;
    #10;

    n<=25;
    #10;

    n<=30;
    #10;

    n<=31;
    #10;

    n<=32;
    #10;

    $finish;
  end

  initial
  begin
    $dumpfile("SHR.vcd"); // 生成vcd文件，记录仿真信息
    $dumpvars(0,SHR_top_inst); // 指定记录层数，记录信号
  end

endmodule
