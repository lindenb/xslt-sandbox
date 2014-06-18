<?xml version='1.0'  encoding="UTF-8" ?>
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	version='1.0'
	>


<xsl:output method="text" encoding="UTF-8"/>

<xsl:variable name="year0" select="//table[1]/tr[1]/td[2]/text()"/>
<xsl:variable name="zone0" select="//table[1]/tr[3]/td[2]/text()"/>

<xsl:variable name="year" select="//input[@name='curr_year']/@value"/>
<xsl:variable name="zone" select="//input[@name='CODE_GEO']/@value"/>

<xsl:template match="/">

insert into region(id,name) values (11 ,"Ile de France");
insert into region(id,name) values (21 ,"Champagne");
insert into region(id,name) values (22 ,"Picardie");
insert into region(id,name) values (23 ,"Haute-Normandie");
insert into region(id,name) values (24 ,"Centre");
insert into region(id,name) values (25 ,"Basse-Normandie");
insert into region(id,name) values (26 ,"Bourgogne");
insert into region(id,name) values (31 ,"Nord-Pas-De-Calais");
insert into region(id,name) values (41 ,"Lorraine");
insert into region(id,name) values (42 ,"Alsace");
insert into region(id,name) values (43 ,"Franche-Comte");
insert into region(id,name) values (52 ,"Pays de Loire");
insert into region(id,name) values (53 ,"Bretagne");
insert into region(id,name) values (54 ,"Poitou-Charentes");
insert into region(id,name) values (72 ,"Aquitaine");
insert into region(id,name) values (73 ,"Midi-Pyrenees");
insert into region(id,name) values (74 ,"Limousin");
insert into region(id,name) values (82 ,"Rhone-Alpes");
insert into region(id,name) values (83 ,"Auvergne");
insert into region(id,name) values (91 ,"Languedoc-Roussillon");
insert into region(id,name) values (93 ,"Provence Alpes Côte d azur");
insert into region(id,name) values (94 ,"Corse");
insert into region(id,name) values (97 ,"Départements d'Outre Mer");

zone:<xsl:value-of select="$zone"/>

<xsl:value-of select="//table[3]"/>

<xsl:apply-templates select="//table[@cellspacing]"/>
end
</xsl:template>

<xsl:template match="table">
<xsl:for-each select="tr[1]/td">
<xsl:if test="position() &gt; 4">
insert into category(id,label) values (<xsl:value-of select="position()"/>,'<xsl:choose>
<xsl:when test="position()=5">&lt;1</xsl:when>
<xsl:otherwise><xsl:value-of select="normalize-space(.)"/></xsl:otherwise>
</xsl:choose>');
</xsl:if>
</xsl:for-each>

<xsl:apply-templates select="tr"/>
</xsl:template>


<xsl:template match="tr">
<xsl:variable name="thead" select="../tr[1]"/>
<xsl:if test="count(preceding-sibling::tr) mod 3 = 1  and count(following-sibling::tr)&gt;5">
 

insert into disease(label) values ('<xsl:value-of select="normalize-space(td[2])"/>');

<xsl:for-each select="td">
<xsl:if test="position() &gt; 4">
<xsl:variable name="col" select="position()"/>

insert into data(year,region,gender,category,count) values (<xsl:value-of select="$year"/>,<xsl:value-of select="$zone"/>,'M',<xsl:value-of select="$col"/>,<xsl:value-of select="normalize-space(.)"/>);

</xsl:if>
</xsl:for-each>



<xsl:for-each select="following::tr[1]/td">
<xsl:if test="position() &gt; 2">
<xsl:variable name="col" select="position()+2"/>

insert into data(year,region,gender,category,count) values (<xsl:value-of select="$year"/>,<xsl:value-of select="$zone"/>,'F',<xsl:value-of select="$col"/>,<xsl:value-of select="normalize-space(.)"/>);

</xsl:if>
</xsl:for-each>



</xsl:if>
</xsl:template>

</xsl:stylesheet>
