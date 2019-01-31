# defining LUA and make executables depending on the operation system
# https://stackoverflow.com/questions/4058840/makefile-that-distincts-beetween-windows-and-unix-like-systems

TARGETOS = $(MAKECMDGOALS)

ifneq ($(TARGETOS),ubuntu)
ifneq ($(TARGETOS),windows)
$(error use 'make ubuntu' or 'make windows')
endif
endif

ifdef SYSTEMROOT #WINDOWS
	LUA  = ../../../../../../ceu-maker/ceu-maker-windows/run/lua53.exe 
	MAKE = ../../../../../ceu-maker/ceu-maker-windows/mingw/bin/make.exe
else
	ifeq ($(shell uname), Linux) #UBUNTU
		LUA = lua5.3 
		MAKE = make
	endif
endif

BRANCH = master

ubuntu: clean dirs repos ceu arduino sdl pico examples icos compress
windows: clean dirs repos ceu arduino sdl pico examples winrar

clean:
	rm -Rf ceu-maker/docs/
	rm -Rf ceu-maker/repos/
	rm -Rf ceu-maker/examples/ceu-arduino/
	rm -Rf ceu-maker/examples/pico-ceu/
	rm -Rf ceu-maker/dist/
	rm -f ceu-maker/run/ceu.lua

dirs:
	mkdir -p resources/both/repos/
	mkdir -p releases/
	mkdir -p ceu-maker/ceu-maker-$(TARGETOS)/run/c
	mkdir -p ceu-maker/ceu-maker-$(TARGETOS)/docs/
	mkdir -p ceu-maker/ceu-maker-$(TARGETOS)/repos/ceu-arduino/
	mkdir -p ceu-maker/ceu-maker-$(TARGETOS)/repos/ceu-arduino/env/
	mkdir -p ceu-maker/ceu-maker-$(TARGETOS)/repos/ceu-arduino/include/
	mkdir -p ceu-maker/ceu-maker-$(TARGETOS)/repos/ceu-arduino/libraries/
	mkdir -p ceu-maker/ceu-maker-$(TARGETOS)/repos/pico-ceu/
	mkdir -p ceu-maker/ceu-maker-$(TARGETOS)/repos/pico-ceu/env/
	mkdir -p ceu-maker/ceu-maker-$(TARGETOS)/repos/pico-ceu/include/
	mkdir -p ceu-maker/ceu-maker-$(TARGETOS)/examples/
	mkdir -p ceu-maker/ceu-maker-$(TARGETOS)/examples/both/
	mkdir -p ceu-maker/ceu-maker-$(TARGETOS)/examples/ceu-arduino/
	mkdir -p ceu-maker/ceu-maker-$(TARGETOS)/examples/pico-ceu/

repos:
	-git clone https://github.com/ceu-lang/ceu         resources/both/repos/ceu
	-git clone https://github.com/ceu-lang/ceu-arduino resources/both/repos/ceu-arduino
	-git clone https://github.com/ceu-lang/ceu-sdl     resources/both/repos/ceu-sdl
	-git clone https://github.com/ceu-lang/pico-ceu    resources/both/repos/pico-ceu
	cd resources/both/repos/ceu/         && git pull && git checkout $(BRANCH)
	cd resources/both/repos/ceu-arduino/ && git pull && git checkout $(BRANCH)
	cd resources/both/repos/ceu-sdl/     && git pull && git checkout $(BRANCH)
	cd resources/both/repos/pico-ceu/    && git pull && git checkout $(BRANCH)
	cd resources/both/repos/ceu-arduino/libraries/ && $(MAKE) clone

ceu:
	cp -Rf resources/both/run/c/*                               ceu-maker/ceu-maker-$(TARGETOS)/run/c
	cp -Rf resources/both/repos/ceu/env/*                       ceu-maker/ceu-maker-$(TARGETOS)/repos/pico-ceu/env/
	cp -Rf resources/both/repos/ceu/include/*                   ceu-maker/ceu-maker-$(TARGETOS)/repos/ceu-arduino/include/
	cp -Rf resources/both/repos/ceu/include/*                   ceu-maker/ceu-maker-$(TARGETOS)/repos/pico-ceu/include/
	cp resources/both/repos/ceu/docs/manual/v0.30/ceu-v0.30.pdf ceu-maker/ceu-maker-$(TARGETOS)/docs/
	cd resources/both/repos/ceu/src/lua && $(LUA) pak.lua lua5.3
	cp resources/both/repos/ceu/src/lua/ceu                     ceu-maker/ceu-maker-$(TARGETOS)/run/ceu.lua

arduino:
	cp resources/both/repos/ceu-arduino/docs/manual/v0.20/ceu-arduino-v0.20.pdf ceu-maker/ceu-maker-$(TARGETOS)/docs/
	#cp repos/ceu-arduino/docs/manual/v0.30/ceu-arduino-v0.30.pdf ceu-maker/docs/
	cp     resources/both/repos/ceu-arduino/Makefile            ceu-maker/ceu-maker-$(TARGETOS)/repos/ceu-arduino/
	cp     resources/both/run/make-arduino.conf                 ceu-maker/ceu-maker-$(TARGETOS)/repos/ceu-arduino/Makefile.conf
	cp -Rf resources/both/repos/ceu-arduino/env/*               ceu-maker/ceu-maker-$(TARGETOS)/repos/ceu-arduino/env/
	cp -Rf resources/both/repos/ceu-arduino/include/*           ceu-maker/ceu-maker-$(TARGETOS)/repos/ceu-arduino/include/
	cp -Rf resources/both/repos/ceu-arduino/libraries/*         ceu-maker/ceu-maker-$(TARGETOS)/repos/ceu-arduino/libraries/

sdl:
	cp -Rf resources/both/repos/ceu-sdl/include/*               ceu-maker/ceu-maker-$(TARGETOS)/repos/pico-ceu/include/

pico:
	cp     resources/both/repos/pico-ceu/docs/manual/v0.40/pico-ceu-v0.40.pdf ceu-maker/ceu-maker-$(TARGETOS)/docs/
	cp     resources/both/repos/pico-ceu/Makefile               ceu-maker/ceu-maker-$(TARGETOS)/repos/pico-ceu/
	cp     resources/both/repos/pico-ceu/tiny.ttf               ceu-maker/ceu-maker-$(TARGETOS)/repos/pico-ceu/
	cp     resources/both/repos/pico-ceu/pico.ceu               ceu-maker/ceu-maker-$(TARGETOS)/repos/pico-ceu/
	cp     resources/both/run/make-pico.conf                    ceu-maker/ceu-maker-$(TARGETOS)/repos/pico-ceu/Makefile.conf
	cp -Rf resources/both/repos/pico-ceu/include/*              ceu-maker/ceu-maker-$(TARGETOS)/repos/pico-ceu/include/

examples:
	cp -Rf resources/both/repos/ceu-arduino/examples/* ceu-maker/ceu-maker-$(TARGETOS)/examples/ceu-arduino/
	cp -Rf resources/both/repos/pico-ceu/examples/*    ceu-maker/ceu-maker-$(TARGETOS)/examples/pico-ceu/
	cp -Rf resources/both/examples/*                   ceu-maker/ceu-maker-$(TARGETOS)/examples/both/

icos:
	mkdir -p ceu-maker/ceu-maker-$(TARGETOS)/icos/
	cp resources/both/icos/star_256.png ceu-maker/ceu-maker-$(TARGETOS)/icos/
	cp resources/both/icos/ceu-arduino.png ceu-maker/ceu-maker-$(TARGETOS)/icos/

winrar:
	resources/windows/WinRAR/WinRAR.exe a -dceu -zresources/windows/WinRAR/setup_comment.txt -ep1 -r -sfx -iiconresources/both/icos/cib_192.ico -iimgresources/both/icos/iimg.bmp releases/ceu-maker-windows.exe "./ceu-maker/ceu-maker-windows"
	
compress:
	tar --transform='s,ceu-maker/ceu-maker-ubuntu,ceu-maker,' -pcvzf releases/ceu-maker-ubuntu.tar.gz ceu-maker/ceu-maker-$(TARGETOS)/

.PHONY: clean dirs repos ceu arduino sdl pico winrar 
