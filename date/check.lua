local d = require'discordian'
local tbl = d.date('*t',os.time({year=2020,month=2,day=19}))
assert(type(tbl) == 'table')
assert(tbl.Y == '3186')
assert(tbl.H == 'Chaoflux')
assert(tbl.B == 'Chaos')
assert(tbl.a == 'SO')

-- spot check X-Day calculation
assert(d.date('%X',os.time{year=8660,month=2,day=29})=='492') -- "LAST TIBS EVER"
assert(d.date('%X',os.time{year=8656,month=2,day=29})=='1953') -- "2nd-to-last LAST TIBS EVER"
assert(d.date('%X',os.time{year=8661,month=2,day=1})=='154')
assert(d.date('%X',os.time{year=8661,month=7,day=1})=='4')
assert(d.date('%X',os.time{year=8661,month=7,day=5})=='0')
assert(d.date('%X',os.time{year=8661,month=8,day=1})=='-1')
assert(d.date('%X',{year=8661,yday=1})=='185')
assert(d.date('%X',{year=8651,yday=1})=='3838')
assert(d.date('%X',{year=8641,yday=1})=='7490')
assert(d.date('%X',{year=8631,yday=1})=='11143')
assert(d.date('%X',{year=8621,yday=1})=='14795')
assert(d.date('%X',{year=8611,yday=1})=='18448')
assert(d.date('%X',{year=8601,yday=1})=='22100')
print('OK!')
