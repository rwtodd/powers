local r13 = require'text.rot13'

assert(r13.rot13('hello')=='uryyb')
assert(r13.rot13('uryyb')=='hello')
print('text.rot13... OK!')
