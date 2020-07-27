local function dump(tbl)
	for k,v in pairs(tbl) do print(k,v) end
end

return { d=dump }
