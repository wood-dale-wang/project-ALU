# run_mod.ps1 - Windows PowerShell script to parse mod.ini and run simulation

$iniFile = "mod.ini"

# 检查 mod.ini 是否存在
if (-not (Test-Path $iniFile)) {
    Write-Host "Error: $iniFile not found!" -ForegroundColor Red
    exit 1
}

# 读取整个文件内容
# $content = Get-Content $iniFile -Raw

# 初始化各节内容
$sections = @{
    "source" = @()
    "tb"     = @()
    "vcd"    = @()
}

$currentSection = $null

# 逐行解析 ini 文件
foreach ($line in (Get-Content $iniFile)) {
    $line = $line.Trim()
    if ($line -eq "" -or $line.StartsWith(";") -or $line.StartsWith("#")) {
        continue
    }

    if ($line -match '^\[(.+)\]$') {
        $currentSection = $matches[1].ToLower()
        if ($sections.ContainsKey($currentSection) -eq $false) {
            $currentSection = $null
        }
        continue
    }

    if ($currentSection -and $line -ne "") {
        $sections[$currentSection] += $line
    }
}

# 合并 source 和 tb 文件
$verilogFiles = @($sections["source"] + $sections["tb"]) | Where-Object { $_ -ne "" }

if ($verilogFiles.Count -eq 0) {
    Write-Host "Error: No Verilog source or testbench files found in [source] or [tb]." -ForegroundColor Red
    exit 1
}

# 构建 iverilog 命令
$iverilogCmd = "iverilog -o tmp.vvp " + ($verilogFiles -join " ")

Write-Host "Compiling with: $iverilogCmd"
Invoke-Expression $iverilogCmd
if ($LASTEXITCODE -ne 0) {
    Write-Host "iverilog failed." -ForegroundColor Red
    exit 1
}

# 运行仿真
Write-Host "Running simulation..."
vvp .\tmp.vvp
if ($LASTEXITCODE -ne 0) {
    Write-Host "vvp simulation failed." -ForegroundColor Red
}

# 如果有 vcd 文件，启动 gtkwave
$vcdFiles = $sections["vcd"] | Where-Object { $_ -ne "" }
if ($vcdFiles.Count -gt 0) {
    foreach ($vcd in $vcdFiles) {
        if (Test-Path $vcd) {
            Write-Host "Opening $vcd with GTKWave..."
            Start-Process gtkwave -ArgumentList "`"$vcd`""
        } else {
            Write-Host "Warning: VCD file '$vcd' not found." -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "No VCD file specified or [vcd] section empty."
}

# 清理临时文件
if (Test-Path .\tmp.vvp) {
    Remove-Item .\tmp.vvp
    Write-Host "Temporary file tmp.vvp deleted."
}