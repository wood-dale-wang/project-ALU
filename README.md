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

另：cin输入作用于结果，即结果上加1（输入0则加0），cout为溢出位

### 现在目标

逐步将各个部分换为门级实现

| 指令  |  状态 | 备注 |
|-----|------|------|
| NOT | 完成 ||
| AND | 完成 ||
| OR  | 完成 ||
| XOR |     ||
| SHL |     | 需要移位算法 |
| SHR |     | 需要移位算法 |
| CUT |     ||
| ADD |     | 需要超前进位加法器 |
| MUX |     | 8-1 多路复用器 |

## 运行

先决条件：

1. iverilog
2. powershell（开启ps1运行权限）
3. GTKWave或WaveTrace(vsc插件)(如果不需要波形显示则不需要)

编辑mod.ini：配置你的源文件和测试文件，以及波形文件

类似于:

```ini
[source]
ALU.v
AND_32.v
NOT_32.v
OR_32.v

[tb]
ALU_tb.v

[vcd]

```

run:

```pwsh
./run.ps1
```
