-- a utility replicating the classic linux command, `ddate(1)`
local dd = require'date.discordian'

local args = {...}

if #args == 1 then
	print(dd.date(args[1]))
elseif #args == 3 then
	print(dd.date(nil,os.time{year=args[1],month=args[2],day=args[3]}))
elseif #args == 4 then
	print(dd.date(args[1],os.time{year=args[2],month=args[3],day=args[4]}))
else
	print(dd.date())	
end
-- vim: filetype=lua:noet:ts=4:
