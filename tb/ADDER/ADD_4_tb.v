
module ADD_4_tb;

  // Parameters

  //Ports
  reg  cin;
  reg [3:0] a;
  reg [3:0] b;
  wire [3:0] res;
  wire  cout;

  ADD_4  ADD_4_inst (
           .cin(cin),
           .a(a),
           .b(b),
           .res(res),
           .cout(cout)
         );

  initial
  begin
    a<=1;
    b<=2;
    cin<=0;
    #10;

    a<=4'hF;
    b<=1;
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
    $dumpvars(0,ADD_4_tb); // 指定记录层数，记录信号
  end

endmodule
