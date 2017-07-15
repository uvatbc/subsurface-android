GITROOT?=$(shell git rev-parse --show-toplevel)

SQLITE_VERSION=3190200
LIBXML2_VERSION=2.9.4
LIBXSLT_VERSION=1.1.29
LIBZIP_VERSION=1.1.3
LIBGIT2_VERSION=0.25.1
LIBUSB_VERSION=1.0.20
OPENSSL_VERSION=1.0.2l
LIBFTDI_VERSION=1.3

ARCH?=arm

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
	cd libdivecomputer ; git checkout Subsurface-branch
	cd subsurface      ; git checkout master

get_tars:
	wget http://www.sqlite.org/2017/sqlite-autoconf-${SQLITE_VERSION}.tar.gz
	wget ftp://xmlsoft.org/libxml2/libxml2-${LIBXML2_VERSION}.tar.gz
	wget ftp://xmlsoft.org/libxml2/libxslt-${LIBXSLT_VERSION}.tar.gz
	wget http://www.nih.at/libzip/libzip-${LIBZIP_VERSION}.tar.gz
	wget -O openssl-${OPENSSL_VERSION}.tar.gz http://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
	wget -O libgit2-${LIBGIT2_VERSION}.tar.gz https://github.com/libgit2/libgit2/archive/v${LIBGIT2_VERSION}.tar.gz
	wget -O libusb-${LIBUSB_VERSION}.tar.gz https://github.com/libusb/libusb/archive/v${LIBUSB_VERSION}.tar.gz
	wget -O libftdi1-${LIBFTDI_VERSION}.tar.bz2 http://www.intra2net.com/en/developer/libftdi/download/libftdi1-${LIBFTDI_VERSION}.tar.bz2

get_ndk:
	"$$ANDROID_NDK_ROOT/build/tools/make_standalone_toolchain.py" --arch="$(ARCH)" --install-dir=ndk-"$(ARCH)" --api=16

update:
	git submodule foreach git pull

build:
	cd libdivecomputer ; autoreconf --install
	cd libdivecomputer ; autoreconf --install # Twice because the build wrapper has it
	./subsurface/packaging/android/build.sh

in_docker:
	docker run \
		-it --rm \
		-v $(GITROOT):/tmp/src \
		accupara/subsurface:android \
		make -C /tmp/src $(TARGET)
