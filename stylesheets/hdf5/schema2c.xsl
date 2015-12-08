<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:import href="../util/util.xsl"/>
<xsl:output method="text"/>


<xsl:template match="/">
 <xsl:apply-templates select="schema"/>
</xsl:template>

<xsl:template match="schema">
/**
<xsl:value-of select="$mit.license"/>
*/

#include "hdf5.h"
#include &lt;stdio.h&gt;
#include &lt;stdlib.h&gt;
#include &lt;stdint.h&gt;
#include &lt;string.h&gt;
#include &lt;ctype.h&gt;
#include &lt;unistd.h&gt;
#include &lt;errno.h&gt;
#include &lt;getopt.h&gt;

#define M2G_VERSION "1.0"

<xsl:apply-templates select="class"/>

static void usage(FILE* out) {
	}

int main(int argc,char** argv)
	{
	<xsl:choose>
	<xsl:when test="count(class)=1">
	if(argc==1)
		{
		usage(stderr);
		return EXIT_FAILURE;
		}
	<xsl:for-each select="class">
	<xsl:if test="position()&gt;1"> else </xsl:if> if(strcmp("<xsl:apply-templates select="." mode="name"/>",argv[1])==0) {
		return <xsl:apply-templates select="." mode="handler"/>Main(argc-1,&amp;argv[1])
		}
	</xsl:for-each>
	else
		{
		fprintf(stderr,"Unknown class \"%s\". Available are <xsl:for-each select="class">'<xsl:apply-templates select="." mode="name"/>' </xsl:for-each> ",argv[1]);
		
		return EXIT_FAILURE;
		}
	</xsl:when>
	<xsl:otherwise>
	return <xsl:apply-templates select="class[1]" mode="handler"/>Main(argc-1,&amp;argv[1])
	</xsl:otherwise>
	</xsl:choose>
	}
	
</xsl:template>


<xsl:template match="class">

<xsl:variable name="className">
  <xsl:apply-templates select="." mode="name"/>
</xsl:variable>

<xsl:variable name="classPtr">
<xsl:value-of select="concat($className,'Ptr')"/>
</xsl:variable>


/** structure holding content of <xsl:value-of select="@name"/> */
typedef struct  <xsl:value-of select="$className"/>
	{
	<xsl:apply-templates select="property" mode="struct.field"/>
	} <xsl:value-of select="$className"/>,*<xsl:apply-templates select="." mode="ptr"/>;

/** Handler for <xsl:value-of select="@name"/> */
typedef struct  <xsl:apply-templates select="." mode="handler"/>
	{
	/* compound datatype for memory */
	hid_t compound_mem_id;
	/* compound datatype for file */
	hid_t compound_file_id;
	<xsl:for-each select="property[@type='string']">
	/* <xsl:value-of select="@name"/> is a string */
	hid_t  <xsl:apply-templates select="." mode="variable.handler"/>_copy;
	hid_t  <xsl:apply-templates select="." mode="variable.handler"/>;
	</xsl:for-each>
	}<xsl:apply-templates select="." mode="handler"/>;

/** Initialize <xsl:apply-templates select="." mode="handler"/> */
static <xsl:apply-templates select="." mode="handler"/>* <xsl:apply-templates select="." mode="handler"/>Init()
	{
	herr_t status;
	<xsl:apply-templates select="." mode="handler"/>* ptr=(<xsl:apply-templates select="." mode="handler"/>*)malloc(sizeof(<xsl:apply-templates select="." mode="handler"/>*));
	if(ptr==NULL) return NULL;
	<xsl:for-each select="property">
		<xsl:choose>
		  <xsl:when test="@type='string'">
		    /* initialize <xsl:value-of select="@name"/> which is a string */
		    ptr-&gt;<xsl:apply-templates select="." mode="variable.handler"/>_copy = H5Tcopy (H5T_C_S1);
		  	ptr-&gt;<xsl:apply-templates select="." mode="variable.handler"/> = H5Tset_size (ptr-&gt;<xsl:apply-templates select="." mode="variable.handler"/>_copy, H5T_VARIABLE);
		  </xsl:when>
		</xsl:choose>
	</xsl:for-each>
	
	/* Create the compound datatype for memory */
	ptr->compound_mem_id = H5Tcreate (H5T_COMPOUND, sizeof (<xsl:apply-templates select="." mode="name"/>));
	<xsl:apply-templates select="property" mode="compound.mem.insert"/>
	ptr->compound_file_id = H5Tcreate (H5T_COMPOUND,0<xsl:for-each select="property">
		<xsl:text> + </xsl:text>
		<xsl:apply-templates select="." mode="file.sizeof"/>
		</xsl:for-each>);
	<xsl:apply-templates select="property" mode="compound.file.insert"/>	
	return ptr;
	}

/** Dispose <xsl:apply-templates select="." mode="handler"/> */
static void <xsl:apply-templates select="." mode="handler"/>Dispose(<xsl:apply-templates select="." mode="handler"/>* ptr)
	{
	herr_t status;
	if(ptr==NULL) return;
	
	<xsl:for-each select="property[@type='string']">
	/* <xsl:value-of select="@name"/> is a string */
	status = H5Tclose(ptr-&gt;<xsl:apply-templates select="." mode="variable.handler"/>);
	status = H5Tclose(ptr-&gt;<xsl:apply-templates select="." mode="variable.handler"/>_copy);
	</xsl:for-each>
	
	/* dispose compound */
	status = H5Tclose (ptr->compound_mem_id);
	status = H5Tclose (ptr->compound_file_id);
	free(ptr);
	}

#ifdef XXX
static  <xsl:value-of select="$classPtr"/>
<xsl:text> </xsl:text> <xsl:value-of select="$className"/>Read(FILE* in)
	{
	
	size_t len=0UL;
	char* s;
	char delim=',';
	int c;
	<xsl:value-of select="$classPtr"/> data=NULL;
	if(feof(in)) return NULL;
	
	data = (<xsl:value-of select="$classPtr"/>)malloc(sizeof(<xsl:value-of select="$className"/>));
	
	<xsl:for-each select="property">
	<xsl:if test="position()&gt;1">
	for(;;)
		{
		c=fgetc(in);
		if(c!=delim &amp;&amp; isspace(c)) continue;
		if( c== delim) break;
		fprintf(stderr,"Boum");
		exit(EXIT_FAILURE);
		}
	</xsl:if>
	/* read field <xsl:value-of select="@name"/> */
	<xsl:choose>
		<xsl:when test="@type='int32_t'">
		if(fscanf(in, "%d", &amp;(data-&gt;<xsl:value-of select="@name"/>))!=1)
			{
			
			}
		</xsl:when>
		<xsl:when test="@type='string'">
		s = (char*)malloc(1);
		s[0]=0;
		len = 0UL;
		for(;;)
			{
			c=fgetc(in);
			if(c==delim || c=='\n' || c==EOF)
				{
				ungetc(c,in);
				break;
				}
			s = (char*)realloc(s,sizeof(char)*(len+2));
			s[len]=c;
			s[len+1]=0;
			++len;
			}
		data-&gt;<xsl:value-of select="@name"/> = s;
		s= NULL;
		</xsl:when>
	</xsl:choose>
	</xsl:for-each>
	
	for(;;)
		{
		c=fgetc(in);
		if( c== delim) continue;
		if( c== EOF) break;
		if( c=='\n') break;
		fprintf(stderr,"Boum");
		exit(EXIT_FAILURE);
		}
	
	return data;
	}
#endif

/** write an item for <xsl:value-of select="@name"/> */
static void <xsl:value-of select="$className"/>Write(FILE* out,<xsl:value-of select="$classPtr"/> data)
	{
	char delim='\t';
	<xsl:for-each select="property">
	<xsl:if test="position()&gt;1">
	/* write delimiter */
	fputc(delim,out);
	</xsl:if>
	/* write field <xsl:value-of select="@name"/> */
	<xsl:choose>
		<xsl:when test="@type='int32_t'">
            fprintf(out,"%d",data-&gt;<xsl:value-of select="@name"/>);
		</xsl:when>
		<xsl:when test="@type='string'">
            fputs(data-&gt;<xsl:value-of select="@name"/>,out);
		</xsl:when>
	</xsl:choose>
	</xsl:for-each>
	/* write EOL */
	fputc('\n',out);
	}


	
static void <xsl:value-of select="$className"/>InsertFile()
	{
	<xsl:for-each select="class">
	<xsl:apply-templates select="." mode="handler"/>* <xsl:value-of select="generate-id(.)"/> = <xsl:apply-templates select="." mode="handler"/>Init();
	</xsl:for-each>
	int status;
	hid_t filetype,file,memtype;
	h5file = H5Fcreate (h5filename, H5F_ACC_TRUNC, H5P_DEFAULT, H5P_DEFAULT);
	hsize_t   dims[1] = {0};
	hid_t space = H5Screate_simple (1, dims, NULL);
	hid_t dset = H5Dcreate(h5file, h5datasetname, H5P_DEFAULT, H5P_DEFAULT, H5P_DEFAULT);
	size_t n=0UL;
	<xsl:apply-templates select="." mode="ptr"/>* array = NULL;
	for(;;)
		{
		<xsl:apply-templates select="class[1]" mode="ptr"/> item =  <xsl:apply-templates select="class[1]" mode="handler"/>Read(stdin);
		if(item == NULL || n==1024)
			{
			if(n>0)
				{
				hsize_t   dims2[1] = {n};
				H5Dextend(space,dims);
				status = H5Dwrite (dset, memtype, H5S_ALL, H5S_ALL, H5P_DEFAULT, array);
				}
			if(item==NULL) break;
			n=0;
			}
		array = (<xsl:apply-templates select="class[1]" mode="ptr"/>*)realloc(array,sizeof(<xsl:apply-templates select="class[1]" mode="ptr"/>)*(n+1));
		}
	
	
	
	
	status = H5Fclose (dset);
	status = H5Fclose (space);
	status = H5Fclose (file);
	<xsl:for-each select="class">
	<xsl:apply-templates select="." mode="handler"/>Dispose(<xsl:value-of select="generate-id(.)"/>);
	</xsl:for-each>
	}

static void <xsl:apply-templates select="." mode="handler"/>Usage(FILE* out)
	{
	
	}

#ifdef XXX

/**
 *
 * main for "<xsl:value-of select="$className"/>"
 *
 */
static int <xsl:apply-templates select="." mode="handler"/>Main(int argc,char** argv)
	{
	hid_t h5file;
	char* h5filename = NULL;
	char* h5datasetname = NULL;

	for(;;)
		{
		static struct option long_options[] =
		     {
		     {"h5file",   no_argument, 0, 'f'},
		     {"dataset",   no_argument, 0, 'p'},
			 {"help",   no_argument, 0, 'h'},
			 {"version",   no_argument, 0, 'v'},
		       {0, 0, 0, 0}
		     };
		int option_index = 0;
		int c = getopt_long (argc, argv, "hvp:",
		                    long_options, &amp;option_index);
		if (c == -1) break;
		switch (c)
		   	{
			case 'v': printf("%s\n",M2G_VERSION); return EXIT_SUCCESS;
			case 'f': h5filename = optarg; break;
			case 'p': h5datasetname = optarg; break;
		   	case 'h': usage(stdout); return EXIT_SUCCESS;
			case '?':
		       		fprintf (stderr, "Unknown option `-%c'.\n", optopt);
		       		return EXIT_FAILURE;
	   	    default:
	   	        	fprintf (stderr, "Bad input.\n");
		       		return EXIT_FAILURE;
			}
		}
	
	
	return EXIT_SUCCESS;
	}
#endif

/**
 *
 * main for "<xsl:value-of select="$className"/>"
 *
 */
static int <xsl:apply-templates select="." mode="handler"/>Main(int argc,char** argv)
	{
	hid_t h5file;
	char* h5filename = NULL;
	char* h5datasetname = NULL;

	for(;;)
		{
		static struct option long_options[] =
		     {
		     {"h5file",   no_argument, 0, 'f'},
		     {"dataset",   no_argument, 0, 'p'},
			 {"help",   no_argument, 0, 'h'},
			 {"version",   no_argument, 0, 'v'},
		       {0, 0, 0, 0}
		     };
		int option_index = 0;
		int c = getopt_long (argc, argv, "hvp:",
		                    long_options, &amp;option_index);
		if (c == -1) break;
		switch (c)
		   	{
			case 'v': printf("%s\n",M2G_VERSION); return EXIT_SUCCESS;
			case 'f': h5filename = optarg; break;
			case 'p': h5datasetname = optarg; break;
		   	case 'h': usage(stdout); return EXIT_SUCCESS;
			case '?':
		       		fprintf (stderr, "Unknown option `-%c'.\n", optopt);
		       		return EXIT_FAILURE;
	   	    default:
	   	        	fprintf (stderr, "Bad input.\n");
		       		return EXIT_FAILURE;
			}
		}
	
	
	return EXIT_SUCCESS;
	}


</xsl:template>





<xsl:template match="property">

</xsl:template>

<xsl:template match="property" mode="struct.field">
<xsl:choose>
	<xsl:when test="@type='int32_t'">int32_t</xsl:when>
	<xsl:when test="@type='string'">char*</xsl:when>
	<xsl:otherwise><xsl:message terminate="yes">Unknow handler.field</xsl:message></xsl:otherwise>
 </xsl:choose>
 <xsl:text>	</xsl:text>
 <xsl:value-of select="@name"/>
 <xsl:text> ;
 </xsl:text>
</xsl:template>

<xsl:template match="property" mode="handler.field">
<xsl:choose>
	<xsl:when test="@type='string'"> hid_t <xsl:apply-templates select="." mode="variable.handler"/>;</xsl:when>
	<xsl:otherwise></xsl:otherwise>
 </xsl:choose>
</xsl:template>


<xsl:template match="property" mode="compound.mem.insert">
   /* insert <xsl:value-of select="@name"/> */
  status = H5Tinsert (
  			ptr->compound_mem_id,
    		<xsl:apply-templates select="." mode="label"/>,
            HOFFSET(<xsl:apply-templates select=".." mode="name"/>,<xsl:value-of select="@name"/>),
            <xsl:apply-templates select="." mode="h5.mem.type"/>
            );
</xsl:template>


<xsl:template match="property" mode="compound.file.insert">
  /* insert <xsl:value-of select="@name"/> */
  status = H5Tinsert (
  			ptr->compound_file_id,
    		<xsl:apply-templates select="." mode="label"/>,
            0 <xsl:for-each select="preceding-sibling::property">
				<xsl:text> + </xsl:text>
				<xsl:apply-templates select="." mode="file.sizeof"/>
			</xsl:for-each>,
			<xsl:apply-templates select="." mode="h5.file.type"/>
            );
</xsl:template>

<xsl:template match="property" mode="h5.mem.type">
<xsl:choose>
	<xsl:when test="@type='int32_t'">H5T_NATIVE_INT</xsl:when>
	<xsl:when test="@type='string'">ptr-&gt;<xsl:apply-templates select="." mode="variable.handler"/></xsl:when>
	<xsl:otherwise><xsl:message terminate="yes">Unknow h5.type</xsl:message></xsl:otherwise>
 </xsl:choose>
</xsl:template>


<xsl:template match="property" mode="file.sizeof">
<xsl:choose>
	<xsl:when test="@type='int32_t'">8</xsl:when>
	<xsl:when test="@type='string'">sizeof(hvl_t)</xsl:when>
	<xsl:otherwise><xsl:message terminate="yes">Unknow file.sizeof</xsl:message></xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="property" mode="h5.file.type">
<xsl:choose>
	<xsl:when test="@type='int32_t'">H5T_STD_I64BE</xsl:when>
	<xsl:when test="@type='string'">ptr-&gt;<xsl:apply-templates select="." mode="variable.handler"/></xsl:when>
	<xsl:otherwise><xsl:message terminate="yes">Unknow h5.type</xsl:message></xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="property" mode="variable.type">
<xsl:choose>
	<xsl:when test="@type='string'"><xsl:value-of select="concat(generate-id(.),'_type')"/></xsl:when>
	<xsl:otherwise><xsl:message terminate="yes">Unknow h5.type</xsl:message></xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="property" mode="variable.handler">
<xsl:choose>
	<xsl:when test="@type='string'"><xsl:value-of select="concat(../@name,'_',@name,'_type')"/></xsl:when>
	<xsl:otherwise><xsl:message terminate="yes">variable.handler illegal state</xsl:message></xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="property" mode="label">
<xsl:text>"</xsl:text>
<xsl:choose>
	<xsl:when test="@label"><xsl:value-of select="@label"/></xsl:when>
	<xsl:otherwise><xsl:value-of select="@name"/></xsl:otherwise>
</xsl:choose>
<xsl:text>"</xsl:text>
</xsl:template>

<xsl:template match="class" mode="name">
  <xsl:call-template name="titleize">
  	<xsl:with-param name="s" select="@name"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="class" mode="ptr">
  <xsl:apply-templates select="." mode="name"/>
  <xsl:text>Ptr</xsl:text>
</xsl:template>

<xsl:template match="class" mode="handler">
  <xsl:apply-templates select="." mode="name"/>
  <xsl:text>Handler</xsl:text>
</xsl:template> 
 
</xsl:stylesheet>
