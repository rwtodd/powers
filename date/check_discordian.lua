local d = require'date.discordian'
local tbl = d.date('*t',os.time({year=2020,month=2,day=19}))
assert(type(tbl) == 'table')
assert(tbl.Y == '3186')
assert(tbl.H == 'Chaoflux')
assert(tbl.B == 'Chaos')
assert(tbl.a == 'SO')

-- spot check X-Day calculation
assert(d.date('%X',os.time{year=8661,month=2,day=1})=='154')
assert(d.date('%X',os.time{year=8661,month=7,day=1})=='4')
assert(d.date('%X',os.time{year=8661,month=7,day=5})=='0')
assert(d.date('%X',os.time{year=8661,month=7,day=6})=='-1')
assert(d.date('%X',{year=8661,yday=1})=='185')
assert(d.date('%X',{year=8651,yday=1})=='3838')
assert(d.date('%X',{year=8641,yday=1})=='7490')
assert(d.date('%X',{year=8631,yday=1})=='11143')
assert(d.date('%X',{year=8621,yday=1})=='14795')
assert(d.date('%X',{year=8611,yday=1})=='18448')
assert(d.date('%X',{year=8601,yday=1})=='22100')

assert(d.date('%X',os.time{year=8660,month=3,day=1})=='491') 
assert(d.date('%X',os.time{year=8660,month=2,day=29})=='492') -- "LAST TIBS EVER"
assert(d.date('%X',os.time{year=8660,month=2,day=28})=='493')
assert(d.date('%X',os.time{year=8656,month=2,day=29})=='1953') -- "2nd-to-last LAST TIBS"

-- Now check a smattering of years...
local function leap_p(greg_year)
	return (greg_year%4==0) and (greg_year%100~=0 or greg_year%400==0)
end

local dt = { year=8661,yday=186 }
local cnt = 0
while dt.year > 5999 do
	while dt.yday > 0 do
		local calculated = tonumber(d.date("%X",dt))
		assert(calculated==cnt, 
			string.format("year %d day %d (%d vs correct %d)",
				dt.year, dt.yday, calculated, cnt))
		dt.yday = dt.yday - 1
		cnt = cnt + 1
	end	
	dt.year = dt.year - 1
	dt.yday = 365 + (leap_p(dt.year) and 1 or 0)
end

print('date.discordian... OK!')
