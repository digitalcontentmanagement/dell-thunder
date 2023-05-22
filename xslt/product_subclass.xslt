<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:product="http://www.dell.com/thunder/productcategories" xmlns:tokens="http://www.dell.com/thunder/tokens" xmlns:exslt="http://exslt.org/common" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="exslt msxsl">
  <xsl:import href="utilities.xslt"/>
  <xsl:output method="html" indent="yes" encoding="utf-8" media-type="text/xml" />
  <xsl:param name="categoryid" />
  <xsl:param name="subclasslist" />

  <!-- Start of Subclass -->
  <xsl:template match="product:categories">
    <xsl:variable name="tokens">
      <xsl:call-template name="tokenize">
        <xsl:with-param name="string" select="$subclasslist"/>
        <xsl:with-param name="pattern" select="'|'"/>
      </xsl:call-template>
    </xsl:variable>
    <!-- Extra section node created for FireFox though under IE has duplicate -->
    <xsl:element name="section">
      <xsl:attribute name="id">subclass_loader</xsl:attribute>
      <xsl:element name="select">
        <xsl:attribute name="id">subclass</xsl:attribute>
        <xsl:element name="option">
          <xsl:attribute name="value">- Subclass -</xsl:attribute>
          - Subclass -
        </xsl:element>
        <xsl:variable name="subclass" select="product:category[@id=$categoryid]/product:subclass"/>
        <xsl:choose>
          <xsl:when test="function-available('exslt:node-set')"><!-- Usually works in IE and FF or could be more browsers -->
            <!-- Subclass items in the tokens -->
            <xsl:variable name="tokens_nodeset" select="exslt:node-set($tokens)/tokens:token"/>
            <xsl:choose>
              <xsl:when test="$tokens_nodeset"><!-- SKU input triggers autoscoping for subclass, say only one or more subclass found (not all) during category control list populated -->
                <xsl:variable name="options">
                  <xsl:for-each select="$tokens_nodeset">
                    <xsl:apply-templates select="$subclass" mode="autoscoping">
                      <xsl:with-param name="token" select="text()"/>
                    </xsl:apply-templates>
                  </xsl:for-each>
                </xsl:variable>
                <xsl:apply-templates select="exslt:node-set($options)/option" mode="dropdownlist_reorder">
                  <xsl:with-param name="no_of_item" select="count(exslt:node-set($options)/option)"/>
                  <xsl:sort select="text()" data-type="text" order="ascending" case-order="lower-first" />
                </xsl:apply-templates>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="$subclass" mode="default">
                  <xsl:with-param name="no_of_item" select="count($subclass)"/>
                  <xsl:with-param name="token" select="text()"/>
                  <xsl:sort select="@description" data-type="text" order="ascending" case-order="lower-first" />
                </xsl:apply-templates>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="function-available('msxsl:node-set')"><!-- Usually works in IE only -->
            <!-- Subclass items in the tokens -->
            <xsl:variable name="tokens_nodeset" select="msxsl:node-set($tokens)/tokens:token"/>
            <xsl:choose>
              <xsl:when test="$tokens_nodeset"><!-- SKU input triggers autoscoping for subclass, say only one or more subclass found (not all) during category control list populated -->
                <xsl:variable name="options">
                  <xsl:for-each select="$tokens_nodeset">
                    <xsl:apply-templates select="$subclass" mode="autoscoping">
                      <xsl:with-param name="token" select="text()"/>
                    </xsl:apply-templates>
                  </xsl:for-each>
                </xsl:variable>
                <xsl:apply-templates select="msxsl:node-set($options)/option" mode="dropdownlist_reorder">
                  <xsl:with-param name="no_of_item" select="count(msxsl:node-set($options)/option)"/>
                  <xsl:sort select="text()" data-type="text" order="ascending" case-order="lower-first" />
                </xsl:apply-templates>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="$subclass" mode="default">
                  <xsl:with-param name="no_of_item" select="count($subclass)"/>
                  <xsl:with-param name="token" select="text()"/>
                  <xsl:sort select="@description" data-type="text" order="ascending" case-order="lower-first" />
                </xsl:apply-templates>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
        </xsl:choose>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- Scoping down the list -->
  <xsl:template match="product:subclass" mode="autoscoping">
    <xsl:param name="token"/>
    <xsl:if test="@id=$token">
      <xsl:element name="option">
        <xsl:attribute name="value">
          <xsl:value-of select="concat(@id,'_',@folder-name)"/>
        </xsl:attribute>
        <xsl:value-of select="@description"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <!-- Default: Loading all into the list -->
  <xsl:template match="product:subclass" mode="default">
    <xsl:param name="no_of_item"/>
    <xsl:element name="option">
      <xsl:attribute name="value">
        <xsl:value-of select="concat(@id,'_',@folder-name)"/>
      </xsl:attribute>
      <xsl:if test="$no_of_item=1">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="@description"/>
    </xsl:element>
  </xsl:template>
  <!-- End of Subclass -->
  
  <!-- Start of Reordering Autoscoping List -->
  <xsl:template match="option" mode="dropdownlist_reorder">
    <xsl:param name="no_of_item"/>
    <xsl:element name="{local-name()}" namespace="{namespace-uri(current())}">
      <xsl:if test="$no_of_item=1">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:for-each select="@*">
          <xsl:attribute name="{name(.)}">
            <xsl:value-of select="."/>
          </xsl:attribute>
      </xsl:for-each>
      <xsl:value-of select="text()"/>
    </xsl:element>
  </xsl:template>
  <!-- End of Reordering Autoscoping List -->
  
</xsl:stylesheet>

