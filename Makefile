.POSIX:
all: compile

# Change these to match your situation
PREFIX    = $(HOME)/.local
LUABASE   = $(PREFIX)
INST_BIN  = $(PREFIX)/bin
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
#
# Master targets are compile check install clean
# All the subdirs have a series of targets:
#   compile_DIR
#   check_DIR
#   install_DIR
#   clean_DIR

DERIVED_LUA = date/discordian.lua text/rot13.lua
COMPILED_SO = text/bintext.so

.SUFFIXES: .msrc .lua

.msrc.lua:
	$(MACSRC) < $< | luac -o $@ -

compile: compile_date compile_text
check: check_date check_text
install: compile install_date install_text
clean: clean_date clean_text

install_dirs:
	mkdir -p $(INST_LIB)/{date,text}
	mkdir -p $(INST_MAN)
	mkdir -p $(INST_BIN)

# ~~~~ D A T E ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
compile_date: date/discordian.lua

check_date: compile_date
	@$(LUACHK) date/check_discordian.lua

install_date: compile_date install_dirs
	cp date/discordian.lua $(INST_LIB)/date
	gzip -c -9 date/date.discordian.3l > $(INST_MAN)/date.discordian.3l.gz
	(echo "#!$(LUABASE)/bin/lua"; luac -o - utils/ddate.lua) \
		> $(INST_BIN)/ddate
	chmod +x $(INST_BIN)/ddate

clean_date: 
	rm -f date/discordian.lua


# ~~~~ T E X T ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
compile_text: text/bintext.so text/rot13.lua

check_text: compile_text
	@$(LUACHK) text/check_rot13.lua
	@$(LUACHK) text/check_bintext.lua

install_text: compile_text install_dirs
	cp text/rot13.lua text/bintext.so $(INST_LIB)/text
	gzip -c -9 text/text.bintext.3l > $(INST_MAN)/text.bintext.3l.gz

clean_text:
	rm -f text/rot13.lua text/bintext.so text/*.o

# individual compilation rules for shared libs...
text/bintext.so: text/bintext.o
	$(CC) $(LDFLAGS) -o text/bintext.so text/bintext.o

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

