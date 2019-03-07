local mp = require 'luamp'
local table = require 'table'
local io = require 'io'
local str = require 'string'
local math = require 'math'

function readFiles()
    local benchs = {}
    local langs = {'c', 'cpp', 'rust', 'go'}
    local files = {"c_benchmark.dat", "cpp_benchmark.dat", "rust_benchmark.dat", "go_benchmark.dat"}
    for i = 1, #files do
        local f = io.open(files[i])
        f:read() -- skip the title line
        while true do
            local l = f:read()
            if not l then
                break
            end
            local m = str.gmatch(l, "([%w-]+)%s+([%d.]+)%s+(%d+)%s+(%d+)")
            if not m then
                break
            end
            for c, speed, mem, code in m do
                --io.stderr:write(str.format("%s %s %f %d %d\n", c, langs[i], speed, mem, code))
                if not benchs[c] then
                    benchs[c] = {[langs[i]] =  {speed = speed, mem = mem, code = code}}
                else
                    benchs[c][langs[i]] = {speed = speed, mem = mem, code = code}
                end
            end
        end
        f:close()
    end
    return benchs
end

function normalize(benchs)
    local normed = {
        speed = {cpp = {}, rust = {}, go = {}},
        mem = {cpp = {}, rust = {}, go = {}},
        code = {cpp = {}, rust = {}, go = {}}
    }
    local langs = {'cpp', 'rust', 'go'}
    local races = {'speed', 'mem', 'code'}
    local cases = {}
    for case, _ in pairs(benchs) do
        table.insert(cases, case)
    end
    table.sort(cases)
    for _, case in ipairs(cases) do
        for _, lang in ipairs(langs) do
            for _, race in ipairs(races) do
                table.insert(normed[race][lang], benchs[case][lang][race] / benchs[case]['c'][race])
            end
        end
    end
    
    return normed
end

benchs = readFiles()
norm_benchs = normalize(benchs)

figs = {}
colors = {cpp = mp.colors.blue, rust = mp.colors.red, go = mp.colors.cyan}

function drawExamples()
    local y = 1
    local i = 0
    local delta = mp.point(-0.5, 0)
    for lang, color in pairs(colors) do
        local p = mp.point(9.3, y + i * 0.3)
        table.insert(
            figs,
            mp.line(p + delta, p, {pen_color=color}))
        table.insert(
            figs,
            mp.text(
                p,
                mp.directions.right,
                str.format("\\footnotesize %s/c", lang)))
        i = i + 1
    end
end

drawExamples()

function drawAxes(race, y_base, y_marks, base)
    table.insert(figs, mp.arrow(mp.point(0, y_base), mp.point(10, y_base)))
    table.insert(
        figs,
        mp.arrow(
            mp.point(0, y_base + math.log(0.4, base)),
            mp.point(0, y_base + math.log(y_marks[#y_marks], base) + 0.3)))
    for _, y in ipairs(y_marks) do
        table.insert(
            figs,
            mp.line(
                mp.point(0, y_base + math.log(y, base)),
                mp.point(10, y_base + math.log(y, base)),
                {line_style=mp.line_styles.dotted}))
        table.insert(
            figs,
            mp.text(
                mp.point(0, y_base + math.log(y, base)),
                mp.directions.left,
                str.format("\\footnotesize %.1f", y)))
    end
    table.insert(
        figs,
        mp.text(
            mp.point(-1, y_base),
            mp.directions.center,
            str.format("\\footnotesize %s", race)))
end

function drawLines(race, y_base, base)
    local bench = norm_benchs[race]
    local w = 0.1
    local x_offset = {rust = 0, cpp = w, go = 2 * w}
    for lang, x in pairs(bench) do
        for i, v in ipairs(x) do
            local h = math.log(v, base)
            if h ~= 0 then
                table.insert(
                    figs,
                    mp.rectangle(
                        mp.point(i - 0.5 + x_offset[lang], y_base) + mp.point(w / 2, h / 2),
                        w,
                        math.abs(h),
                        {brush_color=colors[lang]}))
            end
        end
    end
end

function drawSpeed(y_base, y_marks)
    local y_base = 0
    local y_marks = {0.5, 1, 2, 4, 8}
    drawAxes('speed', y_base, y_marks, 4)
    drawLines('speed', y_base, 4)
end

drawSpeed()

function drawMem()
    local y_base = -2.125
    local y_marks = {1, 2, 4}
    drawAxes('mem', y_base, y_marks, 4)
    drawLines('mem', y_base, 4)
end

drawMem()

function drawCode()
    local y_base = -4
    local y_marks = {0.5, 1, 2, 4}
    drawAxes('code', y_base, y_marks, 4)
    drawLines('code', y_base, 4)
end

drawCode()


print(mp.figure(table.unpack(figs)))

