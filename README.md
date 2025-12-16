# ALU

## 设计

### 目标

32位无符号数

1. 加法
2. 左移
3. 右移
4. 截断
5. 与
6. 或
7. 非
8. 异或

### 指令设计

| 指令  | 操作数1 | 操作数2 | 说明    |
|-----|------|------|-------|
| NOT | num1 |      | 非     |
| AND | num1 | num2 | 与     |
| OR  | num1 | num2 | 或     |
| XOR | num1 | num2 | 异或    |
| SHL | num  | n    | 左移    |
| SHR | num  | n    | 右移    |
| CUT | num  | n    | 保留低n位 |
| ADD | num1 | num2 | 加法    |

从上到下顺序编号

另：cin输入作用于结果，即结果上加1（输入0则加0），cout为溢出位，这两个只在进行加法的时候起作用

## 从此储存库构建vivado项目

使用的硬件：Artix-7 xc7a200tfbg676-2。

新建项目，选择对应器件

+ 将src目录下文件加入项目
+ 将fpga目录下文件加入项目（注意`alu.xdc`要加入到`Constraints`下，建议建项目后再手动加入）

检查，现在的顶级项目应该是`ALU_Unsigned_Display.v`，不是的检查操作。

现在就可以生成bit流了。

## 非vivado运行

这个项目也可以不依赖vivado，本身该项目验证的时候就是通过iverilog验证的。

先决条件：

1. iverilog
2. powershell（开启ps1运行权限）
3. GTKWave或WaveTrace(vsc插件)(如果不需要波形显示则不需要)

编辑mod.ini：配置你的源文件和测试文件，以及波形文件

类似于:

```ini
[source]
src/ALU.v
src/AND_32.v
src/NOT_32.v
src/OR_32.v
src/XOR_32.v
src/ADDER/ADD_32.v
src/MUX/MUX_2.v
src/SH/SHL_x.v
src/SH/SHL_top.v
src/SH/SHR_x.v
src/SH/SHR_top.v
src/CUT_32.v
src/MUX/AND_1_32.v
src/MUX/MUX_8.v

[tb]
tb/ALU_tb.v

[vcd]

```

run:

```pwsh
./run.ps1
```

### 生成器

`src/generate.py`是用来构建32位超前进位加法器的构建器，按照规律输出verilog语句。

## 文档

见docs目录，使用typst编写，后面会上传对应的pdf，或者vsc加载typst插件查看。

### 查询FPGA引脚

见fpga目录下的`FPGA-A7-PRJ-UDB_V1.0-引脚坐标参考.pdf`，首先找到需要的模块，找到其中的`FPGA_XXX`，通过搜索导航到型号为XC7A200T（fpga芯片）的部分，可以找到器件对于FPGA的引脚编号。

例如，要找到第1个拨码开关的引脚编号：

+ 找到拨码开关部分，在第5页右下角
+ 找到第一个拨码开关的编号，为`FPGA_SW0`
+ 搜索`FPGA_SW0`，导航到第4页的左上角，编号为U1B的XC7A200T图像部分
+ 可以看到，`FPGA_SW0`对应的引脚编号是`AC21`
