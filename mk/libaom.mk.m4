changequote(`[[[', `]]]')

# NOTE: This file is generated by m4! Make sure you're editing the .m4 version,
# not the generated version!

# 3.6.1
LIBAOM_VERSION=8dfcccd1

build/inst/%/lib/pkgconfig/aom.pc: build/libaom-$(LIBAOM_VERSION)/build-%/Makefile
	cd build/libaom-$(LIBAOM_VERSION)/build-$* ; \
		$(MAKE) install

# General build rule for any target
# Use: buildrule(target name, cmake flags)
define([[[buildrule]]], [[[
build/libaom-$(LIBAOM_VERSION)/build-$1/Makefile: build/inst/$1/cflags.txt build/libaom-$(LIBAOM_VERSION)/PATCHED
	mkdir -p build/libaom-$(LIBAOM_VERSION)/build-$1
	cd build/libaom-$(LIBAOM_VERSION)/build-$1 ; \
		emcmake cmake .. -DCMAKE_INSTALL_PREFIX="$(PWD)/build/inst/$1" \
		-DCMAKE_C_FLAGS="-Oz `cat $(PWD)/build/inst/$1/cflags.txt`" \
		-DCMAKE_CXX_FLAGS="-Oz `cat $(PWD)/build/inst/$1/cflags.txt`" \
		-DAOM_TARGET_CPU=generic \
		-DCMAKE_BUILD_TYPE=Release \
		-DENABLE_DOCS=0 \
		-DENABLE_TESTS=0 \
		-DENABLE_EXAMPLES=0 \
		-DCONFIG_RUNTIME_CPU_DETECT=0 \
		-DCONFIG_WEBM_IO=0 \
                $2
	touch $(@)
]]])

# Non-threaded
buildrule(base, [[[-DCONFIG_MULTITHREAD=0]]])
buildrule(simd, [[[-DCONFIG_MULTITHREAD=0]]])
# Threaded
buildrule(thr, [[[]]])
buildrule(thrsimd, [[[]]])

extract: build/libaom-$(LIBAOM_VERSION)/PATCHED

build/libaom-$(LIBAOM_VERSION)/PATCHED: build/libaom-$(LIBAOM_VERSION)/CMakeLists.txt
	cd build/libaom-$(LIBAOM_VERSION) ; ( test -e PATCHED || patch -p1 -i ../../patches/libaom.diff )
	touch $@

build/libaom-$(LIBAOM_VERSION)/CMakeLists.txt: build/libaom-$(LIBAOM_VERSION).tar.gz
	mkdir -p build/libaom-$(LIBAOM_VERSION)
	cd build/libaom-$(LIBAOM_VERSION) ; \
		tar zxf ../libaom-$(LIBAOM_VERSION).tar.gz
	touch $@

build/libaom-$(LIBAOM_VERSION).tar.gz:
	mkdir -p build
	curl https://aomedia.googlesource.com/aom/+archive/$(LIBAOM_VERSION).tar.gz -L -o $@

libaom-release:
	cp build/libaom-$(LIBAOM_VERSION).tar.gz libav.js-$(LIBAVJS_VERSION)/sources/

.PRECIOUS: \
	build/inst/%/lib/pkgconfig/aom.pc \
	build/libaom-$(LIBAOM_VERSION)/build-%/Makefile \
	build/libaom-$(LIBAOM_VERSION)/PATCHED \
	build/libaom-$(LIBAOM_VERSION)/CMakeLists.txt
