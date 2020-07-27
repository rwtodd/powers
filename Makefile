.POSIX:
all: compile

# Change these to match your situation
PREFIX    = /usr/local
LUABASE   = $(PREFIX)
INST_LIB  = $(PREFIX)/lib/lua/5.4
INST_MAN  = $(PREFIX)/share/man/man3l
MACSRC    = macsrc # github.com/rwtodd/macro-source

# These should not need changing as frequently, but maybe
LUA       = $(LUABASE)/bin/lua
LUACHK    = LUA_PATH='./?.lua' LUA_CPATH='./?.so' $(LUA)
CC        = gcc
CFLAGS    = -I$(LUABASE)/include -fpic -O3 -march=native
LDFLAGS   = -shared

# Think harder before changing anything below ###################
DERIVED_LUA = date/discordian.lua text/rot13.lua
COMPILED_SO = text/bintext.so

.SUFFIXES: .msrc .lua

.msrc.lua:
	$(MACSRC) < $< | luac -o $@ -

compile: generate_lua compile_modules

generate_lua: $(DERIVED_LUA)
compile_modules: $(COMPILED_SO)

clean:
	rm -f $(DERIVED_LUA) $(COMPILED_SO)
	rm -f text/*.o

check: compile
	@$(LUACHK) date/check_discordian.lua
	@$(LUACHK) text/check_rot13.lua
	@$(LUACHK) text/check_bintext.lua

install: compile
	mkdir -p $(INST_LIB)/{date,text}
	mkdir -p $(INST_MAN)
	cp text/rot13.lua text/bintext.so $(INST_LIB)/text
	cp date/discordian.lua $(INST_LIB)/date
	gzip -c -9 text/text.bintext.3l > $(INST_MAN)/text.bintext.3l.gz
	gzip -c -9 date/date.discordian.3l > $(INST_MAN)/date.discordian.3l.gz

# individual compilation rules for shared libs...
text/bintext.so: text/bintext.o
	$(CC) $(LDFLAGS) -o text/bintext.so text/bintext.o

