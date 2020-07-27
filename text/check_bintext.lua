local bt = require'text.bintext'

assert(bt.hex_encode('abcdefghijk') == '6162636465666768696a6b')
assert(bt.hex_decode('6162636465666768696a6b') == 'abcdefghijk')
assert(bt.hex_encode('   ') == '202020')
assert(bt.hex_decode('202020') == '   ')
assert(bt.b64_encode('abcdefghijk') == 'YWJjZGVmZ2hpams=')
assert(bt.b64_decode('YWJjZGVmZ2hpams=') == 'abcdefghijk')

-- bad lengths
assert(nil == bt.b64_decode('6'))
assert(nil == bt.b64_decode('66'))
assert(nil == bt.b64_decode('666'))
assert(nil == bt.b64_decode('66666'))
assert(nil == bt.b64_decode('666666'))
assert(nil == bt.b64_decode('6666666'))
assert(nil == bt.hex_decode('61636'))
assert(nil == bt.hex_decode('616'))

-- bad formats
assert(nil == bt.b64_decode('@abc'))
assert(nil == bt.b64_decode('a@bc'))
assert(nil == bt.b64_decode('ab@c'))
assert(nil == bt.b64_decode('abc@'))
assert(nil == bt.b64_decode('abcda@=='))
assert(nil == bt.b64_decode('abcdab@='))
assert(nil == bt.hex_decode('61v2'))
assert(nil == bt.hex_decode('612v'))

print('text.bintext... OK!')
