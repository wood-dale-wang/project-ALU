-- xmake.lua: Compatible with older xmake versions

-- 导入 file 模块（适用于所有 xmake 版本）
import("core.base.file")

function parse_mod_ini()
    local content = file.read("mod.ini")
    if not content then
        raise("Error: mod.ini not found!")
    end

    local sections = {
        source = {},
        tb = {},
        vcd = {}
    }
    local current_section = nil

    -- 按行分割：兼容 \n 和 \r\n
    for line in content:gmatch("[^\r\n]+") do
        -- 去除首尾空白
        line = line:gsub("^%s*(.-)%s*$", "%1")

        -- 跳过空行和注释（; 或 #）
        if line == "" or line:sub(1,1) == ";" or line:sub(1,1) == "#" then
            goto continue
        end

        -- 匹配 [section]
        local sect_match = line:match("^%[(.+)%]$")
        if sect_match then
            local sect_name = sect_match:lower()
            if sections[sect_name] ~= nil then
                current_section = sect_name
            else
                current_section = nil  -- 忽略未知节
            end
        elseif current_section and line ~= "" then
            table.insert(sections[current_section], line)
        end

        ::continue::
    end

    return sections
end

-- 解析配置
local mod_config = parse_mod_ini()
local verilog_files = table.join(mod_config.source, mod_config.tb)
local vcd_files = mod_config.vcd

if #verilog_files == 0 then
    raise("Error: No Verilog files found in [source] or [tb] sections.")
end

target("sim")
    set_kind("phony")
    on_build(function (target)
        import("lib.detect.find_tool")

        local iverilog = assert(find_tool("iverilog"), "iverilog not found! Please install Icarus Verilog.")
        local vvp = assert(find_tool("vvp"), "vvp not found!")
        local gtkwave = find_tool("gtkwave")

        local cmd = iverilog.program .. " -o tmp.vvp " .. table.concat(verilog_files, " ")
        print("Compiling with: " .. cmd)
        os.exec(cmd)

        print("Running simulation...")
        os.exec(vvp.program .. " tmp.vvp")

        for _, vcd in ipairs(vcd_files) do
            if os.isfile(vcd) then
                if gtkwave then
                    print("Opening VCD file: " .. vcd)
                    os.execv(gtkwave.program, {vcd})
                else
                    print("gtkwave not found. Skipping VCD viewer for: " .. vcd)
                end
            else
                cprint("${color.warning}Warning: VCD file '${vcd}' not found.")
            end
        end

        os.tryrm("tmp.vvp")
        print("Temporary file 'tmp.vvp' deleted.")
    end)