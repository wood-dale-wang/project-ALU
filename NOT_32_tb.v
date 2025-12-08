
module NOT_32_tb;

  // Parameters

  //Ports
  reg [31:0] in;
  wire [31:0] out;

  NOT_32  NOT_32_inst (
            .in(in),
            .out(out)
          );

  initial
  begin
    in<=32'hFFFFFFFF;
    #10;

    in<=32'h00000000;
    #10;

    in<=32'haaaaaaaa;
    #10;

    $finish;
  end

  initial
  begin
    $dumpfile("tmp.vcd"); // 生成vcd文件，记录仿真信息
    $dumpvars(0,NOT_32_tb); // 指定记录层数，记录信号
  end

endmodule
