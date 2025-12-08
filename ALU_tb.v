`timescale 1ns / 1ps

module ALU_tb;

    reg  [2:0]  opcode;
    reg  [31:0] a, b;
    reg         cin;
    wire [31:0] result;
    wire        cout;

    // 实例化 DUT
    alu_32bit_unsigned uut (
        .opcode(opcode),
        .a(a),
        .b(b),
        .cin(cin),
        .result(result),
        .cout(cout)
    );

    // 定义操作码常量（可读性更好）
    localparam NOT = 3'b000;
    localparam AND = 3'b001;
    localparam OR  = 3'b010;
    localparam XOR = 3'b011;
    localparam SHL = 3'b100;
    localparam SHR = 3'b101;
    localparam CUT = 3'b110;
    localparam ADD = 3'b111;

    // 测试任务：简化调用
    task run_test(input [2:0] op, input [31:0] in_a, input [31:0] in_b, input in_cin);
        begin
            opcode <= op;
            a <= in_a;
            b <= in_b;
            cin <= in_cin;
            #10; // 等待组合逻辑稳定
            $display("OP=%s | A=0x%08h | B=0x%08h | Cin=%b | Result=0x%08h | Cout=%b",
                op_name(op), a, b, cin, result, cout);
        end
    endtask

    // 辅助函数：操作码转字符串
    function [6:0] op_name(input [2:0] op);
        case (op)
            NOT: op_name = "NOT";
            AND: op_name = "AND";
            OR:  op_name = "OR ";
            XOR: op_name = "XOR";
            SHL: op_name = "SHL";
            SHR: op_name = "SHR";
            CUT: op_name = "CUT";
            ADD: op_name = "ADD";
            default: op_name = "???";
        endcase
    endfunction

    initial begin
        $display("Starting ALU Testbench...\n");

        // ------------------ NOT ------------------
        $display("--- Testing NOT ---");
        run_test(NOT, 32'h12345678, 32'd0, 1'b0);

        // ------------------ AND ------------------
        $display("\n--- Testing AND ---");
        run_test(AND, 32'hFFFFFFFF, 32'h0000FFFF, 1'b0);

        // ------------------ OR ------------------
        $display("\n--- Testing OR ---");
        run_test(OR, 32'hFF000000, 32'h0000FFFF, 1'b0);

        // ------------------ XOR ------------------
        $display("\n--- Testing XOR ---");
        run_test(XOR, 32'hAAAAAAAA, 32'h55555555, 1'b0);

        // ------------------ SHL ------------------
        $display("\n--- Testing SHL ---");
        run_test(SHL, 32'h00000001, 5, 1'b0);      // 1 << 5 = 32
        run_test(SHL, 32'h80000000, 1, 1'b0);      // overflow → 0

        // ------------------ SHR ------------------
        $display("\n--- Testing SHR ---");
        run_test(SHR, 32'h80000000, 4, 1'b0);      // 0x08000000
        run_test(SHR, 32'h00000001, 1, 1'b0);      // 0

        // ------------------ CUT (保留低 n 位) ------------------
        $display("\n--- Testing CUT (keep low n bits) ---");
        run_test(CUT, 32'h12345678, 8, 1'b0);      // expect 0x78
        run_test(CUT, 32'hFFFFFFFF, 10, 1'b0);     // expect 0xFFFF
        run_test(CUT, 32'hABCDEF00, 0, 1'b0);      // expect 0
        run_test(CUT, 32'h12345678, 32, 1'b0);     // n=32 → full (but b[4:0]=31 max, so use 31 to test near-full)
        run_test(CUT, 32'h92345678, 31, 1'b0);     // keep low 31 bits → clear MSB

        // ------------------ ADD with carry ------------------
        $display("\n--- Testing ADD with carry ---");
        run_test(ADD, 32'h00000001, 32'h00000002, 1'b0);   // 3
        run_test(ADD, 32'hFFFFFFFF, 32'd1, 1'b0);           // 0, cout=1
        run_test(ADD, 32'hFFFFFFFF, 32'd0, 1'b1);           // 0, cout=1
        run_test(ADD, 32'h7FFFFFFF, 32'h7FFFFFFF, 1'b1);    // 0xFFFFFFFF, cout=0? Let's check: 0x7FFFFFFF*2+1 = 0xFFFFFFFD +1 = 0xFFFFFFFE? Wait:
        // Actually: 0x7FFFFFFF + 0x7FFFFFFF = 0xFFFFFFFE, +cin=1 → 0xFFFFFFFF, no carry out (since < 2^32)
        // So cout=0

        $display("\nTestbench finished.");
        $finish;
    end

endmodule