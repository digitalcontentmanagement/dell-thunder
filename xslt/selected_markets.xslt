<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:locales="http://www.dell.com/thunder/locales" xmlns:tokens="http://www.dell.com/thunder/tokens" xmlns:exslt="http://exslt.org/common" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="exslt msxsl">
  <xsl:include href="utilities.xslt"/>
  <xsl:output method="html" indent="yes" encoding="utf-8" media-type="text/xml" />
  <xsl:param name="region"/>
  <xsl:param name="markets"/>
  
  <xsl:template match="/">
 
	<xsl:element name="span">
		<xsl:attribute name="id">selected_markets</xsl:attribute>
    
		  <xsl:variable name="tokens">
			 <xsl:call-template name="tokenize">
			   <xsl:with-param name="string" select="$markets"/>
			   <xsl:with-param name="pattern" select="','"/>
			 </xsl:call-template>
		  </xsl:variable>
	  
		  <!-- Get this document -->
		  <xsl:variable name="current" select="current()"/>

		  <xsl:choose>
            <xsl:when test="function-available('exslt:node-set')">

			  <!-- Start of retrieving culture -->
			  <xsl:for-each select="exslt:node-set($tokens)/tokens:token">

				   <xsl:variable name="country" select="substring(text(),4,2)"/>
				   <xsl:variable name="language" select="substring(text(),1,2)"/>

				   <xsl:variable name="default" select="$current/locales:locales/locales:country[@name=$country][locales:language=$language]/locales:culture[@template='csd' or not(@template)]"/>
				   <xsl:variable name="alt-language" select="$current/locales:locales/locales:country[@name=$country]/locales:alt-language[locales:language=$language]/locales:culture[@template='csd' or not(@template)]"/>
		
				   <xsl:variable name="culture">
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
					   <xsl:value-of select="concat(translate(substring($culture,1,2), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'),'-',translate(substring($culture,4,2), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'))"/>
					   <xsl:if test="not(position() = last())">
							<xsl:value-of select="','"/>
					   </xsl:if>
				   </xsl:if>

			  </xsl:for-each>			
			  <!-- End of retrieving culture -->

		    </xsl:when>
            <xsl:when test="function-available('msxsl:node-set')">

			  <!-- Start of retrieving culture -->
			  <xsl:for-each select="msxsl:node-set($tokens)/tokens:token">

				   <xsl:variable name="country" select="substring(text(),4,2)"/>
				   <xsl:variable name="language" select="substring(text(),1,2)"/>

				   <xsl:variable name="default" select="$current/locales:locales/locales:country[@name=$country][locales:language=$language]/locales:culture[@template='csd' or not(@template)]"/>
				   <xsl:variable name="alt-language" select="$current/locales:locales/locales:country[@name=$country]/locales:alt-language[locales:language=$language]/locales:culture[@template='csd' or not(@template)]"/>
		
				   <xsl:variable name="culture">
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
					   <xsl:value-of select="concat(translate(substring($culture,1,2), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'),'-',translate(substring($culture,4,2), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'))"/>
					   <xsl:if test="not(position() = last())">
							<xsl:value-of select="','"/>
					   </xsl:if>				   
				   </xsl:if>

			  </xsl:for-each>			
			  <!-- End of retrieving culture -->

            </xsl:when>
          </xsl:choose>

	  </xsl:element>
  </xsl:template>

</xsl:stylesheet>

