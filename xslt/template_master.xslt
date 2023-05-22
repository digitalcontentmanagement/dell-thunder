<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:content="http://www.dell.com/thunder/content" xmlns:generic="http://www.dell.com/thunder/generic" xmlns:product="http://www.dell.com/thunder/product" xmlns:locales="http://www.dell.com/thunder/locales" xmlns:select="http://www.dell.com/thunder/lists" xmlns:tokens="http://www.dell.com/thunder/tokens" xmlns:exslt="http://exslt.org/common" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="exslt msxsl">
  <xsl:include href="locales.xslt"/>
  <xsl:include href="utilities.xslt"/>
  <xsl:output method="html" indent="yes" encoding="utf-8" media-type="text/xml" />

  <!-- Start of Formatting -->
  <xsl:template match="content:inch">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <xsl:apply-templates>
      <xsl:with-param name="environment" select="$environment"/>
      <xsl:with-param name="country" select="$country"/>
      <xsl:with-param name="language" select="$language"/>
      <xsl:with-param name="skutype" select="$skutype"/>
      <xsl:with-param name="skuid" select="$skuid"/>
    </xsl:apply-templates><![CDATA[&quot;]]>
  </xsl:template>

  <xsl:template match="content:reg">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <xsl:apply-templates>
      <xsl:with-param name="environment" select="$environment"/>
      <xsl:with-param name="country" select="$country"/>
      <xsl:with-param name="language" select="$language"/>
      <xsl:with-param name="skutype" select="$skutype"/>
      <xsl:with-param name="skuid" select="$skuid"/>
    </xsl:apply-templates><![CDATA[&reg;]]>
  </xsl:template>

  <xsl:template match="content:copy">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <xsl:apply-templates>
      <xsl:with-param name="environment" select="$environment"/>
      <xsl:with-param name="country" select="$country"/>
      <xsl:with-param name="language" select="$language"/>
      <xsl:with-param name="skutype" select="$skutype"/>
      <xsl:with-param name="skuid" select="$skuid"/>
    </xsl:apply-templates><![CDATA[&copy;]]>
  </xsl:template>

  <xsl:template match="content:tm">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <xsl:apply-templates>
      <xsl:with-param name="environment" select="$environment"/>
      <xsl:with-param name="country" select="$country"/>
      <xsl:with-param name="language" select="$language"/>
      <xsl:with-param name="skutype" select="$skutype"/>
      <xsl:with-param name="skuid" select="$skuid"/>
    </xsl:apply-templates><![CDATA[&trade;]]>
  </xsl:template>

  <xsl:template match="content:para">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <xsl:variable name="output">
      <xsl:apply-templates>
        <xsl:with-param name="environment" select="$environment"/>
        <xsl:with-param name="country" select="$country"/>
        <xsl:with-param name="language" select="$language"/>
        <xsl:with-param name="skutype" select="$skutype"/>
        <xsl:with-param name="skuid" select="$skuid"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="has_elements">
      <xsl:call-template name="contains-elements">
        <xsl:with-param name="nodes" select="$output"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="(normalize-space($output) and string($output)) or (normalize-space($has_elements)='true')">
      <xsl:copy-of select="$output"/><![CDATA[<br/><br/>]]>
    </xsl:if>
  </xsl:template>

  <xsl:template match="content:br">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <xsl:apply-templates>
      <xsl:with-param name="environment" select="$environment"/>
      <xsl:with-param name="country" select="$country"/>
      <xsl:with-param name="language" select="$language"/>
      <xsl:with-param name="skutype" select="$skutype"/>
      <xsl:with-param name="skuid" select="$skuid"/>
    </xsl:apply-templates><![CDATA[<br/>]]>
  </xsl:template>

  <xsl:template match="content:b">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <xsl:variable name="output">
      <xsl:apply-templates>
        <xsl:with-param name="environment" select="$environment"/>
        <xsl:with-param name="country" select="$country"/>
        <xsl:with-param name="language" select="$language"/>
        <xsl:with-param name="skutype" select="$skutype"/>
        <xsl:with-param name="skuid" select="$skuid"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="has_elements">
      <xsl:call-template name="contains-elements">
        <xsl:with-param name="nodes" select="$output"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="(normalize-space($output) and string($output)) or (normalize-space($has_elements)='true')">
      <![CDATA[<strong>]]><xsl:copy-of select="$output"/><![CDATA[</strong>]]>
    </xsl:if>
  </xsl:template>

  <xsl:template match="content:link">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <xsl:if test="normalize-space(@ref)">
      <xsl:variable name="output">
        <xsl:apply-templates>
          <xsl:with-param name="environment" select="$environment"/>
          <xsl:with-param name="country" select="$country"/>
          <xsl:with-param name="language" select="$language"/>
          <xsl:with-param name="skutype" select="$skutype"/>
          <xsl:with-param name="skuid" select="$skuid"/>
        </xsl:apply-templates>
      </xsl:variable>
      <xsl:variable name="url">
        <xsl:choose>
          <xsl:when test="starts-with(normalize-space(@ref),'http://') or starts-with(normalize-space(@ref),'https://') or starts-with(normalize-space(@ref),'ftp://')">
            <xsl:value-of select="normalize-space(@ref)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat('http://',normalize-space(@ref))"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="has_elements">
        <xsl:call-template name="contains-elements">
          <xsl:with-param name="nodes" select="$output"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="normalize-space($url) and (normalize-space($output) and string($output)) or (normalize-space($has_elements)='true')">
        <![CDATA[<a href="]]><xsl:value-of select="normalize-space($url)"/><![CDATA[">]]><xsl:copy-of select="$output"/><![CDATA[</a>]]>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!--<xsl:template match="content:sup">
    <xsl:element name="sup">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="content:font">
    <xsl:element name="font">
      <xsl:attribute name="color">
        <xsl:choose>
          <xsl:when test="@color">
            <xsl:value-of select="@color"/>
          </xsl:when>
          <xsl:otherwise>
            #FF0000
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>-->

  <xsl:template match="content:points">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <xsl:variable name="output">
      <xsl:apply-templates select="content:point">
        <xsl:with-param name="environment" select="$environment"/>
        <xsl:with-param name="country" select="$country"/>
        <xsl:with-param name="language" select="$language"/>
        <xsl:with-param name="skutype" select="$skutype"/>
        <xsl:with-param name="skuid" select="$skuid"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="has_elements">
      <xsl:call-template name="contains-elements">
        <xsl:with-param name="nodes" select="$output"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="(normalize-space($output) and string($output)) or (normalize-space($has_elements)='true')">
      <![CDATA[<ul>]]><xsl:copy-of select="$output"/><![CDATA[</ul>]]>
    </xsl:if>
  </xsl:template>

  <xsl:template match="content:point">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <xsl:variable name="output">
      <xsl:apply-templates>
        <xsl:with-param name="environment" select="$environment"/>
        <xsl:with-param name="country" select="$country"/>
        <xsl:with-param name="language" select="$language"/>
        <xsl:with-param name="skutype" select="$skutype"/>
        <xsl:with-param name="skuid" select="$skuid"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="has_elements">
      <xsl:call-template name="contains-elements">
        <xsl:with-param name="nodes" select="$output"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="(normalize-space($output) and string($output)) or (normalize-space($has_elements)='true')">
      <![CDATA[<li>]]><xsl:copy-of select="$output"/><![CDATA[</li>]]>
    </xsl:if>
  </xsl:template>
  <!-- End of Formatting -->

  <!-- Start of Technotes -->
  <xsl:template match="content:technotes">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <xsl:apply-templates select="content:technote">
      <xsl:with-param name="environment" select="$environment"/>
      <xsl:with-param name="country" select="$country"/>
      <xsl:with-param name="language" select="$language"/>
      <xsl:with-param name="skutype" select="$skutype"/>
      <xsl:with-param name="skuid" select="$skuid"/>
      <xsl:with-param name="type" select="@type"/>
      <xsl:with-param name="start" select="@start"/>
      <xsl:with-param name="start_interval">
        <!-- Test if number type and starts set value more than 1 -->
        <xsl:if test="number(normalize-space(@start))=@start and @start &gt; 1">
          <xsl:value-of select="number(normalize-space(@start)) - 1"/>
        </xsl:if>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="content:technote">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <xsl:param name="type"/>
    <xsl:param name="start"/>
    <xsl:param name="start_interval"/>
    <xsl:variable name="output">
      <xsl:apply-templates>
        <xsl:with-param name="environment" select="$environment"/>
        <xsl:with-param name="country" select="$country"/>
        <xsl:with-param name="language" select="$language"/>
        <xsl:with-param name="skutype" select="$skutype"/>
        <xsl:with-param name="skuid" select="$skuid"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="has_elements">
      <xsl:call-template name="contains-elements">
        <xsl:with-param name="nodes" select="$output"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="(normalize-space($output) and string($output)) or (normalize-space($has_elements)='true')">
      <xsl:variable name="indicator">
        <xsl:choose>
          <xsl:when test="normalize-space($type)='number'">
            <xsl:variable name="number">
              <xsl:choose>
                <!-- Test if number type and starts set value more than 1 -->
                <xsl:when test="number(normalize-space($start))=$start and $start &gt; 1">
                  <xsl:value-of select="$start_interval + position()"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="position()"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <![CDATA[<span style="vertical-align: super;font-size: .83em;margin: 0;">]]><xsl:value-of select="normalize-space($number)"/><![CDATA[</span>]]>
          </xsl:when>
          <xsl:otherwise>
            <![CDATA[*]]>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <![CDATA[<span style="padding-left: 0.5em;text-indent: -0.5em;display: block;">]]><xsl:copy-of select="concat(normalize-space($indicator),$output)"/><![CDATA[</span>]]>
    </xsl:if>
  </xsl:template>
  <!-- End of Technotes -->

  <!-- Start of Textbox -->
  <xsl:template match="content:textbox">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <xsl:element name="span">
      <xsl:choose>
        <xsl:when test="normalize-space(@refid)">
          <xsl:attribute name="name">
            <xsl:value-of select="concat('associate-textbox-', normalize-space(@refid))"/>
          </xsl:attribute>
          <xsl:value-of select="@value"/>
        </xsl:when>
        <xsl:when test="normalize-space(@id)">
          <xsl:attribute name="name">
            <xsl:value-of select="concat('associate-textbox-', normalize-space(@id))"/>
          </xsl:attribute>
          <xsl:value-of select="@value"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">error</xsl:attribute>
          <xsl:text>[ID was not declared on this textbox control.]</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  <!-- End of Textbox -->

  <!-- Start of Dropdownlist -->
  <xsl:template match="content:dropdownlist">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <xsl:variable name="id" select="normalize-space(@id)"/>
    <xsl:variable name="refid" select="normalize-space(@refid)"/>
    <xsl:variable name="default_language" select="'english'"/>
    <xsl:variable name="selected_index">
      <xsl:choose>
        <xsl:when test="normalize-space(@selectedindex)">
          <xsl:value-of select="@selectedindex"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>1</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="source">
      <xsl:choose>
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
    <xsl:element name="span">
      <xsl:choose>
        <xsl:when test="$refid">
          <xsl:attribute name="name">
            <xsl:value-of select="concat('associate-dropdownlist-', $refid, '-', $source)"/>
          </xsl:attribute>
          <xsl:variable name="item" select="document(concat('../content',$environment,'/data/definitions/lists.xml'))/select:lists/select:list[@id=$refid][last()]/select:items[@locales:source=$source][last()]/select:item[position()=normalize-space($selected_index)]"/>
          <xsl:choose>
            <xsl:when test="$item">
              <xsl:value-of select="$item"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="class">error</xsl:attribute>
              <xsl:text>[Items are not found on the list. Please check its item or ID.]</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$id">
          <xsl:attribute name="name">
            <xsl:value-of select="concat('associate-dropdownlist-', $id, '-', $source)"/>
          </xsl:attribute>
          <xsl:variable name="item" select="document(concat('../content',$environment,'/data/definitions/lists.xml'))/select:lists/select:list[@id=$id][last()]/select:items[@locales:source=$source][last()]/select:item[position()=normalize-space($selected_index)]"/>
          <xsl:choose>
            <xsl:when test="$item">
              <xsl:value-of select="$item"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="class">error</xsl:attribute>
              <xsl:text>[Items are not found on the list. Please check its item or ID.]</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">error</xsl:attribute>
          <xsl:text>[ID was not declared on this dropdownlist control.]</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  <!-- End of Dropdownlist -->

  <!-- Start of Generic Content Usage -->
  <xsl:template match="product:name">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <xsl:apply-templates>
      <xsl:with-param name="environment" select="$environment"/>
      <xsl:with-param name="country" select="$country"/>
      <xsl:with-param name="language" select="$language"/>
      <xsl:with-param name="skutype" select="$skutype"/>
      <xsl:with-param name="skuid" select="$skuid"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="product:longdesc">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <xsl:apply-templates>
      <xsl:with-param name="environment" select="$environment"/>
      <xsl:with-param name="country" select="$country"/>
      <xsl:with-param name="language" select="$language"/>
      <xsl:with-param name="skutype" select="$skutype"/>
      <xsl:with-param name="skuid" select="$skuid"/>
    </xsl:apply-templates>
  </xsl:template>
  <!-- End of Generic Content Usage -->

</xsl:stylesheet>

