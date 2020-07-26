local d = require'discordian'
local tbl = d.date('*t',os.time({year=2020,month=2,day=19}))
assert(type(tbl) == 'table')
assert(tbl.Y == '3186')
assert(tbl.H == 'Chaoflux')
assert(tbl.B == 'Chaos')
assert(tbl.a == 'SO')
print('OK!')
