<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:product="http://www.dell.com/thunder/productcategories">
  <xsl:output method="html" indent="yes" encoding="utf-8" media-type="text/xml" />

  <xsl:template match="product:categories">
	<xsl:element name="select">
		<xsl:attribute name="id">cat</xsl:attribute>
		<xsl:attribute name="name">cat</xsl:attribute>
		<xsl:element name="option">Select</xsl:element>
		<xsl:apply-templates select="product:category">
			<xsl:sort select="@name" data-type="text" order="ascending" case-order="lower-first" />
		</xsl:apply-templates>
	</xsl:element>
  </xsl:template>
  
  <xsl:template match="product:category">
	<xsl:element name="option">
		<xsl:attribute name="value">
			<xsl:value-of select="@id"/>
		</xsl:attribute>
		<xsl:value-of select="@name"/>
	</xsl:element>
  </xsl:template>

</xsl:stylesheet>

