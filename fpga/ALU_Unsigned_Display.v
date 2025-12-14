`timescale 1ns / 1ps

module ALU_Unsigned_Display (
    // 时钟与复位信号
    input        clk,
    input        resetn,          // 低电平有效

    // 拨码开关：选择当前输入项 & cin
    input [1:0]  input_sel,       // 0:A, 1:B, 2:OPCODE, 3:CIN

    // LED：显示 cout
    output       led_cout,

    // 触摸屏接口（无需修改）
    output       lcd_rst,
    output       lcd_cs,
    output       lcd_rs,
    output       lcd_wr,
    output       lcd_rd,
    inout [15:0] lcd_data_io,
    output       lcd_bl_ctr,
    inout        ct_int,
    inout        ct_sda,
    output       ct_scl,
    output       ct_rstn
);

    // ------------------ 内部寄存器 ------------------
    reg [31:0] a_reg;
    reg [31:0] b_reg;
    reg [2:0]  opcode_reg;
    reg        cin_reg;

    wire [31:0] result_wire;
    wire        cout_wire;

    // ------------------ 实例化待测 ALU ------------------
    alu_32bit_unsigned uut_alu (
        .opcode (opcode_reg),
        .a      (a_reg),
        .b      (b_reg),
        .cin    (cin_reg),
        .result (result_wire),
        .cout   (cout_wire)
    );

    // 将 cout 输出到 LED
    assign led_cout = cout_wire;

    // ------------------ 触摸屏模块实例化 ------------------
    reg                display_valid;
    reg [39:0]         display_name;
    reg [31:0]         display_value;
    wire [5:0]         display_number;
    wire               input_valid;
    wire [31:0]        input_value;

    lcd_module lcd_inst (
        .clk           (clk),
        .resetn        (resetn),

        .display_valid (display_valid),
        .display_name  (display_name),
        .display_value (display_value),
        .display_number(display_number),
        .input_valid   (input_valid),
        .input_value   (input_value),

        // LCD/CT 接口（透传）
        .lcd_rst       (lcd_rst),
        .lcd_cs        (lcd_cs),
        .lcd_rs        (lcd_rs),
        .lcd_wr        (lcd_wr),
        .lcd_rd        (lcd_rd),
        .lcd_data_io   (lcd_data_io),
        .lcd_bl_ctr    (lcd_bl_ctr),
        .ct_int        (ct_int),
        .ct_sda        (ct_sda),
        .ct_scl        (ct_scl),
        .ct_rstn       (ct_rstn)
    );

    // ------------------ 从触摸屏获取输入 ------------------
    always @(posedge clk) begin
        if (!resetn) begin
            a_reg <= 32'd0;
        end else if (input_valid && input_sel == 2'b00) begin
            a_reg <= input_value;
        end
    end

    always @(posedge clk) begin
        if (!resetn) begin
            b_reg <= 32'd0;
        end else if (input_valid && input_sel == 2'b01) begin
            b_reg <= input_value;
        end
    end

    always @(posedge clk) begin
        if (!resetn) begin
            opcode_reg <= 3'd0;
        end else if (input_valid && input_sel == 2'b10) begin
            opcode_reg <= input_value[2:0]; // 只取低3位
        end
    end

    always @(posedge clk) begin
        if (!resetn) begin
            cin_reg <= 1'b0;
        end else if (input_valid && input_sel == 2'b11) begin
            cin_reg <= input_value[0]; // 取最低位
        end
    end

    // ------------------ 输出到触摸屏显示 ------------------
    always @(posedge clk) begin
        case (display_number)
            6'd1: begin
                display_valid <= 1'b1;
                display_name  <= "A";
                display_value <= a_reg;
            end
            6'd2: begin
                display_valid <= 1'b1;
                display_name  <= "B";
                display_value <= b_reg;
            end
            6'd3: begin
                display_valid <= 1'b1;
                display_name  <= "OPCODE";
                display_value <= {29'd0, opcode_reg};
            end
            6'd4: begin
                display_valid <= 1'b1;
                display_name  <= "CIN";
                display_value <= {31'd0, cin_reg};
            end
            6'd5: begin
                display_valid <= 1'b1;
                display_name  <= "RESULT";
                display_value <= result_wire;
            end
            6'd6: begin
                display_valid <= 1'b1;
                display_name  <= "COUT";
                display_value <= {31'd0, cout_wire};
            end
            default: begin
                display_valid <= 1'b0;
                display_name  <= 40'd0;
                display_value <= 32'd0;
            end
        endcase
    end

endmodule