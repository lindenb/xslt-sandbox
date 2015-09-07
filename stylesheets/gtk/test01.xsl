<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:import href="mod.gtk.xsl"/>
<xsl:output method="text"/>


<xsl:template match="/">
#include &lt;gtk/gtk.h&gt;

int main( int   argc,
          char *argv[] )
{
gtk_init (&amp;argc, &amp;argv);
<xsl:apply-templates select="*"/>
 gtk_main ();
 return 0;
}
</xsl:template>

</xsl:stylesheet>
