
jtidy.libs  =  \
	$(lib.dir)/net/sf/jtidy/jtidy/r938/jtidy-r938.jar


xalan.libs  = \
	$(lib.dir)/xalan/serializer/2.7.2/serializer-2.7.2.jar \
	$(lib.dir)/xalan/xalan/2.7.2/xalan-2.7.2.jar \
	$(lib.dir)/xml-apis/xml-apis/1.3.04/xml-apis-1.3.04.jar

emf.core.jars=\
	$(lib.dir)/org/eclipse/emf/org.eclipse.emf.ecore/2.11.1-v20150805-0538/org.eclipse.emf.ecore-2.11.1-v20150805-0538.jar \
	$(lib.dir)/org/eclipse/emf/org.eclipse.emf.common/2.11.0-v20150805-0538/org.eclipse.emf.common-2.11.0-v20150805-0538.jar

velocity.jars  =  \
	$(lib.dir)/commons-collections/commons-collections/3.2.1/commons-collections-3.2.1.jar \
	$(lib.dir)/commons-lang/commons-lang/2.4/commons-lang-2.4.jar \
	$(lib.dir)/org/apache/velocity/velocity/1.7/velocity-1.7.jar

all_maven_jars = $(sort  ${xalan.libs} ${jtidy.libs} ${emf.core.jars} ${velocity.jars})

${all_maven_jars}  : 
	mkdir -p $(dir $@) && wget -O "$@" "http://central.maven.org/maven2/$(patsubst ${lib.dir}/%,%,$@)"

