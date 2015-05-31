CC = g++
CFLAGS = -g -I./include
LDFLAGS = `fltk-config --ldflags --use-images` `fltk-config --cxxflags --use-images` -lbass64 -L./lib
PROG = build/linux/bplay.bin
OBJS = build/linux/play.o build/linux/stations.o build/linux/gui.o
WINFLAGS = -I/usr/local/include -DWIN32 -DUSE_OPENGL32 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -L/usr/local/lib -mwindows -lfltk_images -lpng -lz -ljpeg -lfltk -lole32 -luuid -lcomctl32 -lbass

all: bplay.bin

bplay.bin: gui.o play.o stations.o
	${CC} $(OBJS) -o $(PROG) ${CFLAGS} ${LDFLAGS} 
	cp lib/*.so data/*.png build/linux/

gui.o:
	${CC} ${CFLAGS} -c src/gui.cxx -o build/linux/gui.o

play.o:
	${CC} ${CFLAGS} -c src/play.cxx -o build/linux/play.o

stations.o:
	${CC} ${CFLAGS} -c src/stations.cxx -o build/linux/stations.o

clean: 
	rm -f build/linux/*

win: 
	${CC} -o 'build/windows/bplay.exe' 'src/gui.cxx' 'src/play.cxx' 'src/stations.cxx' ${WINFLAGS} 
	cp lib/*.dll build/windows/

bundle:
	make install DESTDIR=/tmp/1
	mksquashfs /tmp/1 bplay.sb -noappend
	make clean
	rm -r /tmp/1

install: all
	install -Dm755 data/bplay $(DESTDIR)/usr/bin/bplay
	install -Dm644 data/bplay.desktop $(DESTDIR)/usr/share/applications/bplay.desktop
	install -Dm755 build/linux/bplay.bin $(DESTDIR)/usr/share/bplay/bplay.bin
	install -Dm644 build/linux/bplay.png $(DESTDIR)/usr/share/bplay/bplay.png
	install -Dm644 build/linux/libbass64.so $(DESTDIR)/usr/share/bplay/libbass64.so
	install -d $(DESTDIR)/usr/share/icons/hicolor/64x64/apps
	ln -sf ../../../../bplay/bplay.png $(DESTDIR)/usr/share/icons/hicolor/64x64/apps/bplay.png 

uninstall:
	rm $(DESTDIR)/usr/bin/bplay
	rm $(DESTDIR)/usr/share/applications/bplay.desktop
	rm -r $(DESTDIR)/usr/share/bplay
	rm $(DESTDIR)/usr/share/icons/hicolor/64x64/apps/bplay.png 

