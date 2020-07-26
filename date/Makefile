all: discordian.lua

check: 
	lua check.lua

%.lua: %.msrc
	macsrc < $< > $@

.PHONY: all check

