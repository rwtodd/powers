all: discordian.lua

check: 
	lua check.lua

%.lua: %.msrc
	macsrc < $< > $@

clean:
	-rm discordian.lua
.PHONY: all check clean

