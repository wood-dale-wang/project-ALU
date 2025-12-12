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

### 现在目标

逐步将各个部分换为门级实现

| 指令  |  状态 | 备注 |
|-----|------|------|
| NOT | 完成 ||
| AND | 完成 ||
| OR  | 完成 ||
| XOR | 完成 ||
| SHL | 完成 | 需要移位算法 |
| SHR | 完成 | 需要移位算法 |
| CUT | 完成 ||
| ADD | 完成 | 现在是直接构建的32位超前进位加法器，可以改为分层构建 |
| MUX | 完成 | 8-1 多路复用器 |

## 运行

先决条件：

1. iverilog
2. powershell（开启ps1运行权限）
3. GTKWave或WaveTrace(vsc插件)(如果不需要波形显示则不需要)

编辑mod.ini：配置你的源文件和测试文件，以及波形文件

类似于:

```ini
[source]
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
