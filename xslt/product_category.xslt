<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:product="http://www.dell.com/thunder/productcategories" xmlns:sku="http://www.dell.com/thunder/sku">
  <xsl:output method="html" indent="yes" encoding="utf-8" media-type="text/xml" />
  <xsl:param name="environment" />
  <xsl:param name="region" />
  <xsl:param name="skuid" />

  <!-- Split nodes into string separated by comma -->
  <xsl:template name="nodes-to-string">
    <xsl:param name="nodes"/>
    <xsl:for-each select="$nodes/text()">
      <xsl:value-of select="."/>
      <xsl:if test="not(position() = last())">|</xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- Start of Category -->
  <xsl:template match="product:categories">
    <xsl:variable name="selected_region">
      <xsl:choose>
        <xsl:when test="normalize-space($region)">
          <xsl:value-of select="normalize-space($region)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'global'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="sku_manifest_subclass" select="document(concat('../content',$environment,'/data/definitions/sku_manifest.xml'))/sku:manifest/sku:region[normalize-space(@name)=normalize-space($selected_region)]/sku:category/sku:sku[@id=substring($skuid,1,3)]/sku:subclass"/>
    <xsl:variable name="subclasslist">
      <xsl:call-template name="nodes-to-string">
        <xsl:with-param name="nodes" select="$sku_manifest_subclass"/>
      </xsl:call-template>
    </xsl:variable>
    <!-- Extra section node created for FireFox though under IE has duplicate -->
    <xsl:element name="section">
      <xsl:attribute name="id">category_loader</xsl:attribute>
      <xsl:element name="select">
        <xsl:attribute name="id">category</xsl:attribute>
        <xsl:attribute name="onchange">
          SubclassLoader('#subclass_loader','content<xsl:value-of select="$environment"/>/data/definitions/products.xml','xslt/product_subclass.xslt','categoryid',this,'subclasslist','<xsl:value-of select="$subclasslist"/>','subclass','- Subclass -');
        </xsl:attribute>
        <xsl:element name="option">
          <xsl:attribute name="value">- Category -</xsl:attribute>
          - Category -
        </xsl:element>
        <xsl:choose>
          <xsl:when test="$sku_manifest_subclass">
            <!-- If any sku:sku found match, identifying its category, else show all the categories -->
            <xsl:apply-templates select="product:category[@id=$sku_manifest_subclass/ancestor::sku:category/@id]">
              <xsl:with-param name="no_of_item" select="count(product:category[@id=$sku_manifest_subclass/ancestor::sku:category/@id])"/>
              <xsl:sort select="@name" data-type="text" order="ascending" case-order="lower-first" />
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="product:category">
              <xsl:sort select="@name" data-type="text" order="ascending" case-order="lower-first" />
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
      <xsl:element name="br"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="product:category">
    <xsl:param name="no_of_item"/>
    <xsl:element name="option">
      <xsl:attribute name="value">
        <xsl:apply-templates select="@id"/>
      </xsl:attribute>
      <xsl:if test="$no_of_item=1">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="@name"/>
    </xsl:element>
  </xsl:template>
  <!-- End of Category -->

</xsl:stylesheet>

