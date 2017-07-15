GITROOT?=$(shell git rev-parse --show-toplevel)

help:
	@echo "On the first run:"
	@echo "make init"
	@echo ""
	@echo "To update:"
	@echo "make update"
	@echo ""
	@echo "To build (if you've already set up the build environment):"
	@echo "make build"
	@echo ""
	@echo "To build (to use a pre-built environment):"
	@echo "make build_in_docker"

init:
	git submodule update --init

update:
	git submodule foreach git pull

build:
	cd libdivecomputer ; autoreconf --install
	cd libdivecomputer ; autoreconf --install # Twice because the build wrapper has it
	./subsurface/packaging/android/build.sh

build_in_docker:
	docker run \
		-it --rm \
		-v $(GITROOT):/tmp/src \
		accupara/subsurface:android \
		/bin/bash -c \
		"cd /tmp/src/ ; ./subsurface/packaging/android/build.sh"