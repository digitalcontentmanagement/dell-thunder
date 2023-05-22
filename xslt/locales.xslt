<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:content="http://www.dell.com/thunder/content" xmlns:stringtable="http://www.dell.com/thunder/stringtable" xmlns:locales="http://www.dell.com/thunder/locales" xmlns:tokens="http://www.dell.com/thunder/tokens" xmlns:exslt="http://exslt.org/common" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="exslt msxsl">
  <xsl:import href="utilities.xslt"/>

  <xsl:template match="content:stringlookup">
    <!-- Internal code usage only for XSLT -->
    <xsl:param name="environment"/>
    <!-- Internal code usage only for XSLT (Usually both country and language values must together) -->
    <xsl:param name="country"/>
    <!-- Internal code usage only for XSLT (Usually both country and language values must together) -->
    <xsl:param name="language"/>
    <!-- Internal code usage only for XSLT -->
    <xsl:param name="region"/>
    <!-- Internal code usage only for XSLT -->
    <xsl:param name="skutype"/>
    <!-- Internal code usage only for XSLT -->
    <xsl:param name="skuid"/>

    <xsl:variable name="this_region">
      <xsl:variable name="default_region" select="document(concat('../content',$environment,'/data/definitions/locales.xml'))/locales:locales/locales:country[@name=$country][locales:language=$language]/locales:region"/>
      <xsl:variable name="alt_language_region" select="document(concat('../content',$environment,'/data/definitions/locales.xml'))/locales:locales/locales:country[@name=$country][locales:alt-language/locales:language=$language]/locales:region"/>
      <xsl:choose>
        <xsl:when test="normalize-space($region)">
          <!-- Internal value -->
          <xsl:value-of select="$region"/>
        </xsl:when>
        <xsl:when test="normalize-space($default_region)">
          <xsl:value-of select="$default_region"/>
        </xsl:when>
        <xsl:when test="normalize-space($alt_language_region)">
          <xsl:value-of select="$alt_language_region"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'global'"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Defaulted to English locales -->
    <xsl:variable name="default_language" select="'english'"/>

    <xsl:variable name="source">
      <xsl:choose>
        <xsl:when test="normalize-space(@localefile)">
          <xsl:value-of select="normalize-space(@localefile)"/>
        </xsl:when>
        <xsl:when test="normalize-space($country) and normalize-space($language)">
          <xsl:variable name="default" select="document(concat('../content',$environment,'/data/definitions/locales.xml'))/locales:locales/locales:country[@name=$country][locales:language=$language]/locales:source"/>
          <xsl:variable name="alt-language" select="document(concat('../content',$environment,'/data/definitions/locales.xml'))/locales:locales/locales:country[@name=$country]/locales:alt-language[locales:language=$language]/locales:source"/>
          <xsl:choose>
            <xsl:when test="normalize-space($alt-language)">
              <xsl:value-of select="$alt-language"/>
            </xsl:when>
            <xsl:when test="normalize-space($default)">
              <xsl:value-of select="$default"/>
            </xsl:when>
            <xsl:otherwise>
              <!-- In case no locales:source was definied in locales.xml -->
              <xsl:value-of select="$default_language"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <!-- Default -->
          <xsl:value-of select="$default_language"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="result">
      <!-- Error will prompt if file is not created (No function to check if file available) -->
      <xsl:apply-templates select="document(concat('../content',$environment,'/locales/',normalize-space($source),'.xml'))/stringtable:stringtable[last()]">
        <xsl:with-param name="ref" select="@ref"/>
        <xsl:with-param name="values" select="@values"/>
        <xsl:with-param name="environment" select="$environment"/>
        <xsl:with-param name="region" select="$this_region"/>
        <xsl:with-param name="skutype" select="$skutype"/>
        <xsl:with-param name="skuid" select="$skuid"/>
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="normalize-space($result)">
        <xsl:value-of select="$result"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="document(concat('../content',$environment,'/locales/',normalize-space($default_language),'.xml'))/stringtable:stringtable[last()]">
          <xsl:with-param name="ref" select="@ref"/>
          <xsl:with-param name="values" select="@values"/>
          <xsl:with-param name="environment" select="$environment"/>
          <xsl:with-param name="region" select="$this_region"/>
          <xsl:with-param name="skutype" select="$skutype"/>
          <xsl:with-param name="skuid" select="$skuid"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- Start of parsing stringtable locales file -->
  <xsl:template match="stringtable:stringtable">
    <xsl:param name="ref"/>
    <xsl:param name="values"/>
    <xsl:param name="environment"/>
    <xsl:param name="region"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <xsl:variable name="conditional_filter_group_results">
      <xsl:element name="tokens:tokens">
        <xsl:apply-templates select="stringtable:string[@id=$ref]" mode="expression_parsing">
          <xsl:with-param name="environment" select="$environment"/>
          <xsl:with-param name="region" select="$region"/>
          <xsl:with-param name="skutype" select="$skutype"/>
          <xsl:with-param name="skuid" select="$skuid"/>
        </xsl:apply-templates>
      </xsl:element>
    </xsl:variable>
    <xsl:variable name="result">
      <xsl:choose>
        <xsl:when test="function-available('exslt:node-set')">
          <xsl:value-of select="exslt:node-set($conditional_filter_group_results)/tokens:tokens/tokens:token[last()]/@filter"/>
        </xsl:when>
        <xsl:when test="function-available('msxsl:node-set')">
          <xsl:value-of select="msxsl:node-set($conditional_filter_group_results)/tokens:tokens/tokens:token[last()]/@filter"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="raw_string" select="stringtable:string[@id=$ref][not(@filter) or normalize-space(@filter)=normalize-space($result)][last()]"/>
    <xsl:choose>
      <xsl:when test="normalize-space($values)">
        <!-- String expression usage -->
        <xsl:call-template name="expression-string-replace-all">
          <xsl:with-param name="text" select="$raw_string"/>
          <xsl:with-param name="by" select="$values"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$raw_string"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- End of parsing stringtable locales file -->

  <!-- Start of grouping the same string ID entries to validate its filter as group -->
  <xsl:template match="stringtable:string" mode="expression_parsing">
    <xsl:param name="environment"/>
    <xsl:param name="region"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <xsl:variable name="conditional_filter_result">
      <xsl:call-template name="conditional-filter">
        <xsl:with-param name="expression" select="@filter"/>
        <xsl:with-param name="environment" select="$environment"/>
        <xsl:with-param name="region" select="$region"/>
        <xsl:with-param name="skutype" select="$skutype"/>
        <xsl:with-param name="skuid" select="$skuid"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="normalize-space($conditional_filter_result) = 'true'">
      <xsl:element name="tokens:token">
        <xsl:attribute name="filter">
          <xsl:value-of select="@filter"/>
        </xsl:attribute>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <!-- End of grouping the same string ID entries to validate its filter as group -->

</xsl:stylesheet>

