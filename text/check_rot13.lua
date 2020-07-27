local r13 = require'rot13'

assert(r13.rot13('hello')=='uryyb')
assert(r13.rot13('uryyb')=='hello')
print('OK!')
