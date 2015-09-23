all: jeter.c
	g++ -Wall `pkg-config --cflags gtk+-3.0` $<  `pkg-config --libs gtk+-3.0`
	./a.out

jeter.c:  test01.xsl test01.xml
	xsltproc test01.xsl test01.xml > $@

x: jeter2.c
	g++ -Wall `pkg-config --cflags gtk+-3.0` $<  `pkg-config --libs gtk+-3.0`
	./a.out
