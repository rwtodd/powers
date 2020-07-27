# Set these variables for your system
.PHONY: compile libs pgms install check clean

compile: libs pgms rot13.lua

%.lua: %.msrc
	macsrc < $< | luac -o $@ - 

libs: bintext.so 

pgms: 

bintext.o: bintext.c 
	$(CC) $(CFLAGS) -fpic -c -o $@ $<

bintext.so: bintext.o 
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $< 

install: compile
	-mkdir -p $(LIBDIR)/text
	cp bintext.so rot13.lua $(LIBDIR)/text
	-mkdir -p $(PREFIX)/man/man3l
	cp text.bintext.3l $(PREFIX)/man/man3l

check: compile
	lua check_bintext.lua
	lua check_rot13.lua

clean:
	-rm bintext.so bintext.o rot13.lua
