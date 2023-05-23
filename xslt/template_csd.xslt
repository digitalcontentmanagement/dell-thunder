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
  <xsl:param name="csvdata"/>
  
  <!-- Start of Content Studio-specific only -->
   <xsl:template match="product:highlights">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>

    <xsl:apply-templates select="content:points|content:para">
      <xsl:with-param name="environment" select="$environment"/>
      <xsl:with-param name="country" select="$country"/>
      <xsl:with-param name="language" select="$language"/>
      <xsl:with-param name="skutype" select="$skutype"/>
      <xsl:with-param name="skuid" select="$skuid"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="content:points">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <!-- Start of Point Content (content) -->
    <xsl:variable name="feature_value">
        <xsl:apply-templates select="content:point">
        <xsl:with-param name="environment" select="$environment"/>
        <xsl:with-param name="country" select="$country"/>
        <xsl:with-param name="language" select="$language"/>
        <xsl:with-param name="skutype" select="$skutype"/>
        <xsl:with-param name="skuid" select="$skuid"/>
      </xsl:apply-templates>
    </xsl:variable>
    <!-- End of Point Content (content) -->
    <xsl:choose>
      <xsl:when test="normalize-space(@title)">
        <!-- Start of Point Content (title) -->
        <xsl:variable name="title">
          <xsl:call-template name="string-look-up-formula-expression">
            <xsl:with-param name="value" select="normalize-space(@title)"/>
            <xsl:with-param name="environment" select="$environment"/>
            <xsl:with-param name="country" select="$country"/>
            <xsl:with-param name="language" select="$language"/>
            <xsl:with-param name="skuid" select="$skuid"/>
          </xsl:call-template>
        </xsl:variable>
        <!-- End of Point Content (title) -->
        <xsl:choose>
          <xsl:when test="normalize-space($title) and normalize-space($feature_value)">
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
			  <![CDATA[<ul>]]>
              <xsl:copy-of select="$feature_value"/>
			  <![CDATA[</ul>]]>
          </xsl:when>
          <xsl:otherwise>
			<![CDATA[<ul>]]>
            <xsl:copy-of select="$feature_value"/>
			<![CDATA[</ul>]]>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
		<![CDATA[<ul>]]>
        <xsl:copy-of select="$feature_value"/>
		<![CDATA[</ul>]]>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- End of Content Studio-specific only -->

  <!-- Start of Generic Content Template -->
  <xsl:template match="/">
    <xsl:element name="div">
      <xsl:attribute name="id">csd-template-holder</xsl:attribute>
      <!-- Start of Content Studio template as of (23 August 2017) -->
      <xsl:element name="table">
        <xsl:attribute name="id">csd-template</xsl:attribute>
        <xsl:element name="thead">
          <xsl:element name="tr">
            <xsl:element name="th">
              <xsl:attribute name="class">freezedpanes</xsl:attribute>
              ContentTypeName
            </xsl:element>
            <xsl:element name="th">
              <xsl:attribute name="class">freezedpanes</xsl:attribute>
              Id
            </xsl:element>
            <xsl:element name="th">
			  <xsl:attribute name="class">freezedpanes</xsl:attribute>
              Key
            </xsl:element>
            <xsl:element name="th">
			  <xsl:attribute name="class">freezedpanes</xsl:attribute>
              Container
            </xsl:element>
            <xsl:element name="th">
              <xsl:attribute name="class">freezedpanes</xsl:attribute>
			  Update
            </xsl:element>
            <xsl:element name="th">
			  PublishStatus
            </xsl:element>
            <xsl:element name="th">
              ManufacturerPn
            </xsl:element>
            <xsl:element name="th">
              ShortDescOverride
            </xsl:element>
            <xsl:element name="th">
              ShortDescOverrideFlag
            </xsl:element>
            <xsl:element name="th">
              LongDescOverride
            </xsl:element>
            <xsl:element name="th">
              LongDescOverrideFlag
            </xsl:element>
            <xsl:element name="th">
              KSPContentOverride
            </xsl:element>
            <xsl:element name="th">
              KSPContentOverrideFlag
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
		  
		  <!-- Parsing XML string to XML nodes -->
		  <xsl:variable name="parsedXml">
			<xsl:call-template name="parseXml">
			  <xsl:with-param name="text" select="$csvdata"/>
			</xsl:call-template>
		  </xsl:variable>

		  <!-- Sorting to priortize SID first then DID -->
		  <xsl:variable name="csv_data">
			<xsl:element name="csvdata">
				<xsl:apply-templates select="exslt:node-set($parsedXml)/csvdata">
					<xsl:sort select="@key" order="descending"/>
				</xsl:apply-templates>
			</xsl:element>
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
                  <xsl:variable name="default" select="document(concat('../content',$environment,'/data/definitions/locales.xml'))/locales:locales/locales:country[@name=$country and locales:language=$language and locales:culture[@template='csd' or not(@template)]]/locales:source"/>
                  <xsl:variable name="alt-language" select="document(concat('../content',$environment,'/data/definitions/locales.xml'))/locales:locales/locales:country[@name=$country]/locales:alt-language[locales:language=$language and locales:culture[@template='csd' or not(@template)]]/locales:source"/>
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
					<xsl:with-param name="csvdata" select="$csv_data"/>
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
                  <xsl:variable name="default" select="document(concat('../content',$environment,'/data/definitions/locales.xml'))/locales:locales/locales:country[@name=$country and locales:language=$language and locales:culture[@template='csd' or not(@template)]]/locales:source"/>
                  <xsl:variable name="alt-language" select="document(concat('../content',$environment,'/data/definitions/locales.xml'))/locales:locales/locales:country[@name=$country]/locales:alt-language[locales:language=$language and locales:culture[@template='csd' or not(@template)]]/locales:source"/>
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
					<xsl:with-param name="csvdata" select="$csv_data"/>
                  </xsl:apply-templates>
                </xsl:if>

              </xsl:for-each>
            </xsl:when>
          </xsl:choose>
          <!-- End of Generic Content Grabber -->

        </xsl:element>
      </xsl:element>
      <!-- End of Content Studio template -->
    </xsl:element>
  </xsl:template>

  <xsl:template match="generic:root">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
	<xsl:param name="csvdata"/>

    <xsl:variable name="culture">
      <xsl:variable name="default" select="document(concat('../content',$environment,'/data/definitions/locales.xml'))/locales:locales/locales:country[@name=$country][locales:language=$language]/locales:culture[@template='csd' or not(@template)]"/>
      <xsl:variable name="alt-language" select="document(concat('../content',$environment,'/data/definitions/locales.xml'))/locales:locales/locales:country[@name=$country]/locales:alt-language[locales:language=$language]/locales:culture[@template='csd' or not(@template)]"/>
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
	  <xsl:variable name="cs_culture" select="concat(translate(substring($culture,1,2), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'),'-',translate(substring($culture,4,2), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'))"/>
      <xsl:element name="tr">
        <xsl:element name="td">
          <!-- ContentTypeName -->
 		  <xsl:choose>
			<xsl:when test="function-available('exslt:node-set')">
				<xsl:value-of select="exslt:node-set($csvdata)/csvdata/row[@container=$cs_culture]/@contenttypename"/>
			</xsl:when>
            <xsl:when test="function-available('msxsl:node-set')">
				<xsl:value-of select="msxsl:node-set($csvdata)/csvdata/row[@container=$cs_culture]/@contenttypename"/>
			</xsl:when>
		  </xsl:choose>
        </xsl:element>
		<xsl:element name="td">
          <!-- Id -->
		  <xsl:choose>
			<xsl:when test="function-available('exslt:node-set')">
				<xsl:value-of select="exslt:node-set($csvdata)/csvdata/row[@container=$cs_culture]/@id"/>
			</xsl:when>
            <xsl:when test="function-available('msxsl:node-set')">
				<xsl:value-of select="msxsl:node-set($csvdata)/csvdata/row[@container=$cs_culture]/@id"/>
			</xsl:when>
		  </xsl:choose>
        </xsl:element>
		<xsl:element name="td">
          <!-- Key -->
		  <xsl:choose>
			<xsl:when test="function-available('exslt:node-set')">
				<xsl:value-of select="exslt:node-set($csvdata)/csvdata/row[@container=$cs_culture]/@key"/>
			</xsl:when>
            <xsl:when test="function-available('msxsl:node-set')">
				<xsl:value-of select="msxsl:node-set($csvdata)/csvdata/row[@container=$cs_culture]/@key"/>
			</xsl:when>
		  </xsl:choose>         
        </xsl:element>
        <xsl:element name="td">
          <!-- Container -->
          <xsl:value-of select="$cs_culture"/>
        </xsl:element>
		<xsl:element name="td">
          <!-- Update -->
          TRUE
        </xsl:element>
		<xsl:element name="td">
          <!-- PublishStatus -->
          TRUE
        </xsl:element>
		<xsl:element name="td">
          <!-- ManufacturerPn -->
 		  <xsl:choose>
			<xsl:when test="function-available('exslt:node-set')">
				<xsl:value-of select="exslt:node-set($csvdata)/csvdata/row[@container=$cs_culture]/@manufacturerpn"/>
			</xsl:when>
            <xsl:when test="function-available('msxsl:node-set')">
				<xsl:value-of select="msxsl:node-set($csvdata)/csvdata/row[@container=$cs_culture]/@manufacturerpn"/>
			</xsl:when>
		  </xsl:choose>         
        </xsl:element>

		<!-- Start of Product Name -->
		<xsl:variable name="product_name">
          <xsl:apply-templates select="generic:content/product:name[last()]">
            <xsl:with-param name="environment" select="$environment"/>
            <xsl:with-param name="country" select="$country"/>
            <xsl:with-param name="language" select="$language"/>
            <xsl:with-param name="skutype" select="$skutype"/>
            <xsl:with-param name="skuid" select="$skuid"/>
          </xsl:apply-templates>
		</xsl:variable>
        <xsl:element name="td">
          <xsl:attribute name="onMouseover">ddrivetip(this.innerText||this.textContent);</xsl:attribute>
          <xsl:attribute name="onMouseout">hideddrivetip();</xsl:attribute>
          <!-- ShortDescOverride -->
		  <xsl:if test="normalize-space($product_name)">
			<xsl:copy-of select="$product_name"/>
		  </xsl:if>
        </xsl:element>
		<xsl:element name="td">
          <!-- ShortDescOverrideFlag -->
		  <xsl:choose>
			<xsl:when test="normalize-space($product_name)">
				Yes
			</xsl:when>
			<xsl:otherwise>
				No
			</xsl:otherwise>
		  </xsl:choose>
        </xsl:element>
		<!-- End of Product Name -->

		<!-- Start of Product Long Description -->
		<xsl:variable name="product_longdesc">
		  <xsl:apply-templates select="generic:content/product:longdesc[last()]">
            <xsl:with-param name="environment" select="$environment"/>
            <xsl:with-param name="country" select="$country"/>
            <xsl:with-param name="language" select="$language"/>
            <xsl:with-param name="skutype" select="$skutype"/>
            <xsl:with-param name="skuid" select="$skuid"/>
          </xsl:apply-templates>
		</xsl:variable>
        <xsl:element name="td">
          <xsl:attribute name="onMouseover">ddrivetip(this.innerText||this.textContent);</xsl:attribute>
          <xsl:attribute name="onMouseout">hideddrivetip();</xsl:attribute>
          <!-- LongDescOverride -->
		  <xsl:if test="normalize-space($product_longdesc)">
			 <xsl:copy-of select="$product_longdesc"/>
		  </xsl:if>
        </xsl:element>
		<xsl:element name="td">
          <!-- LongDescOverrideFlag -->
		  <xsl:choose>
			<xsl:when test="normalize-space($product_longdesc)">
				Yes
			</xsl:when>
			<xsl:otherwise>
				No
			</xsl:otherwise>
		  </xsl:choose>
        </xsl:element>
		<!-- End of Product Long Description -->

		<!-- Start of Product Highlights -->
		<xsl:variable name="product_highlights">
		  <xsl:apply-templates select="generic:content/product:highlights[last()]">
			<xsl:with-param name="environment" select="$environment"/>
			<xsl:with-param name="country" select="$country"/>
			<xsl:with-param name="language" select="$language"/>
			<xsl:with-param name="skutype" select="$skutype"/>
			<xsl:with-param name="skuid" select="$skuid"/>
		  </xsl:apply-templates>
		</xsl:variable>
        <xsl:element name="td">
          <xsl:attribute name="onMouseover">ddrivetip(this.innerText||this.textContent);</xsl:attribute>
          <xsl:attribute name="onMouseout">hideddrivetip();</xsl:attribute>
          <!-- KSPContentOverride -->
		  <xsl:if test="normalize-space($product_highlights)">
			 <xsl:copy-of select="$product_highlights"/>
		  </xsl:if>
        </xsl:element>
        <xsl:element name="td">
          <!-- KSPContentOverrideFlag -->
		  <xsl:choose>
			<xsl:when test="normalize-space($product_highlights)">
				Yes
			</xsl:when>
			<xsl:otherwise>
				No
			</xsl:otherwise>
		  </xsl:choose>
        </xsl:element>
		<!-- End of Product Highlights -->
      </xsl:element>
    </xsl:if>

  </xsl:template>
  <!-- End of Generic Content Template -->

  <!-- Start of sorting SID nodes first then DID -->
  <xsl:template match="csvdata/row">
	<xsl:element name="row">
		<xsl:attribute name="contenttypename">
			<xsl:value-of select="@contenttypename"/>
		</xsl:attribute>
		<xsl:attribute name="id">
			<xsl:value-of select="@id"/>
		</xsl:attribute>
		<xsl:attribute name="key">
			<xsl:value-of select="@key"/>
		</xsl:attribute>
		<xsl:attribute name="container">
			<xsl:value-of select="@container"/>
		</xsl:attribute>
		<xsl:attribute name="manufacturerpn">
			<xsl:value-of select="@manufacturerpn"/>
		</xsl:attribute>
	</xsl:element>
  </xsl:template>
  <!-- End of sorting SID nodes first then DID -->

</xsl:stylesheet>

