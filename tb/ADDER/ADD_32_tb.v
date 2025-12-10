
module ADD_32_tb;

  // Parameters

  //Ports
  reg  cin;
  reg [31:0] a;
  reg [31:0] b;
  wire [31:0] res;
  wire  cout;

  ADD_32  ADD_32_inst (
            .cin(cin),
            .a(a),
            .b(b),
            .res(res),
            .cout(cout)
          );

  initial
  begin
    a<=32'hAAAAAAAA;
    b<=32'h55555555;
    cin<=0;
    #10;

    a<=32'hAAAAAAAA;
    b<=32'h55555555;
    cin<=1;
    #10;

    a<=3;
    b<=2;
    cin<=1;
    #10;

    $finish;
  end

  initial
  begin
    $dumpfile("add.vcd"); // 生成vcd文件，记录仿真信息
    $dumpvars(0,ADD_32_tb); // 指定记录层数，记录信号
  end

endmodule
