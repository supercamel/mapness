LIBDIR=/usr/lib
INCDIR=/usr/include
VAPIDIR=/usr/share/vala/vapi
TYPELIBDIR=/usr/lib/girepository-1.0

CC=valac
VERSION=0.1
LIBRARY=mapness

CFLAGS= --library=$(LIBRARY)-$(VERSION) -H $(LIBRARY).h --pkg gee-0.8 --pkg gtk+-3.0 --pkg libsoup-2.4 --pkg glib-2.0 --gir=$(LIBRARY)-$(VERSION).gir
SOURCES=$(wildcard src/*.vala)

all:
	$(CC) $(CFLAGS) $(SOURCES) -X -fPIC -X -shared -o lib$(LIBRARY)-$(VERSION).so

clean:
	rm -f *.gir *.typelib *.dll *.vapi *.tmp *.h *.so
	rm src/*.c
	rm -rfd docs

install:
	cp lib$(LIBRARY)-$(VERSION).so $(LIBDIR)
	cp $(LIBRARY).h $(INCDIR)
	cp $(LIBRARY)-$(VERSION).vapi $(VAPIDIR)
	cp $(LIBRARY)-$(VERSION).typelib $(TYPELIBDIR)

c:
	$(CC) -C $(CFLAGS) $(SOURCES)

typelib:
	g-ir-compiler --shared-library=lib$(LIBRARY)-$(VERSION).so --output=$(LIBRARY)-$(VERSION).typelib $(LIBRARY)-$(VERSION).gir

docs:
	valadoc -o docs --pkg gee-0.8 --pkg gtk+-3.0 --pkg libsoup-2.4 --pkg glib-2.0 --package-name $(LIBRARY) $(SOURCES)
