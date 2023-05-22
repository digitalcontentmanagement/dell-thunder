<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:product="http://www.dell.com/thunder/productcategories">
  <xsl:output method="html" indent="yes" encoding="utf-8" media-type="text/xml" />

  <xsl:template match="product:categories">
	<xsl:apply-templates select="product:category">
		<xsl:sort select="@name" data-type="text" order="ascending" case-order="lower-first" />
	</xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="product:category">
	<xsl:element name="h1">
		<xsl:value-of select="@name"/>
	</xsl:element>
	<xsl:element name="table">
		<xsl:element name="thead">
			<xsl:element name="tr">
				<xsl:element name="td">Subclass Code</xsl:element>
				<xsl:element name="td">Product</xsl:element>
				<xsl:element name="td">View Content</xsl:element>
			</xsl:element>
		</xsl:element>
		<xsl:element name="tbody">
			<xsl:apply-templates select="product:subclass">
				<xsl:with-param name="categoryId" select="@id"/>
				<xsl:sort select="@description" data-type="text" order="ascending" case-order="lower-first" />
			</xsl:apply-templates>
		</xsl:element>
	</xsl:element>
  </xsl:template>

  <xsl:template match="product:subclass">
	 <xsl:param name="categoryId"/>
	<xsl:element name="tr">
		<xsl:element name="td">
			<xsl:value-of select="substring(@id, 1, 3)"/>
		</xsl:element>
		<xsl:element name="td">
			<xsl:value-of select="@description"/>
		</xsl:element>
		<xsl:element name="td">
			<!--reviewer.html?sku=SKU-ID&skutype=customer-kit&cat=accessories&scc=139&r=us&l=english-->
			<xsl:element name="a">
				<xsl:attribute name="href">
					<xsl:value-of select="concat('reviewer.html?sku=SKU-ID&amp;skutype=customer-kit&amp;cat=', $categoryId, '&amp;scc=', @folder-name, '&amp;r=us&amp;l=english')"/>
				</xsl:attribute>
				<xsl:attribute name="target">_blank</xsl:attribute>View
			</xsl:element>
		</xsl:element>
	</xsl:element>
  </xsl:template>

</xsl:stylesheet>

