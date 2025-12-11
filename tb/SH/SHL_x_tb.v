
module SHL_x_tb;

  // Parameters

  //Ports
  reg [31:0] in;
  wire [31:0] out;

  SHL_8  SHL_x_inst (
           .in(in),
           .out(out)
         );

  initial
  begin
    in<=32'hFFFFFFFF;
    #10;

    in<=32'hFFFFFFFF;
    #10;

    in<=1;
    #10;

    $finish;
  end

  initial
  begin
    $dumpfile("shl.vcd"); // 生成vcd文件，记录仿真信息
    $dumpvars(0,SHL_x_inst); // 指定记录层数，记录信号
  end

endmodule
