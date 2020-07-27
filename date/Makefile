compile: discordian.lua

check: compile
	lua check_discordian.lua

%.lua: %.msrc
	macsrc < $< | luac -o $@ - 

install: compile
	-mkdir -p $(LIBDIR)/date
	cp discordian.lua $(LIBDIR)/date
	-mkdir -p $(PREFIX)/man/man3l
	cp date.discordian.3l $(PREFIX)/man/man3l

clean:
	-rm discordian.lua
.PHONY: compile check clean install

