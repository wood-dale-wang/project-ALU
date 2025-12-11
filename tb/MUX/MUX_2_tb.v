
module MUX_2_32bit_tb;

  // Parameters

  //Ports
  reg  ch;
  reg  [31:0] ina;
  reg [31:0] inb;
  wire [31:0] out;

  MUX_2_32bit  MUX_2_32bit_inst (
                 .ch(ch),
                 .ina(ina),
                 .inb(inb),
                 .out(out)
               );
  initial
  begin
    ch<=0;
    ina<=31;
    inb<=1;
    #10;

    ina<=1;
    inb<=31;
    #10;

    ch<=1;
    ina<=55;
    inb<=1;
    #10;

    ina<=1;
    inb<=55;
    #10;

    $finish;
  end

  initial
  begin
    $dumpfile("mux.vcd"); // 生成vcd文件，记录仿真信息
    $dumpvars(0,MUX_2_32bit_inst); // 指定记录层数，记录信号
  end

endmodule
