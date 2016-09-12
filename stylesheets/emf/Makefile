EMPTY :=
SPACE := $(EMPTY) $(EMPTY)
lib.dir=../../xalan/maven

all:test
include ../../xalan/maven.mk



test: ${emf.core.jars} ${velocity.jars}
	xsltproc model2java.xsl test-model-01.xml  > Jeter.java
	javac -cp $(subst ${SPACE},:,${emf.core.jars} ${velocity.jars}) Jeter.java
	java -cp $(subst ${SPACE},:,${emf.core.jars} ${velocity.jars}):. Jeter
