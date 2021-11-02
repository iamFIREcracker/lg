.PHONY: clean test-sbcl test-ros binary-sbcl binary install

PREFIX?=/usr/local
lisps := $(shell find .  -type f \( -iname \*.asd -o -iname \*.lisp \))

all: binary

# Clean -----------------------------------------------------------------------
clean:
	rm -rf bin

# Info ------------------------------------------------------------------------
.PHONY: lisp-info
lisp-info:
	sbcl --noinform --quit \
		--load "build/info.lisp"

.PHONY: lisp-info-ros
lisp-info-ros:
	ros \
		--load "build/info.lisp" \

# Build -----------------------------------------------------------------------
.PHONY: binary
binary: binary-sbcl

.PHONY: binary-sbcl
binary-sbcl: bin $(lisps)
	sbcl --noinform --quit \
		--load "build/setup.lisp" \
		--load "build/build.lisp"

.PHONY: binary-ros
binary-ros: bin $(lisps)
	ros run \
		--load "build/setup.lisp" \
		--load "build/build.lisp"

bin:
	mkdir -p bin

# Tests -----------------------------------------------------------------------
.PHONY: test
test: test-sbcl

.PHONY: test-sbcl
test-sbcl: $(lisps)
	sbcl --noinform --quit \
		--load "build/setup.lisp" \
		--load "build/test.lisp"

.PHONY: test-ros
test-ros: $(lisps)
	ros run \
		--load "build/setup.lisp" \
		--load "build/test.lisp"

# Install ---------------------------------------------------------------------
install:
	cp bin/lg* $(PREFIX)/bin/
