local repl = {}

function repl.d(tbl)
	for k,v in pairs(tbl) do print(k,v) end
end

return repl
