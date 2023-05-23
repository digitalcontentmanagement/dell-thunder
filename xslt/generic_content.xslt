<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:content="http://www.dell.com/thunder/content" xmlns:generic="http://www.dell.com/thunder/generic" xmlns:product="http://www.dell.com/thunder/product" xmlns:select="http://www.dell.com/thunder/lists" xmlns:locales="http://www.dell.com/thunder/locales" xmlns:exslt="http://exslt.org/common" xmlns:regexp="http://exslt.org/regular-expressions" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="exslt regexp msxsl">
  <xsl:include href="locales.xslt"/>
  <xsl:include href="utilities.xslt"/>
  <xsl:output method="html" indent="yes" encoding="utf-8" media-type="text/xml" />
  <xsl:param name="environment"/>
  <xsl:param name="country"/>
  <xsl:param name="language"/>
  <xsl:param name="region"/>
  <xsl:param name="skutype"/>
  <xsl:param name="skuid"/>

  <!-- ******************************************************************************************* -->
  <!-- NOTE: comment, h1, select and span[name] tag will be excluded in the word count calculation -->
  <!-- ******************************************************************************************* -->

  <!-- Start of Formatting -->
  <xsl:template match="content:inch">
    <xsl:apply-templates>
      <xsl:with-param name="environment" select="$environment"/>
      <xsl:with-param name="country" select="$country"/>
      <xsl:with-param name="language" select="$language"/>
      <xsl:with-param name="region" select="$region"/>
      <xsl:with-param name="skutype" select="$skutype"/>
      <xsl:with-param name="skuid" select="$skuid"/>
    </xsl:apply-templates>
    <xsl:value-of select="'&#34;'" disable-output-escaping="yes"/>
  </xsl:template>

  <xsl:template match="content:reg">
    <xsl:apply-templates>
      <xsl:with-param name="environment" select="$environment"/>
      <xsl:with-param name="country" select="$country"/>
      <xsl:with-param name="language" select="$language"/>
      <xsl:with-param name="region" select="$region"/>
      <xsl:with-param name="skutype" select="$skutype"/>
      <xsl:with-param name="skuid" select="$skuid"/>
    </xsl:apply-templates>
    <xsl:element name="span">
      <xsl:attribute name="class">reg</xsl:attribute>
      <xsl:value-of select="'&#174;'" disable-output-escaping="yes"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="content:copy">
    <xsl:apply-templates>
      <xsl:with-param name="environment" select="$environment"/>
      <xsl:with-param name="country" select="$country"/>
      <xsl:with-param name="language" select="$language"/>
      <xsl:with-param name="region" select="$region"/>
      <xsl:with-param name="skutype" select="$skutype"/>
      <xsl:with-param name="skuid" select="$skuid"/>
    </xsl:apply-templates>
    <xsl:element name="span">
      <xsl:attribute name="class">cpy</xsl:attribute>
      <xsl:value-of select="'&#169;'" disable-output-escaping="yes"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="content:tm">
    <xsl:apply-templates>
      <xsl:with-param name="environment" select="$environment"/>
      <xsl:with-param name="country" select="$country"/>
      <xsl:with-param name="language" select="$language"/>
      <xsl:with-param name="region" select="$region"/>
      <xsl:with-param name="skutype" select="$skutype"/>
      <xsl:with-param name="skuid" select="$skuid"/>
    </xsl:apply-templates>
    <xsl:element name="span">
      <xsl:attribute name="class">tm</xsl:attribute>
      <xsl:value-of select="'&#8482;'" disable-output-escaping="yes"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="content:para">
    <xsl:variable name="output">
      <xsl:apply-templates>
        <xsl:with-param name="environment" select="$environment"/>
        <xsl:with-param name="country" select="$country"/>
        <xsl:with-param name="language" select="$language"/>
        <xsl:with-param name="region" select="$region"/>
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
      <xsl:element name="p">
        <xsl:copy-of select="$output"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="content:br">
    <xsl:apply-templates>
      <xsl:with-param name="environment" select="$environment"/>
      <xsl:with-param name="country" select="$country"/>
      <xsl:with-param name="language" select="$language"/>
      <xsl:with-param name="region" select="$region"/>
      <xsl:with-param name="skutype" select="$skutype"/>
      <xsl:with-param name="skuid" select="$skuid"/>
    </xsl:apply-templates>
    <xsl:element name="br"/>
  </xsl:template>

  <xsl:template match="content:b">
    <xsl:variable name="output">
      <xsl:apply-templates>
        <xsl:with-param name="environment" select="$environment"/>
        <xsl:with-param name="country" select="$country"/>
        <xsl:with-param name="language" select="$language"/>
        <xsl:with-param name="region" select="$region"/>
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
      <xsl:element name="strong">
        <xsl:copy-of select="$output"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="content:link">
    <xsl:if test="normalize-space(@ref)">
      <xsl:variable name="output">
        <xsl:apply-templates>
          <xsl:with-param name="environment" select="$environment"/>
          <xsl:with-param name="country" select="$country"/>
          <xsl:with-param name="language" select="$language"/>
          <xsl:with-param name="region" select="$region"/>
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
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:value-of select="$url"/>
          </xsl:attribute>
          <xsl:copy-of select="$output"/>
        </xsl:element>
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
    <xsl:variable name="output">
      <xsl:apply-templates select="content:point">
        <xsl:with-param name="environment" select="$environment"/>
        <xsl:with-param name="country" select="$country"/>
        <xsl:with-param name="language" select="$language"/>
        <xsl:with-param name="region" select="$region"/>
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
      <xsl:if test="normalize-space(@title)">
        <xsl:variable name="title">
          <xsl:call-template name="string-look-up-formula-expression">
            <xsl:with-param name="value" select="normalize-space(@title)"/>
            <xsl:with-param name="country" select="$country"/>
            <xsl:with-param name="language" select="$language"/>
            <xsl:with-param name="skutype" select="$skutype"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:if test="normalize-space($title)">
          <xsl:variable name="title_tag">
            <xsl:element name="content:b">
              <xsl:value-of select="normalize-space($title)"/>
            </xsl:element>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="function-available('exslt:node-set')">
              <xsl:apply-templates select="exslt:node-set($title_tag)/content:b"/>
            </xsl:when>
            <xsl:when test="function-available('msxsl:node-set')">
              <xsl:apply-templates select="msxsl:node-set($title_tag)/content:b"/>
            </xsl:when>
          </xsl:choose>
        </xsl:if>
      </xsl:if>
      <xsl:element name="ul">
        <xsl:copy-of select="$output"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="content:point">
    <xsl:variable name="output">
      <xsl:apply-templates>
        <xsl:with-param name="environment" select="$environment"/>
        <xsl:with-param name="country" select="$country"/>
        <xsl:with-param name="language" select="$language"/>
        <xsl:with-param name="region" select="$region"/>
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
      <xsl:element name="li">
        <xsl:copy-of select="$output"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <!-- End of Formatting -->

  <!-- Start of Technotes -->
  <xsl:template match="content:technotes">
    <xsl:apply-templates select="content:technote">
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
    <xsl:param name="type"/>
    <xsl:param name="start"/>
    <xsl:param name="start_interval"/>
    <xsl:variable name="output">
      <xsl:apply-templates>
        <xsl:with-param name="environment" select="$environment"/>
        <xsl:with-param name="country" select="$country"/>
        <xsl:with-param name="language" select="$language"/>
        <xsl:with-param name="region" select="$region"/>
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
      <xsl:element name="span">
        <xsl:attribute name="class">lgl</xsl:attribute>
        <xsl:element name="span">
          <xsl:attribute name="class">
            <xsl:value-of select="'tch'"/>
            <xsl:if test="normalize-space($type)='number'">
              <xsl:value-of select="' tch-smaller'"/>
            </xsl:if>
          </xsl:attribute>
          <xsl:choose>
            <xsl:when test="normalize-space($type)='number'">
              <xsl:choose>
                <!-- Test if number type and starts set value more than 1 -->
                <xsl:when test="number(normalize-space($start))=$start and $start &gt; 1">
                  <xsl:value-of select="$start_interval + position()"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="position()"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'&#42;'" disable-output-escaping="yes"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
        <xsl:copy-of select="$output"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <!-- End of Technotes -->

  <!-- Start of Textbox -->
  <xsl:template match="content:textbox">
    <xsl:choose>
      <xsl:when test="normalize-space(@refid)">
        <xsl:element name="span">
          <xsl:attribute name="name">
            <xsl:value-of select="concat('associate-textbox-', normalize-space(@refid))"/>
          </xsl:attribute>
          <xsl:value-of select="@value"/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="normalize-space(@id)">
        <xsl:element name="input">
          <xsl:attribute name="id">
            <xsl:value-of select="concat('associate-textbox-', normalize-space(@id))"/>
          </xsl:attribute>
          <xsl:attribute name="onkeyup">
            <xsl:value-of select="'AssociateUpdate(this.id)'"/>
          </xsl:attribute>
          <xsl:attribute name="type">text</xsl:attribute>
          <xsl:attribute name="class">unique</xsl:attribute>
          <xsl:attribute name="onfocus">
            if(this.value == '<xsl:value-of select="@value"/>'){this.value = '';}
          </xsl:attribute>
          <xsl:attribute name="onblur">
            if(this.value == ''){this.value = '<xsl:value-of select="@value"/>';}
          </xsl:attribute>
          <xsl:if test="normalize-space(@maxlength)">
            <xsl:attribute name="maxlength">
              <xsl:value-of select="normalize-space(@maxlength)"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="normalize-space(@type)='number'">
            <xsl:attribute name="onkeypress">
              <xsl:choose>
                <xsl:when test="normalize-space(@type)='number' and normalize-space(@format)">
                  <xsl:value-of select="'return isNumberorDecimalNumber(event);'"/>
                </xsl:when>
                <xsl:when test="normalize-space(@type)='number'">
                  <xsl:value-of select="'return isNumber(event);'"/>
                </xsl:when>
              </xsl:choose>
            </xsl:attribute>
          </xsl:if>
          <xsl:attribute name="value">
            <xsl:value-of select="@value"/>
          </xsl:attribute>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="span">
          <xsl:attribute name="class">error</xsl:attribute>
          <xsl:text>[ID was not declared on this textbox control.]</xsl:text>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- End of Textbox -->

  <!-- Start of Dropdownlist -->
  <xsl:template match="content:dropdownlist">
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
    <xsl:choose>
      <xsl:when test="$refid">
        <xsl:element name="span">
          <xsl:attribute name="name">
            <xsl:value-of select="concat('associate-dropdownlist-', $refid,'-',$default_language)"/>
          </xsl:attribute>
          <xsl:variable name="item" select="document(concat('../content',$environment,'/data/definitions/lists.xml'))/select:lists/select:list[@id=$refid][last()]/select:items[@locales:source=$default_language][last()]/select:item[position()=normalize-space($selected_index)]"/>
          <xsl:choose>
            <xsl:when test="$item">
              <xsl:value-of select="$item"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="class">error</xsl:attribute>
              <xsl:text>[Items are not found on the list. Please check its item or ID.]</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
      </xsl:when>
      <xsl:when test="$id">
        <xsl:variable name="items" select="document(concat('../content',$environment,'/data/definitions/lists.xml'))/select:lists/select:list[@id=$id][last()]/select:items[@locales:source=$default_language][last()]"/>
        <xsl:choose>
          <xsl:when test="$items/select:item">
            <xsl:element name="select">
              <xsl:attribute name="id">
                <xsl:value-of select="concat('associate-dropdownlist-', $id)"/>
              </xsl:attribute>
              <xsl:attribute name="onchange">
                <xsl:value-of select="'AssociateDropdownlistUpdate(this.id)'"/>
              </xsl:attribute>
              <xsl:apply-templates select="$items">
                <xsl:with-param name="id" select="$id"/>
                <xsl:with-param name="selected_index" select="normalize-space($selected_index)"/>
              </xsl:apply-templates>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="span">
              <xsl:attribute name="class">error</xsl:attribute>
              <xsl:text>[Items are not found on the list. Please check its item or ID.]</xsl:text>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="span">
          <xsl:attribute name="class">error</xsl:attribute>
          <xsl:text>[ID was not declared on this dropdownlist control.]</xsl:text>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="select:items">
    <xsl:param name="id"/>
    <xsl:param name="selected_index"/>
    <xsl:apply-templates select="select:item">
      <xsl:with-param name="id" select="$id"/>
      <xsl:with-param name="selected_index" select="$selected_index"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="select:item">
    <xsl:param name="id"/>
    <xsl:param name="selected_index"/>
    <xsl:variable name="list" select="document(concat('../content',$environment,'/data/definitions/lists.xml'))/select:lists/select:list[@id=normalize-space($id)][last()]"/>
    <xsl:variable name="this_item_position" select="position()"/>
    <xsl:variable name="data">
      <xsl:text>[</xsl:text>
      <xsl:for-each select="$list/select:items">
        <xsl:text>{"lang":"</xsl:text>
        <xsl:value-of select="@locales:source"/>
        <xsl:text>","value":"</xsl:text>
        <xsl:value-of select="select:item[$this_item_position]"/>
        <xsl:text>"}</xsl:text>
        <xsl:if test="position()!=last()">
          <xsl:text>,</xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:text>]</xsl:text>
    </xsl:variable>
    <xsl:element name="option">
      <xsl:attribute name="data-value">
        <xsl:value-of select="normalize-space($data)"/>
      </xsl:attribute>
      <xsl:if test="$this_item_position=$selected_index">
        <xsl:attribute name="selected">
          <xsl:value-of select="'selected'"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="text()">
          <xsl:value-of select="text()"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>- Blank -</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  <!-- End of Dropdownlist -->

  <xsl:template match="product:name">
    <xsl:variable name="output">
      <xsl:apply-templates>
        <xsl:with-param name="environment" select="$environment"/>
        <xsl:with-param name="country" select="$country"/>
        <xsl:with-param name="language" select="$language"/>
        <xsl:with-param name="region" select="$region"/>
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
      <xsl:element name="section">
        <xsl:attribute name="id">name</xsl:attribute>
        <xsl:element name="div">
          <xsl:attribute name="class">field</xsl:attribute>
          <xsl:call-template name="string-look-up">
            <xsl:with-param name="ref" select="'productname'"/>
          </xsl:call-template>
        </xsl:element>
        <xsl:copy-of select="$output"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="product:longdesc">
    <xsl:variable name="output">
      <xsl:apply-templates>
        <xsl:with-param name="environment" select="$environment"/>
        <xsl:with-param name="country" select="$country"/>
        <xsl:with-param name="language" select="$language"/>
        <xsl:with-param name="region" select="$region"/>
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
      <xsl:element name="section">
        <xsl:attribute name="id">longdesc</xsl:attribute>
        <xsl:element name="div">
          <xsl:attribute name="class">field</xsl:attribute>
          <xsl:call-template name="string-look-up">
            <xsl:with-param name="ref" select="'longdescription'"/>
          </xsl:call-template>
        </xsl:element>
        <xsl:copy-of select="$output"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <!-- Start of Name & Value Columns (PIM - PRC Upload Usage) -->
  <xsl:template match="product:techspecs">
    <xsl:variable name="output">
      <xsl:apply-templates select="product:techspec">
        <xsl:sort select="child::product:techspec/@id" order="ascending"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="has_elements">
      <xsl:call-template name="contains-elements">
        <xsl:with-param name="nodes" select="$output"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="(normalize-space($output) and string($output)) or (normalize-space($has_elements)='true')">
      <xsl:element name="section">
        <xsl:attribute name="id">techspecs</xsl:attribute>
        <xsl:element name="div">
          <xsl:attribute name="class">field</xsl:attribute>
          <xsl:call-template name="string-look-up">
            <xsl:with-param name="ref" select="'techspecs'"/>
          </xsl:call-template>
        </xsl:element>
        <xsl:element name="section">
          <xsl:attribute name="id">techspecs-table</xsl:attribute>
          <xsl:element name="table">
            <xsl:copy-of select="$output"/>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="product:techspec">
    <xsl:variable name="output">
      <xsl:apply-templates>
        <xsl:with-param name="environment" select="$environment"/>
        <xsl:with-param name="country" select="$country"/>
        <xsl:with-param name="language" select="$language"/>
        <xsl:with-param name="region" select="$region"/>
        <xsl:with-param name="skutype" select="$skutype"/>
        <xsl:with-param name="skuid" select="$skuid"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="has_elements">
      <xsl:call-template name="contains-elements">
        <xsl:with-param name="nodes" select="$output"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="normalize-space(@name) and (normalize-space($output) and string($output)) or (normalize-space($has_elements)='true')">
      <xsl:element name="tr">
        <xsl:attribute name="class">item</xsl:attribute>
        <xsl:element name="td">
          <xsl:attribute name="class">field</xsl:attribute>
          <xsl:value-of select="@name"/>:
        </xsl:element>
        <xsl:element name="td">
          <xsl:copy-of select="$output"/>
        </xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <!-- End of Name & Value Columns (PIM - PRC Upload Usage) -->

  <!-- Start of Name & Value Columns (Harmony - Mass Upload Usage) -->
  <xsl:template match="product:highlights">
    <xsl:variable name="output">
      <xsl:apply-templates select="content:points|content:para">
        <xsl:with-param name="environment" select="$environment"/>
        <xsl:with-param name="country" select="$country"/>
        <xsl:with-param name="language" select="$language"/>
        <xsl:with-param name="region" select="$region"/>
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
      <xsl:element name="section">
        <xsl:attribute name="id">highlights</xsl:attribute>
        <xsl:element name="div">
          <xsl:attribute name="class">field</xsl:attribute>
          <xsl:call-template name="string-look-up">
            <xsl:with-param name="ref" select="'highlights'"/>
          </xsl:call-template>
        </xsl:element>
        <xsl:copy-of select="$output"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
  <!-- End of Name & Value Columns (Harmony - Mass Upload Usage) -->

  <xsl:template match="generic:root">
    <xsl:element name="section">
      <xsl:attribute name="id">generic-content</xsl:attribute>
      <xsl:element name="section">
        <xsl:attribute name="id">placeholder</xsl:attribute>
        <xsl:element name="h1">
          <xsl:call-template name="string-look-up">
            <xsl:with-param name="ref" select="'genericcontent'"/>
          </xsl:call-template>
        </xsl:element>
        <xsl:apply-templates select="generic:content/product:name[last()]"/>
        <xsl:apply-templates select="generic:content/product:longdesc[last()]"/>
        <xsl:apply-templates select="generic:content/product:highlights[last()]"/>
        <xsl:apply-templates select="generic:content/product:techspecs[last()]"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>

