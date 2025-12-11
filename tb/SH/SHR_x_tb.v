
module SHR_x_tb;

  // Parameters

  //Ports
  reg [31:0] in;
  wire [31:0] out;

  SHR_16  SHR_x_inst (
           .in(in),
           .out(out)
         );

  initial
  begin
    in<=32'hFFFFFFFF;
    #10;

    in<=32'h0000FFFF;
    #10;

    $finish;
  end

  initial
  begin
    $dumpfile("shR.vcd"); // 生成vcd文件，记录仿真信息
    $dumpvars(0,SHR_x_inst); // 指定记录层数，记录信号
  end

endmodule
