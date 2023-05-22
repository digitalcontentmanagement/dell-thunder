<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:subclass="http://www.dell.com/thunder/subclass" xmlns:locales="http://www.dell.com/thunder/locales">
  <xsl:output method="html" indent="yes" encoding="utf-8" media-type="text/xml" />
  <xsl:param name="region" />

  <!-- Start of Market(s) -->
  <xsl:template match="locales:locales">
    <xsl:variable name="param_region">
      <xsl:choose>
        <xsl:when test="normalize-space($region)">
          <xsl:value-of select="$region"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'global'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="select">
      <xsl:attribute name="id">markets</xsl:attribute>
      <xsl:attribute name="multiple">multiple</xsl:attribute>
      <xsl:choose>
        <xsl:when test="normalize-space($param_region)='global'">
          <xsl:apply-templates select="locales:country">
            <xsl:sort select="locales:region" data-type="text" order="ascending" case-order="lower-first" />
            <xsl:sort select="@name" data-type="text" order="ascending" case-order="lower-first" />
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="locales:country[child::locales:region=normalize-space($param_region)]">
            <xsl:with-param name="no_of_item" select="count(locales:country[child::locales:region=normalize-space($param_region)])"/>
            <xsl:sort select="locales:region" data-type="text" order="ascending" case-order="lower-first" />
            <xsl:sort select="@name" data-type="text" order="ascending" case-order="lower-first" />
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template match="locales:country">
    <xsl:param name="no_of_item"/>
    <xsl:element name="option">
      <xsl:attribute name="value">
        <xsl:apply-templates select="locales:language">
          <xsl:with-param name="countrycode" select="@name"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="locales:alt-language">
          <xsl:with-param name="countrycode" select="@name"/>
        </xsl:apply-templates>
      </xsl:attribute>
      <xsl:if test="$no_of_item=1">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="concat(translate(locales:region, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'), ' - ', translate(@name, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'))"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="locales:language">
    <xsl:param name="countrycode"/>
    <xsl:value-of select="concat(text(),'_',$countrycode)"/>
  </xsl:template>

  <xsl:template match="locales:alt-language">
    <xsl:param name="countrycode"/>
    <xsl:value-of select="','"/>
    <xsl:apply-templates select="locales:language">
      <xsl:with-param name="countrycode" select="$countrycode"/>
    </xsl:apply-templates>
  </xsl:template>
  <!-- End of Market(s) -->

</xsl:stylesheet>

