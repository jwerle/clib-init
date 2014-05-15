
BIN ?= clib-init
PREFIX ?= /usr/local

all: test

install:
	cp $(BIN).sh $(PREFIX)/bin/$(BIN)

uninstall:
	rm -f $(PREFIX)/bin/$(BIN)

test:
	cd test/ && ../clib-init.sh
	test -f test/package.json || exit -1
	rm -f test/package.json

clean:
	rm -f test/package.json

.PHONY: test
