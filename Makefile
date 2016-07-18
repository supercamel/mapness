CC=valac
VERSION=0.1
LIBRARY=mapness

LIBDIR=/usr/lib
INCDIR=/usr/include
VAPIDIR=/usr/share/vala/vapi
TYPELIBDIR=/usr/lib/girepository-1.0

CFLAGS= --library=$(LIBRARY) -H $(LIBRARY).h --pkg gtk+-3.0 --pkg libsoup-2.4 --pkg glib-2.0 --gir=$(LIBRARY)-$(VERSION).gir
SOURCES=$(wildcard src/*.vala)

all:
	$(CC) $(CFLAGS) $(SOURCES) -X -fPIC -X -shared -o lib$(LIBRARY).so
	g-ir-compiler --shared-library=lib$(LIBRARY).so --output=$(LIBRARY)-$(VERSION).typelib $(LIBRARY)-$(VERSION).gir

clean:
	rm -f *.gir *.typelib *.so *.vapi *.tmp *.h

install:
	sudo cp lib$(LIBRARY).so $(LIBDIR)
	sudo cp $(LIBRARY).h $(INCDIR)
	sudo cp $(LIBRARY).vapi $(VAPIDIR)
	sudo cp $(LIBRARY)-$(VERSION).typelib $(TYPELIBDIR)
