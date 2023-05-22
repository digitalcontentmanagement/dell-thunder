<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:product="http://www.dell.com/thunder/productcategories">
  <xsl:output method="html" indent="yes" encoding="utf-8" media-type="text/xml" />
  <xsl:param name="categoryId"/>

  <xsl:template match="product:categories">
	<xsl:choose>
		<xsl:when test="normalize-space($categoryId)">
			<xsl:apply-templates select="product:category[@id=$categoryId]"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:element name="select">
				<xsl:attribute name="id">scc</xsl:attribute>
				<xsl:attribute name="name">scc</xsl:attribute>
				<xsl:attribute name="disabled">disabled</xsl:attribute>
				<xsl:element name="option">Select</xsl:element>
			</xsl:element>
		</xsl:otherwise>
	</xsl:choose>
  </xsl:template>
  
  <xsl:template match="product:category">
	<xsl:element name="select">
		<xsl:attribute name="id">scc</xsl:attribute>
		<xsl:attribute name="name">scc</xsl:attribute>
		<xsl:element name="option">Select</xsl:element>
		<xsl:apply-templates select="product:subclass">
			<xsl:with-param name="no_of_item" select="count(product:subclass)"/>
			<xsl:sort select="@description" data-type="text" order="ascending" case-order="lower-first" />
		</xsl:apply-templates>
	</xsl:element>
  </xsl:template>

  <xsl:template match="product:subclass">
	<xsl:param name="no_of_item"/>
	<xsl:element name="option">
		<xsl:attribute name="value">
			<xsl:value-of select="@folder-name"/>
		</xsl:attribute>
		<xsl:if test="$no_of_item=1">
			<xsl:attribute name="selected">selected</xsl:attribute>
        </xsl:if>
		<xsl:value-of select="concat(@description, ' [', substring(@id, 1, 3), ']')"/>
	</xsl:element>
  </xsl:template>

</xsl:stylesheet>

