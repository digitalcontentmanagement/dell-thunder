<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:content="http://www.dell.com/thunder/content" xmlns:generic="http://www.dell.com/thunder/generic" xmlns:product="http://www.dell.com/thunder/product" xmlns:locales="http://www.dell.com/thunder/locales" xmlns:tokens="http://www.dell.com/thunder/tokens" xmlns:exslt="http://exslt.org/common" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="exslt msxsl">
  <xsl:include href="template_master.xslt"/>
  <xsl:output method="html" indent="yes" encoding="utf-8" media-type="text/xml" />
  <xsl:param name="environment"/>
  <xsl:param name="region"/>
  <xsl:param name="skutype"/>
  <xsl:param name="skuid"/>
  <xsl:param name="categoryid"/>
  <xsl:param name="subclass"/>
  <xsl:param name="markets"/>
  <xsl:param name="foldername"/>

  <!-- Start of repeating element -->
  <xsl:template name="specs-pair-iterate">
    <xsl:param name="length" select="5"/>
    <xsl:param name="i" select="1"/>
    <!--<xsl:value-of select="$i"/>-->
    <xsl:element name="th">Name</xsl:element>
    <xsl:element name="th">Value</xsl:element>
    <xsl:if test="$length > 1">
      <xsl:call-template name="specs-pair-iterate">
        <xsl:with-param name="length" select="$length - 1"/>
        <xsl:with-param name="i" select="$i + 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="specs-iterate">
    <xsl:param name="length" select="5"/>
    <xsl:param name="i" select="1"/>
    <xsl:element name="th">
      <xsl:attribute name="colspan">2</xsl:attribute>
      <xsl:value-of select="concat('Spec ',$i)"/>
    </xsl:element>
    <xsl:if test="$length > 1">
      <xsl:call-template name="specs-iterate">
        <xsl:with-param name="length" select="$length - 1"/>
        <xsl:with-param name="i" select="$i + 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <!-- End of repeating element -->

  <!-- Start of Available Source List-->
  <!-- //Concatenate culture language and source name -->
  <xsl:template match="locales:source" mode="source_list">
    <xsl:variable name="culture" select="current()/preceding-sibling::locales:culture[(@template='prc' or not(@template))] | current()/following-sibling::locales:culture[(@template='prc' or not(@template))]"/>
    <xsl:if test="normalize-space($culture) and normalize-space(text())">
      <xsl:element name="item">
        <xsl:attribute name="culture-language-and-source">
          <xsl:value-of select="concat(substring($culture,1,2),'-',text())"/>
        </xsl:attribute>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="item" mode="unified_sources">
    <xsl:element name="source">
      <xsl:attribute name="culture-language">
        <!--//Output language code such as en, fr -->
        <xsl:value-of select="substring(@culture-language-and-source,1,2)"/>
      </xsl:attribute>
      <!--//Output source name such as english, simplified-chinese -->
      <xsl:value-of select="substring(@culture-language-and-source,4)"/>
    </xsl:element>
  </xsl:template>
  <!-- End of Available Source List-->

  <!--//Start of Reordering tokens to merge all same markets into one node -->
  <xsl:template match="tokens:token" mode="prc_tokens">
    <xsl:variable name="country" select="substring(text(),4,2)"/>
    <xsl:variable name="language" select="substring(text(),1,2)"/>
    <!-- Start of retrieving source & culture -->
    <xsl:variable name="source">
      <xsl:variable name="default" select="document(concat('../content',$environment,'/data/definitions/locales.xml'))/locales:locales/locales:country[@name=$country and locales:language=$language and locales:culture[@template='prc' or not(@template)]]/locales:source"/>
      <xsl:variable name="alt-language" select="document(concat('../content',$environment,'/data/definitions/locales.xml'))/locales:locales/locales:country[@name=$country]/locales:alt-language[locales:language=$language and locales:culture[@template='prc' or not(@template)]]/locales:source"/>
      <xsl:choose>
        <xsl:when test="normalize-space($alt-language)">
          <xsl:value-of select="$alt-language"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$default"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="culture">
      <xsl:variable name="default" select="document(concat('../content',$environment,'/data/definitions/locales.xml'))/locales:locales/locales:country[@name=$country][locales:language=$language]/locales:culture[@template='prc' or not(@template)]"/>
      <xsl:variable name="alt-language" select="document(concat('../content',$environment,'/data/definitions/locales.xml'))/locales:locales/locales:country[@name=$country]/locales:alt-language[locales:language=$language]/locales:culture[@template='prc' or not(@template)]"/>
      <xsl:choose>
        <xsl:when test="normalize-space($alt-language)">
          <xsl:value-of select="$alt-language"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$default"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- End of retrieving source & culture -->
    <xsl:if test="normalize-space($source) and normalize-space($culture)">
      <xsl:element name="tokens:token">
        <xsl:attribute name="source">
          <xsl:value-of select="$source"/>
        </xsl:attribute>
        <xsl:attribute name="country">
          <xsl:value-of select="$country"/>
        </xsl:attribute>
        <xsl:attribute name="language">
          <xsl:value-of select="$language"/>
        </xsl:attribute>
        <xsl:value-of select="$culture"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tokens:token" mode="prc_tokens_merge">
    <xsl:value-of select="concat(substring(text(),4,2), ', ')"/>
  </xsl:template>
  <!--//End of Reordering tokens to consolidate all same markets into one node -->

  <!-- Start of PRC-specific only -->
  <xsl:template match="product:techspecs">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <xsl:apply-templates select="product:techspec">
      <xsl:with-param name="environment" select="$environment"/>
      <xsl:with-param name="country" select="$country"/>
      <xsl:with-param name="language" select="$language"/>
      <xsl:with-param name="skutype" select="$skutype"/>
      <xsl:with-param name="skuid" select="$skuid"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="product:techspec">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <xsl:variable name="value">
      <xsl:apply-templates>
        <xsl:with-param name="environment" select="$environment"/>
        <xsl:with-param name="country" select="$country"/>
        <xsl:with-param name="language" select="$language"/>
        <xsl:with-param name="skutype" select="$skutype"/>
        <xsl:with-param name="skuid" select="$skuid"/>
      </xsl:apply-templates>
    </xsl:variable>
	<!-- Requested to remain English techspecs only dated 24 June 2021 -->
    <!--<xsl:if test="normalize-space(@name) or normalize-space($value)">--> 
      <xsl:element name="td">
        <xsl:attribute name="onMouseover">ddrivetip(this.innerText||this.textContent);</xsl:attribute>
        <xsl:attribute name="onMouseout">hideddrivetip();</xsl:attribute>
        <!-- Name -->
        <xsl:value-of select="@name"/>
      </xsl:element>
      <xsl:element name="td">
        <xsl:attribute name="onMouseover">ddrivetip(this.innerText||this.textContent);</xsl:attribute>
        <xsl:attribute name="onMouseout">hideddrivetip();</xsl:attribute>
        <!-- Value -->
        <xsl:copy-of select="$value"/>
      </xsl:element>
    <!--</xsl:if>-->
  </xsl:template>
  <!-- End of PRC-specific only -->

  <!-- Start of Generic Content Template -->
  <xsl:template match="/">

    <!-- Start of removing non-PRC markets -->
    <xsl:variable name="prc_tokens">
      <xsl:variable name="markets_tokens">
        <xsl:call-template name="tokenize">
          <xsl:with-param name="string" select="$markets"/>
          <xsl:with-param name="pattern" select="','"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:element name="tokens:tokens">
        <xsl:choose>
          <xsl:when test="function-available('exslt:node-set')">
            <xsl:apply-templates select="exslt:node-set($markets_tokens)/tokens:token" mode="prc_tokens"/>
          </xsl:when>
          <xsl:when test="function-available('msxsl:node-set')">
            <xsl:apply-templates select="msxsl:node-set($markets_tokens)/tokens:token" mode="prc_tokens"/>
          </xsl:when>
        </xsl:choose>
      </xsl:element>
    </xsl:variable>
    <!-- End of removing non-PRC markets -->

    <!-- Start of Preparing source list -->
    <xsl:variable name="source_list">
      <!-- Listing all sources from locales.xml -->
      <xsl:variable name="source_items">
        <xsl:element name="items">
          <xsl:apply-templates select="document(concat('../content',$environment,'/data/definitions/locales.xml'))/locales:locales/locales:country/locales:source | document(concat('../content',$environment,'/data/definitions/locales.xml'))/locales:locales/locales:country/locales:alt-language/locales:source" mode="source_list"/>
        </xsl:element>
      </xsl:variable>
      <!-- Unifying sources -->
      <xsl:element name="sources">
        <xsl:choose>
          <xsl:when test="function-available('exslt:node-set')">
            <xsl:apply-templates select="exslt:node-set($source_items)/items/item[not(@culture-language-and-source=following::item/@culture-language-and-source)]" mode="unified_sources">
              <xsl:sort select="translate(normalize-space(@culture-language-and-source), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')='EN-ENGLISH'" data-type="text" order="descending" case-order="lower-first" />
            </xsl:apply-templates>
          </xsl:when>
          <xsl:when test="function-available('msxsl:node-set')">
            <xsl:apply-templates select="msxsl:node-set($source_items)/items/item[not(@culture-language-and-source=following::item/@culture-language-and-source)]" mode="unified_sources">
              <xsl:sort select="translate(normalize-space(@culture-language-and-source), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')='EN-ENGLISH'" data-type="text" order="descending" case-order="lower-first" />
            </xsl:apply-templates>
          </xsl:when>
        </xsl:choose>
      </xsl:element>
    </xsl:variable>
    <!-- End of Preparing source list -->

    <!-- Start of reordering all similar market languages into one -->
    <xsl:variable name="prc_tokens_merge">
      <xsl:element name="tokens:tokens">
        <xsl:choose>
          <xsl:when test="function-available('exslt:node-set')">
            <xsl:for-each select="exslt:node-set($source_list)/sources/source">
              <xsl:variable name="source" select="text()"/>
              <xsl:variable name="culture_language" select="@culture-language"/>
              <xsl:variable name="country_list">
                <xsl:apply-templates select="exslt:node-set($prc_tokens)/tokens:tokens/tokens:token[@source=normalize-space($source) and substring(text(),1,2)=$culture_language]" mode="prc_tokens_merge"/>
              </xsl:variable>
              <xsl:if test="normalize-space($country_list)">
                <xsl:element name="tokens:token">
                  <xsl:attribute name="source">
                    <xsl:value-of select="$source"/>
                  </xsl:attribute>
                  <!-- Keeping its standard country and language code (Note: If more than one countries, the initial country code is extracted) -->
                  <xsl:attribute name="country">
                    <xsl:value-of select="exslt:node-set($prc_tokens)/tokens:tokens/tokens:token[@source=normalize-space($source) and substring(text(),1,2)=$culture_language]/@country"/>
                  </xsl:attribute>
                  <xsl:attribute name="language">
                    <xsl:value-of select="exslt:node-set($prc_tokens)/tokens:tokens/tokens:token[@source=normalize-space($source) and substring(text(),1,2)=$culture_language]/@language"/>
                  </xsl:attribute>
                  <xsl:attribute name="culture-language">
                    <xsl:value-of select="$culture_language"/>
                  </xsl:attribute>
                  <xsl:value-of select="substring(normalize-space($country_list),1,string-length(normalize-space($country_list))-1)"/>
                </xsl:element>
              </xsl:if>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="function-available('msxsl:node-set')">
            <xsl:for-each select="msxsl:node-set($source_list)/sources/source">
              <xsl:variable name="source" select="text()"/>
              <xsl:variable name="culture_language" select="@culture-language"/>
              <xsl:variable name="country_list">
                <xsl:apply-templates select="msxsl:node-set($prc_tokens)/tokens:tokens/tokens:token[@source=normalize-space($source) and substring(text(),1,2)=$culture_language]" mode="prc_tokens_merge"/>
              </xsl:variable>
              <xsl:if test="normalize-space($country_list)">
                <xsl:element name="tokens:token">
                  <xsl:attribute name="source">
                    <xsl:value-of select="$source"/>
                  </xsl:attribute>
                  <!-- Keeping its standard country and language code (Note: If more than one countries, the initial country code is extracted) -->
                  <xsl:attribute name="country">
                    <xsl:value-of select="msxsl:node-set($prc_tokens)/tokens:tokens/tokens:token[@source=normalize-space($source) and substring(text(),1,2)=$culture_language]/@country"/>
                  </xsl:attribute>
                  <xsl:attribute name="language">
                    <xsl:value-of select="msxsl:node-set($prc_tokens)/tokens:tokens/tokens:token[@source=normalize-space($source) and substring(text(),1,2)=$culture_language]/@language"/>
                  </xsl:attribute>
                  <xsl:attribute name="culture-language">
                    <xsl:value-of select="$culture_language"/>
                  </xsl:attribute>
                  <xsl:value-of select="substring(normalize-space($country_list),1,string-length(normalize-space($country_list))-1)"/>
                </xsl:element>
              </xsl:if>
            </xsl:for-each>
          </xsl:when>
        </xsl:choose>
      </xsl:element>
    </xsl:variable>
    <!-- End of reordering all similar market languages into one -->

    <xsl:element name="div">
      <xsl:attribute name="id">prc-template-holder</xsl:attribute>
      <!-- Start of PRC template as of (31 August 2015) -->
      <xsl:element name="table">
        <xsl:attribute name="id">prc-template</xsl:attribute>
        <xsl:element name="thead">
          <xsl:element name="tr">
            <xsl:element name="th">
              <xsl:attribute name="rowspan">2</xsl:attribute>
              <xsl:attribute name="class">freezedpanes</xsl:attribute>
              Dell SKU
            </xsl:element>
            <xsl:element name="th">
              <xsl:attribute name="rowspan">2</xsl:attribute>
              <xsl:attribute name="class">freezedpanes</xsl:attribute>
              MPN
            </xsl:element>
            <xsl:element name="th">
              <xsl:attribute name="rowspan">2</xsl:attribute>
              <xsl:attribute name="class">freezedpanes</xsl:attribute>
              Target Market(s)
            </xsl:element>
            <xsl:element name="th">
              <xsl:attribute name="rowspan">2</xsl:attribute>
              <xsl:attribute name="class">freezedpanes</xsl:attribute>
              Source Language
            </xsl:element>
            <xsl:element name="th">
              <xsl:attribute name="rowspan">2</xsl:attribute>
              Product Title
            </xsl:element>
            <xsl:element name="th">
              <xsl:attribute name="rowspan">2</xsl:attribute>
              Long Description
            </xsl:element>
            <xsl:element name="th">
              <xsl:attribute name="rowspan">2</xsl:attribute>
              LargeImageURL
            </xsl:element>
            <xsl:call-template name="specs-iterate">
              <xsl:with-param name="length" select="32"/>
              <xsl:with-param name="i" select="1"/>
            </xsl:call-template>
          </xsl:element>
          <xsl:element name="tr">
            <xsl:call-template name="specs-pair-iterate">
              <xsl:with-param name="length" select="32"/>
              <xsl:with-param name="i" select="1"/>
            </xsl:call-template>
          </xsl:element>
        </xsl:element>
        <xsl:element name="tbody">

          <!-- Start of Generic Content Grabber -->
          <!--<xsl:value-of select="system-property('xsl:vendor')"/>-->
          <xsl:variable name="path" select="concat('../content',$environment,'/data/products/',$categoryid,'/',$foldername,'/')"/>
          <xsl:choose>
            <xsl:when test="function-available('exslt:node-set')">
              <xsl:for-each select="exslt:node-set($prc_tokens_merge)/tokens:tokens/tokens:token">
                <xsl:if test="normalize-space(@source) and normalize-space(@culture-language) and normalize-space(text())">
                  <!-- Unable to test if document physically available and return messaging -->
                  <xsl:apply-templates select="document(concat($path, normalize-space(@source) ,'.xml'))/generic:root[last()]">
                    <xsl:with-param name="position" select="position()"/>
                    <xsl:with-param name="markets" select="text()"/>
                    <xsl:with-param name="culture_language" select="@culture-language"/>
                    <xsl:with-param name="environment" select="$environment"/>
                    <xsl:with-param name="country" select="@country"/>
                    <xsl:with-param name="language" select="@language"/>
                    <xsl:with-param name="skutype" select="$skutype"/>
                    <xsl:with-param name="skuid" select="$skuid"/>
                  </xsl:apply-templates>
                </xsl:if>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="function-available('msxsl:node-set')">
              <xsl:for-each select="msxsl:node-set($prc_tokens_merge)/tokens:tokens/tokens:token">
                <xsl:if test="normalize-space(@source) and normalize-space(@culture-language) and normalize-space(text())">
                  <!-- Unable to test if document physically available and return messaging -->
                  <xsl:apply-templates select="document(concat($path, normalize-space(@source) ,'.xml'))/generic:root[last()]">
                    <xsl:with-param name="position" select="position()"/>
                    <xsl:with-param name="markets" select="text()"/>
                    <xsl:with-param name="culture_language" select="@culture-language"/>
                    <xsl:with-param name="environment" select="$environment"/>
                    <xsl:with-param name="country" select="@country"/>
                    <xsl:with-param name="language" select="@language"/>
                    <xsl:with-param name="skutype" select="$skutype"/>
                    <xsl:with-param name="skuid" select="$skuid"/>
                  </xsl:apply-templates>
                </xsl:if>
              </xsl:for-each>
            </xsl:when>
          </xsl:choose>
          <!-- End of Generic Content Grabber -->

        </xsl:element>
      </xsl:element>
      <!-- End of PRC template -->
    </xsl:element>
  </xsl:template>

  <xsl:template match="generic:root">
    <xsl:param name="position"/>
    <xsl:param name="markets"/>
    <xsl:param name="culture_language"/>
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>

    <xsl:variable name="capitalized_skuid" select="translate($skuid, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>

    <xsl:if test="normalize-space($markets) and normalize-space($culture_language)">
      <xsl:element name="tr">
        <xsl:element name="td">
          <!-- SKU -->
          <xsl:if test="$position=1">
            <xsl:value-of select="$capitalized_skuid"/>
          </xsl:if>
        </xsl:element>
        <xsl:element name="td">
          <!-- Manufacturing Part Number -->
          <xsl:if test="$position=1">
            <xsl:value-of select="$capitalized_skuid"/>
          </xsl:if>
        </xsl:element>
        <xsl:element name="td">
          <!-- Market(s) -->
          <xsl:value-of select="translate(normalize-space($markets), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
        </xsl:element>
        <xsl:element name="td">
          <!-- Source Language -->
          <xsl:value-of select="translate(normalize-space($culture_language), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
        </xsl:element>
        <xsl:element name="td">
          <xsl:attribute name="onMouseover">ddrivetip(this.innerText||this.textContent);</xsl:attribute>
          <xsl:attribute name="onMouseout">hideddrivetip();</xsl:attribute>
          <!-- Product Name (PN) -->
          <xsl:apply-templates select="generic:content/product:name[last()]">
            <xsl:with-param name="environment" select="$environment"/>
            <xsl:with-param name="country" select="$country"/>
            <xsl:with-param name="language" select="$language"/>
            <xsl:with-param name="skutype" select="$skutype"/>
            <xsl:with-param name="skuid" select="$skuid"/>
          </xsl:apply-templates>
        </xsl:element>
        <xsl:element name="td">
          <xsl:attribute name="onMouseover">ddrivetip(this.innerText||this.textContent);</xsl:attribute>
          <xsl:attribute name="onMouseout">hideddrivetip();</xsl:attribute>
          <!-- Long Description (LD) -->
          <xsl:apply-templates select="generic:content/product:longdesc[last()]">
            <xsl:with-param name="environment" select="$environment"/>
            <xsl:with-param name="country" select="$country"/>
            <xsl:with-param name="language" select="$language"/>
            <xsl:with-param name="skutype" select="$skutype"/>
            <xsl:with-param name="skuid" select="$skuid"/>
          </xsl:apply-templates>
        </xsl:element>
        <xsl:element name="td">
          <xsl:attribute name="onMouseover">ddriveimagetip(this.innerText||this.textContent);</xsl:attribute>
          <xsl:attribute name="onMouseout">hideddrivetip();</xsl:attribute>
          <!-- Larger Image URL -->
          <xsl:value-of select="concat('http://snpi.dell.com/snp/images/products/large/en-us~',$capitalized_skuid,'/',$capitalized_skuid,'.jpg')"/>
        </xsl:element>
        <!-- 32 Techspecs -->
        <xsl:apply-templates select="generic:content/product:techspecs[last()]">
          <xsl:with-param name="environment" select="$environment"/>
          <xsl:with-param name="country" select="$country"/>
          <xsl:with-param name="language" select="$language"/>
          <xsl:with-param name="skutype" select="$skutype"/>
          <xsl:with-param name="skuid" select="$skuid"/>
        </xsl:apply-templates>
      </xsl:element>
    </xsl:if>

  </xsl:template>
  <!-- End of Generic Content Template -->

</xsl:stylesheet>

