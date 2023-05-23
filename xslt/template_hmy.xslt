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
    <xsl:element name="th">
      <xsl:value-of select="concat('Feature_Name_ ',$i)"/>
    </xsl:element>
    <xsl:element name="th">
      <xsl:value-of select="concat('Feature_Value_ ',$i)"/>
    </xsl:element>
    <xsl:if test="$length > 1">
      <xsl:call-template name="specs-pair-iterate">
        <xsl:with-param name="length" select="$length - 1"/>
        <xsl:with-param name="i" select="$i + 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <!-- End of repeating element -->

  <!-- Start of Harmony-specific only -->
  <xsl:template match="product:highlights">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <!-- Start of Preparing Name and Value list (Before being populated into template column fields) -->
    <xsl:variable name="name_value_list">
      <xsl:element name="tokens:tokens">
        <xsl:apply-templates select="content:para|content:points">
          <xsl:with-param name="environment" select="$environment"/>
          <xsl:with-param name="country" select="$country"/>
          <xsl:with-param name="language" select="$language"/>
          <xsl:with-param name="skutype" select="$skutype"/>
          <xsl:with-param name="skuid" select="$skuid"/>
        </xsl:apply-templates>
      </xsl:element>
    </xsl:variable>
    <!-- End of Preparing Name and Value list (Before being populated into template column fields) -->

    <!-- Start of Populating into the template name and value fields -->
    <xsl:choose>
      <xsl:when test="function-available('exslt:node-set')">
        <xsl:apply-templates select="exslt:node-set($name_value_list)/tokens:tokens" mode="name_value_list"/>
      </xsl:when>
      <xsl:when test="function-available('msxsl:node-set')">
        <xsl:apply-templates select="msxsl:node-set($name_value_list)/tokens:tokens" mode="name_value_list"/>
      </xsl:when>
    </xsl:choose>
    <!-- End of Populating into the template name and value fields -->
  </xsl:template>

  <!-- Adding Para under Product Highlights dated 23 May 2023 by Syahirah's ask -->
  <xsl:template match="content:para">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <xsl:variable name="feature_value">
      <xsl:apply-templates>
         <xsl:with-param name="environment" select="$environment"/>
         <xsl:with-param name="country" select="$country"/>
         <xsl:with-param name="language" select="$language"/>
         <xsl:with-param name="skutype" select="$skutype"/>
         <xsl:with-param name="skuid" select="$skuid"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:element name="tokens:token">
      <![CDATA[<p>]]>
      <xsl:copy-of select="$feature_value"/>
      <![CDATA[</p>]]>
    </xsl:element>
  </xsl:template>

  <xsl:template match="content:points">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <xsl:choose>
      <xsl:when test="normalize-space(@title)">
        <!-- Start of Value Content (title) -->
        <xsl:variable name="title">
          <xsl:call-template name="string-look-up-formula-expression">
            <xsl:with-param name="value" select="normalize-space(@title)"/>
            <xsl:with-param name="environment" select="$environment"/>
            <xsl:with-param name="country" select="$country"/>
            <xsl:with-param name="language" select="$language"/>
            <xsl:with-param name="skuid" select="$skuid"/>
          </xsl:call-template>
        </xsl:variable>
        <!-- End of Value Content (title) -->
        <xsl:choose>
          <xsl:when test="normalize-space($title)">
            <!-- Start of Value Content (content) -->
            <xsl:variable name="feature_value">
              <xsl:apply-templates select="content:point">
                <xsl:with-param name="environment" select="$environment"/>
                <xsl:with-param name="country" select="$country"/>
                <xsl:with-param name="language" select="$language"/>
                <xsl:with-param name="skutype" select="$skutype"/>
                <xsl:with-param name="skuid" select="$skuid"/>
              </xsl:apply-templates>
            </xsl:variable>
            <!-- End of Value Content (content) -->
            <xsl:if test="normalize-space($title) and normalize-space($feature_value)">
              <xsl:element name="tokens:token">
                <xsl:attribute name="title">
                  <xsl:value-of select="$title"/>
                </xsl:attribute>
                <xsl:copy-of select="$feature_value"/>
              </xsl:element>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="content:point" mode="highlights_point_without_title">
              <xsl:with-param name="environment" select="$environment"/>
              <xsl:with-param name="country" select="$country"/>
              <xsl:with-param name="language" select="$language"/>
              <xsl:with-param name="skutype" select="$skutype"/>
              <xsl:with-param name="skuid" select="$skuid"/>
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="content:point" mode="highlights_point_without_title">
          <xsl:with-param name="environment" select="$environment"/>
          <xsl:with-param name="country" select="$country"/>
          <xsl:with-param name="language" select="$language"/>
          <xsl:with-param name="skutype" select="$skutype"/>
          <xsl:with-param name="skuid" select="$skuid"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="content:point" mode="highlights_point_without_title">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <xsl:variable name="feature_value">
      <xsl:apply-templates>
        <xsl:with-param name="environment" select="$environment"/>
        <xsl:with-param name="country" select="$country"/>
        <xsl:with-param name="language" select="$language"/>
        <xsl:with-param name="skutype" select="$skutype"/>
        <xsl:with-param name="skuid" select="$skuid"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:if test="normalize-space($feature_value)">
      <xsl:element name="tokens:token">
        <xsl:attribute name="position">
          <xsl:value-of select="position()"/>
        </xsl:attribute>
        <xsl:if test="position() = last()">
          <xsl:attribute name="last">
            <xsl:value-of select="last()"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:copy-of select="$feature_value"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tokens:tokens" mode="name_value_list">
    <xsl:apply-templates select="tokens:token" mode="name_value_list">
      <xsl:with-param name="child_title_total" select="count(child::tokens:token/@title)"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="tokens:token" mode="name_value_list">
    <xsl:param name="child_title_total"/>
    <xsl:element name="td">
      <xsl:attribute name="onMouseover">ddrivetip(this.innerText||this.textContent);</xsl:attribute>
      <xsl:attribute name="onMouseout">hideddrivetip();</xsl:attribute>
      <!-- Feature Name -->
    </xsl:element>
    <xsl:element name="td">
      <xsl:attribute name="onMouseover">ddrivetip(this.innerText||this.textContent);</xsl:attribute>
      <xsl:attribute name="onMouseout">hideddrivetip();</xsl:attribute>
      <!-- Feature Value -->
      <xsl:choose>
        <xsl:when test="$child_title_total &gt; 0">
          <xsl:if test="position() = 1">
            <![CDATA[</b><style type="text/css">ul, li {list-style-type: none;padding: 0px 0px;margin: 0px 6px;} .dell_inline li {list-style-type: disc;}</style>]]>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="normalize-space(@title)">
              <!-- Start of Value Content -->
              <xsl:variable name="title_tag">
                <xsl:element name="content:b">
                  <xsl:value-of select="normalize-space(@title)"/>
                </xsl:element>
              </xsl:variable>
              <![CDATA[<p>]]>
              <xsl:choose>
                <xsl:when test="function-available('exslt:node-set')">
                  <xsl:apply-templates select="exslt:node-set($title_tag)/content:b"/>
                </xsl:when>
                <xsl:when test="function-available('msxsl:node-set')">
                  <xsl:apply-templates select="msxsl:node-set($title_tag)/content:b"/>
                </xsl:when>
              </xsl:choose>
              <![CDATA[</p>]]>
              <![CDATA[<p><ul class="dell_inline">]]>
              <xsl:copy-of select="node()"/>
              <![CDATA[</ul></p>]]>
              <!-- End of Value Content -->
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="number(@position) = 1 and not(number(@position) = number(@last))">
                  <!-- When first and not last point -->
                  <![CDATA[<p><ul class="dell_inline"><li>]]>
                  <xsl:copy-of select="node()"/>
                  <![CDATA[</li>]]>
                </xsl:when>
                <xsl:when test="number(@position) = 1 and number(@position) = number(@last)">
                  <!-- When first and last point -->
                  <![CDATA[<p><ul class="dell_inline"><li>]]>
                  <xsl:copy-of select="node()"/>
                  <![CDATA[</li></ul></p>]]>
                </xsl:when>
                <xsl:when test="not(number(@position) = 1) and number(@position) = number(@last)">
                  <!-- When not first but last point -->
                  <xsl:copy-of select="node()"/>
                  <![CDATA[</li></ul></p>]]>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:copy-of select="node()"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <!-- Start of Normal Value Content -->
          <xsl:copy-of select="node()"/>
          <!-- End of Normal Value Content -->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  <!-- End of Harmony-specific only -->

  <!-- Start of Generic Content Template -->
  <xsl:template match="/">
    <xsl:element name="div">
      <xsl:attribute name="id">hmy-template-holder</xsl:attribute>
      <!-- Start of Harmony template as of (31 August 2015) -->
      <xsl:element name="table">
        <xsl:attribute name="id">hmy-template</xsl:attribute>
        <xsl:element name="thead">
          <xsl:element name="tr">
            <xsl:element name="th">
              <xsl:attribute name="class">freezedpanes</xsl:attribute>
              SnP SKU
            </xsl:element>
            <xsl:element name="th">
              <xsl:attribute name="class">freezedpanes</xsl:attribute>
              Language
            </xsl:element>
            <xsl:element name="th">
              Std Description
            </xsl:element>
            <xsl:element name="th">
              Long (Mkt) Description
            </xsl:element>
            <xsl:element name="th">
              (Short) Tech Description
            </xsl:element>
            <xsl:call-template name="specs-pair-iterate">
              <xsl:with-param name="length" select="10"/>
              <xsl:with-param name="i" select="1"/>
            </xsl:call-template>
            <xsl:element name="th">
              Return Information
            </xsl:element>
            <xsl:element name="th">
              Warranty
            </xsl:element>
            <xsl:element name="th">
              Package Includes
            </xsl:element>
            <xsl:element name="th">
              Tech Support (Contact/Info)
            </xsl:element>
            <xsl:element name="th">
              URL for Product on Mfr Site
            </xsl:element>
            <xsl:element name="th">
              Service and Support
            </xsl:element>
            <xsl:element name="th">
              Case Studies
            </xsl:element>
            <xsl:element name="th">
              Total Cost of Ownership
            </xsl:element>
          </xsl:element>
        </xsl:element>
        <xsl:element name="tbody">

          <xsl:variable name="tokens">
            <xsl:call-template name="tokenize">
              <xsl:with-param name="string" select="$markets"/>
              <xsl:with-param name="pattern" select="','"/>
            </xsl:call-template>
          </xsl:variable>

          <!-- Start of Generic Content Grabber -->
          <!--<xsl:value-of select="system-property('xsl:vendor')"/>-->
          <xsl:variable name="path" select="concat('../content',$environment,'/data/products/',$categoryid,'/',$foldername,'/')"/>
          <xsl:choose>
            <xsl:when test="function-available('exslt:node-set')">
              <xsl:for-each select="exslt:node-set($tokens)/tokens:token">

                <xsl:variable name="country" select="substring(text(),4,2)"/>
                <xsl:variable name="language" select="substring(text(),1,2)"/>

                <!-- Start of retrieving source name -->
                <xsl:variable name="source">
                  <xsl:variable name="default" select="document(concat('../content',$environment,'/data/definitions/locales.xml'))/locales:locales/locales:country[@name=$country and locales:language=$language and locales:culture[@template='hmy' or not(@template)]]/locales:source"/>
                  <xsl:variable name="alt-language" select="document(concat('../content',$environment,'/data/definitions/locales.xml'))/locales:locales/locales:country[@name=$country]/locales:alt-language[locales:language=$language and locales:culture[@template='hmy' or not(@template)]]/locales:source"/>
                  <xsl:choose>
                    <xsl:when test="normalize-space($alt-language)">
                      <xsl:value-of select="$alt-language"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$default"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <!-- End of retrieving source name -->

                <xsl:if test="normalize-space($source)">
                  <!-- Unable to test if document physically available and return messaging -->
                  <xsl:apply-templates select="document(concat($path, $source ,'.xml'))/generic:root[last()]">
                    <xsl:with-param name="environment" select="$environment"/>
                    <xsl:with-param name="country" select="$country"/>
                    <xsl:with-param name="language" select="$language"/>
                    <xsl:with-param name="skutype" select="$skutype"/>
                    <xsl:with-param name="skuid" select="$skuid"/>
                  </xsl:apply-templates>
                </xsl:if>

              </xsl:for-each>
            </xsl:when>
            <xsl:when test="function-available('msxsl:node-set')">
              <xsl:for-each select="msxsl:node-set($tokens)/tokens:token">

                <xsl:variable name="country" select="substring(text(),4,2)"/>
                <xsl:variable name="language" select="substring(text(),1,2)"/>

                <!-- Start of retrieving source name -->
                <xsl:variable name="source">
                  <xsl:variable name="default" select="document(concat('../content',$environment,'/data/definitions/locales.xml'))/locales:locales/locales:country[@name=$country and locales:language=$language and locales:culture[@template='hmy' or not(@template)]]/locales:source"/>
                  <xsl:variable name="alt-language" select="document(concat('../content',$environment,'/data/definitions/locales.xml'))/locales:locales/locales:country[@name=$country]/locales:alt-language[locales:language=$language and locales:culture[@template='hmy' or not(@template)]]/locales:source"/>
                  <xsl:choose>
                    <xsl:when test="normalize-space($alt-language)">
                      <xsl:value-of select="$alt-language"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$default"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <!-- End of retrieving source name -->

                <xsl:if test="normalize-space($source)">
                  <!-- Unable to test if document physically available and return messaging -->
                  <xsl:apply-templates select="document(concat($path, $source ,'.xml'))/generic:root[last()]">
                    <xsl:with-param name="environment" select="$environment"/>
                    <xsl:with-param name="country" select="$country"/>
                    <xsl:with-param name="language" select="$language"/>
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
      <!-- End of Harmony template -->
    </xsl:element>
  </xsl:template>

  <xsl:template match="generic:root">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>

    <xsl:variable name="culture">
      <xsl:variable name="default" select="document(concat('../content',$environment,'/data/definitions/locales.xml'))/locales:locales/locales:country[@name=$country][locales:language=$language]/locales:culture[@template='hmy' or not(@template)]"/>
      <xsl:variable name="alt-language" select="document(concat('../content',$environment,'/data/definitions/locales.xml'))/locales:locales/locales:country[@name=$country]/locales:alt-language[locales:language=$language]/locales:culture[@template='hmy' or not(@template)]"/>
      <xsl:choose>
        <xsl:when test="normalize-space($alt-language)">
          <xsl:value-of select="$alt-language"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$default"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="normalize-space($culture)">
      <xsl:element name="tr">
        <xsl:element name="td">
          <!-- SnP SKU -->
          <xsl:value-of select="translate($skuid, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
        </xsl:element>
        <xsl:element name="td">
          <!-- Language -->
          <xsl:value-of select="$culture"/>
          <!--<xsl:value-of select="concat(translate(substring($culture,1,2), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'),'_',translate(substring($culture,4,2), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'))"/>-->
        </xsl:element>
        <xsl:element name="td">
          <xsl:attribute name="onMouseover">ddrivetip(this.innerText||this.textContent);</xsl:attribute>
          <xsl:attribute name="onMouseout">hideddrivetip();</xsl:attribute>
          <!-- Std Description -->
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
          <!-- Long (Mkt) Description -->
          <xsl:apply-templates select="generic:content/product:longdesc[last()]">
            <xsl:with-param name="environment" select="$environment"/>
            <xsl:with-param name="country" select="$country"/>
            <xsl:with-param name="language" select="$language"/>
            <xsl:with-param name="skutype" select="$skutype"/>
            <xsl:with-param name="skuid" select="$skuid"/>
          </xsl:apply-templates>
        </xsl:element>
        <xsl:element name="td">
          <!-- (Short) Tech Description -->

        </xsl:element>
        <!-- 10 Features and Benefits -->
        <xsl:apply-templates select="generic:content/product:highlights[last()]">
          <xsl:with-param name="environment" select="$environment"/>
          <xsl:with-param name="country" select="$country"/>
          <xsl:with-param name="language" select="$language"/>
          <xsl:with-param name="skutype" select="$skutype"/>
          <xsl:with-param name="skuid" select="$skuid"/>
        </xsl:apply-templates>
        <xsl:element name="td">
          <!-- Return Information -->

        </xsl:element>
        <xsl:element name="td">
          <!-- Warranty -->

        </xsl:element>
        <xsl:element name="td">
          <!-- Package Includes -->

        </xsl:element>
        <xsl:element name="td">
          <!-- Tech Support (Contact/Info) -->

        </xsl:element>
        <xsl:element name="td">
          <!-- URL for Product on Mfr Site -->

        </xsl:element>
        <xsl:element name="td">
          <!-- Service and Support -->

        </xsl:element>
        <xsl:element name="td">
          <!-- Case Studies -->

        </xsl:element>
        <xsl:element name="td">
          <!-- Total Cost of Ownership -->

        </xsl:element>
      </xsl:element>
    </xsl:if>

  </xsl:template>
  <!-- End of Generic Content Template -->

</xsl:stylesheet>

