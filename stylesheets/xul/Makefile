.PHONY: all clean test

all: 
	xsltproc --stringparam outdir OUTDIR app2xul.xsl bedtools.xml

test: all
	firefox -app OUTDIR/bedtools/application.ini -jsconsole  -purgecaches
	#firefox -app OUTDIR/bedtools/application.ini

clean:
	rm -rf OUTDIR

