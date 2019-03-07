local luamp = require 'luamp'
local table = require 'table'

layout = luamp.layouts.matrix(
   luamp.origin, 2, 4,
   {{-- parsing
     function(c)
         return luamp.rectangle(c, 2.5, 1)
     end,
     -- resolution
     function(c)
         return luamp.rectangle(c, 2.5, 1)
     end,
     -- type checking
     function(c)
         return luamp.rectangle(c, 2.5, 1)
     end},
    {-- linking
     function(c)
         return luamp.rectangle(c, 2.5, 1)
     end,
     -- llvm optimation
     function(c)
         return luamp.rectangle(c, 2.5, 1)
     end,
     -- translation
     function(c)
         return luamp.rectangle(c, 2.5, 1)
     end}})

figs = {}

-- texts
txts = {{"\\footnotesize Parsing", false, "\\footnotesize Analysis"},
    {"\\footnotesize Linking", "\\footnotesize LLVM Optimation", "\\footnotesize Translation"}}
for i = 1, #txts do
    for j = 1, #txts[i] do
        if txts[i][j] then
            table.insert(
                figs,
                luamp.text(
                    luamp.center(layout.shapes[i][j]),
                    luamp.directions.center,
                    txts[i][j]))
        end
    end
end
table.insert(
    figs,
    luamp.text(
        luamp.center(layout.shapes[1][2]),
        luamp.directions.top,
        "\\footnotesize Name Resolution"))
table.insert(
    figs,
    luamp.text(
        luamp.center(layout.shapes[1][2]),
        luamp.directions.bottom,
        "\\footnotesize Macro Expansion"))

-- arrows
local arr = luamp.arrow(
    luamp.center(layout.shapes[1][1]) + luamp.point(-2.5, 0),
    layout.shapes[1][1])
table.insert(figs, arr)
table.insert(
    figs,
    luamp.text(
        luamp.center(arr),
        luamp.directions.top,
        "\\footnotesize .rs"))
local arr = luamp.arrow(
    layout.shapes[1][1],
    layout.shapes[1][2])
table.insert(figs, arr)
table.insert(
    figs,
    luamp.text(
        luamp.center(arr),
        luamp.directions.top,
        "\\footnotesize AST"))
local arr = luamp.arrow(
    layout.shapes[1][2],
    layout.shapes[1][3])
table.insert(figs, arr)
table.insert(
    figs,
    luamp.text(
        luamp.center(arr),
        luamp.directions.top,
        "\\footnotesize HIR"))
local arr = luamp.arrow(
    layout.shapes[1][3],
    layout.shapes[2][3])
table.insert(figs, arr)
table.insert(
    figs,
    luamp.text(
        luamp.center(arr),
        luamp.directions.right,
        "\\footnotesize MIR"))
local arr = luamp.arrow(
    layout.shapes[2][3],
    layout.shapes[2][2])
table.insert(figs, arr)
table.insert(
    figs,
    luamp.text(
        luamp.center(arr),
        luamp.directions.top,
        "\\footnotesize LLVM IR"))
local arr = luamp.arrow(
    layout.shapes[2][2],
    layout.shapes[2][1])
table.insert(figs, arr)
table.insert(
    figs,
    luamp.text(
        luamp.center(arr),
        luamp.directions.top,
        "\\footnotesize .o"))
local arr = luamp.arrow(
    layout.shapes[2][1],
    luamp.center(layout.shapes[2][1]) + luamp.point(-2.5, 0))
table.insert(figs, arr)

-- llvm

local llvm = luamp.rectangle(
    luamp.centroid(luamp.center(layout.shapes[2][1]), luamp.center(layout.shapes[2][2])),
    7, 2,
    {line_style=luamp.line_styles.dashed})
table.insert(figs, llvm)
table.insert(
    figs,
    luamp.text(
        luamp.center(llvm) + luamp.point(0, -luamp.height(llvm)/2),
        luamp.directions.top,
        "\\footnotesize LLVM backend"))

print(luamp.figure(layout, table.unpack(figs)))
