<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:image="http://www.dell.com/thunder/imagebase">
  <xsl:include href="utilities.xslt"/>
  <xsl:output method="html" indent="yes" encoding="utf-8" media-type="text/xml" />
  <xsl:param name="categoryid"/>
  <xsl:param name="foldername"/>

  <xsl:template match="image:imagebase">
    <xsl:element name="div">
      <xsl:attribute name="id">album</xsl:attribute>
      <xsl:choose>
        <xsl:when test="image:folder[@name=$categoryid][last()]">
          <!-- Start of Result -->
          <xsl:variable name="output">
            <xsl:apply-templates select="image:folder[@name=$categoryid][last()]"/>
          </xsl:variable>
          <xsl:variable name="has_elements">
            <xsl:call-template name="contains-elements">
              <xsl:with-param name="nodes" select="$output"/>
            </xsl:call-template>
          </xsl:variable>
          <!-- End of Result -->
          <xsl:choose>
            <xsl:when test="(normalize-space($output) and string($output)) or (normalize-space($has_elements)='true')">
              <xsl:copy-of select="$output"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:element name="span">
                <xsl:attribute name="class">message</xsl:attribute>
                No image available for this product.
              </xsl:element>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:element name="span">
            <xsl:attribute name="class">message</xsl:attribute>
            Your imagebase category ID does not match your selected category ID.
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template match="image:folder">
    <xsl:param name="category_id"/>
    <xsl:param name="folder_name"/>
    <xsl:apply-templates select="image:image">
      <xsl:with-param name="category_id" select="$categoryid"/>
      <xsl:with-param name="folder_name" select="$folder_name"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="image:folder[@name=$foldername][last()]">
      <xsl:with-param name="category_id" select="$categoryid"/>
      <xsl:with-param name="folder_name" select="$foldername"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="image:image">
    <xsl:param name="category_id"/>
    <xsl:param name="folder_name"/>
    <xsl:variable name="source">
      <xsl:choose>
        <xsl:when test="normalize-space($folder_name)">
          <xsl:value-of select="concat('images/products/', $category_id, '/', $folder_name, '/', image:location,'.',image:type)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('images/products/', $category_id, '/', image:location,'.',image:type)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="normalize-space($source)"/>
      </xsl:attribute>
      <xsl:attribute name="target">_new</xsl:attribute>
      <xsl:element name="img">
        <xsl:attribute name="src">
          <xsl:value-of select="normalize-space($source)"/>
        </xsl:attribute>
        <xsl:attribute name="width">100</xsl:attribute>
        <xsl:attribute name="height">100</xsl:attribute>
        <xsl:attribute name="title">
          <xsl:choose>
            <xsl:when test="normalize-space(image:caption)">
              <xsl:value-of select="image:caption"/>
            </xsl:when>
            <xsl:otherwise>
              No caption defined
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="onerror">this.src='images/puzzle-big.png';this.title='Image not found';this.parentNode.href='javascript:function() { return false; }';</xsl:attribute>
      </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>

