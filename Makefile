# Set these variables for your system
export LUABASE ?= /usr
export PREFIX  ?= $(LUABASE)
export LIBDIR  = $(PREFIX)/lib/lua/5.4
export CC ?= cc
export MAKE ?= make
export CFLAGS=-I$(LUABASE)/include -march=native -O2
ifeq ($(shell uname -s),Linux)
  LDFLAGS=-shared -fpic
else
  LDFLAGS=-shared -fpic -undefined dynamic_lookup
endif
export LDFLAGS

all: compile 

compile:
	cd date && $(MAKE) compile
	cd text && $(MAKE) compile

clean:
	cd date && $(MAKE) clean
	cd text && $(MAKE) clean

check: compile
	cd date && $(MAKE) check
	cd text && $(MAKE) check

install: compile
	cd date && $(MAKE) install
	cd text && $(MAKE) install

.PHONY: all compile clean check install
