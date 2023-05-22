<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:content="http://www.dell.com/thunder/content" xmlns:locales="http://www.dell.com/thunder/locales" xmlns:tokens="http://www.dell.com/thunder/tokens" xmlns:exslt="http://exslt.org/common" xmlns:regexp="http://exslt.org/regular-expressions" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="exslt regexp msxsl">

  <!--// http://dpcarlisle.blogspot.my/2007/05/exslt-node-set-function.html -->
  <!--// http://stackoverflow.com/questions/92076/how-to-use-node-set-function-in-a-platform-independent-way -->
  <msxsl:script language="JScript" implements-prefix="exslt">
    this['node-set'] =  function (x) {
    return x;
    }
  </msxsl:script>

  <!--// https://xml.web.cern.ch/XML/www.exslt.org/regexp/index.html -->
  <msxsl:script language="JavaScript" implements-prefix="regexp">
    <![CDATA[
      /**
      <doc:module date="2001-06-12">
         <doc:module>exslt:regular-expressions</doc:module>
         <doc:name>regExp</doc:name>
         <doc:version>1.0</doc:version>
         <doc:language>exslt:javascript</doc:language>
         <doc:meta>
            <doc:author email="chris@bayes.co.uk" url="http://www.bayes.co.uk">Chris Bayes</doc:author>
            <doc:summary>Implementation of EXSLT - RegExp (http://www.exslt.org/regExp)</doc:summary>
            <doc:todo></doc:todo>
         </doc:meta>
      </doc:module>
      **/
      /**
      <doc:function date="2001-06-12">
	      <doc:name>replace</doc:name>
	      <doc:version>1.0</doc:version>
	      <doc:return type="string" />
	      <doc:args>
		      <doc:arg name="context" type="context" default="null" optional="no"></doc:arg>
		      <doc:arg name="regExp" type="string" default="''" optional="no"></doc:arg>
		      <doc:arg name="flags" type="string" default="''" optional="no"></doc:arg>
		      <doc:arg name="repStr" type="string" default="''" optional="no"></doc:arg>
	      </doc:args>
      </doc:function>
      **/

      function   _wander(ctx){
	      var retStr = "";
	      for (var i=0; i < ctx.childNodes.length; i++){
		      ctxN = ctx.childNodes[i];
		      switch(ctxN.nodeType){
			      case 1:
				      retStr +=   _wander(ctxN);
				      break;
			      case 3:
				      retStr += ctxN.nodeValue;
				      break;
			      default:
				      break;
		      }
	      }
	      return retStr;
      }
      
      function replace(ctx, re, flags, repStr){
	      var ipString = "";
	      if (typeof(ctx) == "object"){
		      if (ctx.length){
			      for (var i=0; i < 1; i++){
				      ctxN  = ctx.item(i);
				      if (ctxN.nodeType == 1){
					      ipString +=   _wander(ctxN);
				      }
				      if (ctxN.nodeType == 2){
					      ipString += ctxN.nodeValue;
				      }
			      }
		      }else{
			      return '';
		      }
	      }else{
		      ipString = ctx;
	      }
	      var re = new RegExp(re, flags);
	      return ipString.replace(re, repStr);
      }
      
      /**
      <doc:function date="2001-06-12">
	      <doc:name>test</doc:name>
	      <doc:version>1.0</doc:version>
	      <doc:return type="boolean" />
	      <doc:args>
		      <doc:arg name="context" type="context" default="null" optional="no"></doc:arg>
		      <doc:arg name="regExp" type="string" default="''" optional="no"></doc:arg>
		      <doc:arg name="flags" type="string" default="''" optional="no"></doc:arg>
	      </doc:args>
      </doc:function>
      **/
      function test(ctx, re, flags){
	      var ipString = "";
	      if (typeof(ctx) == "object"){
		      if (ctx.length){
			      for (var i=0; i < 1; i++){
				      ctxN  = ctx.item(i);
				      if (ctxN.nodeType == 1){
					      ipString +=   _wander(ctxN);
				      }
				      if (ctxN.nodeType == 2){
					      ipString += ctxN.nodeValue;
				      }
			      }
		      }else{
			      return false;
		      }
	      }else{
		      ipString = ctx;
	      }
	      var oRe = new RegExp(re, flags);
	      return oRe.test(ipString);
      }
      
      /**
      <doc:function date="2001-06-12">
	      <doc:name>match</doc:name>
	      <doc:version>1.0</doc:version>
	      <doc:return type="node-set" />
	      <doc:args>
		      <doc:arg name="context" type="node-set" default="null" optional="no"></doc:arg>
		      <doc:arg name="regExp" type="string" default="''" optional="no"></doc:arg>
		      <doc:arg name="flags" type="string" default="''" optional="no"></doc:arg>
	      </doc:args>
      </doc:function>
      **/
      function match(ctx, re, flags){
	      var ipString = "";
	      if (typeof(ctx) == "object"){
		      if (ctx.length){
			      for (var i=0; i < 1; i++){
				      ctxN  = ctx.item(i);
				      if (ctxN.nodeType == 1){
					      ipString +=  _wander(ctxN);
				      }
				      if (ctxN.nodeType == 2){
					      ipString += ctxN.nodeValue;
				      }
			      }
		      }else{
			      return ctx;// empty set
		      }
	      }else{
		      ipString = ctx;
	      }
	      var tdom = new ActiveXObject("MSXML2.FreeThreadedDOMDocument");
	      var od = tdom.createNode(1, 'myRE', '');
	      var oRe = new RegExp(re, flags);

	      var parts,tmp='';
	      if ((parts = ipString.match(oRe)) != null){
		      //return parts.length;
		      for (var i=0; i < parts.length; i++){
			      tmp+=parts[i]+';';
			      var mn = tdom.createNode(1, 'match', '');
			      var tn = tdom.createTextNode(parts[i]);
			      mn = od.appendChild(mn);
			      tn = mn.appendChild(tn);
		      }
		      //return tmp
		      return od.selectNodes("*");
	      }else{
		      return od.selectNodes("*");
	      }
      }
      ]]>
  </msxsl:script>

  <!--// To parse string lookup formula expression -->
  <xsl:template name="string-look-up-formula-expression">
    <xsl:param name="value"/>
    <xsl:param name="environment"/>
    <xsl:param name="skutype"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:variable name="ref">
      <xsl:choose>
        <xsl:when test="normalize-space(substring-after(substring-before($value,','),'@string('))">
          <xsl:value-of select="normalize-space(substring-after(substring-before($value,','),'@string('))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space(substring-after(substring-before($value,')'),'@string('))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="localefile" select="normalize-space(substring-before(substring-after($value,','),')'))"/>
    <xsl:choose>
      <xsl:when test="normalize-space($ref) or (normalize-space($ref) and $localefile)">
        <xsl:call-template name="string-look-up">
          <xsl:with-param name="ref" select="normalize-space($ref)"/>
          <xsl:with-param name="localefile" select="$localefile"/>
          <xsl:with-param name="environment" select="$environment"/>
          <xsl:with-param name="skutype" select="$skutype"/>
          <xsl:with-param name="country" select="$country"/>
          <xsl:with-param name="language" select="$language"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$value"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--// To string look up the locales -->
  <xsl:template name="string-look-up">
    <xsl:param name="ref"/>
    <xsl:param name="values"/>
    <xsl:param name="localefile"/>
    <xsl:param name="environment"/>
    <xsl:param name="skutype"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>

    <xsl:variable name="stringlookup">
      <xsl:element name="content:stringlookup">
        <xsl:if test="normalize-space($ref)">
          <xsl:attribute name="ref">
            <xsl:value-of select="$ref"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="normalize-space($values)">
          <xsl:attribute name="values">
            <xsl:value-of select="normalize-space($values)"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="normalize-space($localefile)">
          <xsl:attribute name="localefile">
            <xsl:value-of select="$localefile"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="normalize-space($skutype)">
          <xsl:attribute name="skutype">
            <xsl:value-of select="$skutype"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:element>
    </xsl:variable>

    <xsl:variable name="string">
      <xsl:choose>
        <xsl:when test="function-available('exslt:node-set')">
          <xsl:apply-templates select="exslt:node-set($stringlookup)/content:stringlookup">
            <xsl:with-param name="country" select="$country"/>
            <xsl:with-param name="language" select="$language"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="function-available('msxsl:node-set')">
          <xsl:apply-templates select="msxsl:node-set($stringlookup)/content:stringlookup">
            <xsl:with-param name="country" select="$country"/>
            <xsl:with-param name="language" select="$language"/>
          </xsl:apply-templates>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="normalize-space($string)" disable-output-escaping="yes"/>
  </xsl:template>

  <!--// To split the nodes into nodeset -->
  <xsl:template name="tokenize">
    <xsl:param name="string"/>
    <xsl:param name="pattern"/>
    <xsl:choose>
      <xsl:when test="contains($string, $pattern)">
        <xsl:if test="not(starts-with($string, $pattern))">
          <xsl:element name="tokens:token">
            <xsl:value-of select="normalize-space(substring-before($string, $pattern))"/>
          </xsl:element>
        </xsl:if>
        <xsl:call-template name="tokenize">
          <xsl:with-param name="string" select="substring-after($string,$pattern)"/>
          <xsl:with-param name="pattern" select="$pattern"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="normalize-space($string)">
          <xsl:element name="tokens:token">
            <xsl:value-of select="normalize-space($string)" />
          </xsl:element>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--// To replace specific character -->
  <xsl:template name="string-replace-all">
    <xsl:param name="text"/>
    <xsl:param name="replace"/>
    <xsl:param name="by"/>
    <xsl:choose>
      <xsl:when test="contains($text,$replace)">
        <xsl:value-of select="substring-before($text,$replace)"/>
        <xsl:value-of select="$by"/>
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text" select="substring-after($text,$replace)"/>
          <xsl:with-param name="replace" select="$replace"/>
          <xsl:with-param name="by" select="$by"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="normalize-space($text)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--// To replace expression character {0} {1} ... by array of string Hello|World separated by pipeline with respective order -->
  <xsl:template name="expression-string-replace-all">
    <!-- Hello World! {0} -->
    <xsl:param name="text"/>
    <!-- {0} For looping usage only usually (Not for call-template) -->
    <xsl:param name="replace" select="0"/>
    <!-- Michael -->
    <xsl:param name="by"/>
    <xsl:variable name="pattern" select="'|'"/>
    <xsl:choose>
      <xsl:when test="contains($text,concat('{',$replace,'}')) and normalize-space($by)">
        <xsl:value-of select="substring-before($text,concat('{',$replace,'}'))"/>
        <xsl:variable name="replaceby">
          <xsl:choose>
            <xsl:when test="contains($by,$pattern)">
              <xsl:value-of select="substring-before($by,$pattern)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$by"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$replaceby"/>
        <xsl:call-template name="expression-string-replace-all">
          <xsl:with-param name="text" select="substring-after($text,concat('{',$replace,'}'))"/>
          <xsl:with-param name="replace" select="$replace + 1"/>
          <xsl:with-param name="by" select="substring-after($by,$pattern)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--//Evaluate if it has node returned, either text or element-->
  <xsl:template name="contains-elements">
    <xsl:param name="nodes"/>
    <xsl:choose>
      <xsl:when test="function-available('exslt:node-set')">
        <xsl:if test="exslt:node-set($nodes)/*">true</xsl:if>
      </xsl:when>
      <xsl:when test="function-available('msxsl:node-set')">
        <xsl:if test="msxsl:node-set($nodes)/*">true</xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:template>  
  
  <!-- // Content Filter Attribute -->
  <xsl:template match="content:*[@filter]">
    <xsl:param name="environment"/>
    <xsl:param name="country"/>
    <xsl:param name="language"/>
    <xsl:param name="region"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>

    <xsl:variable name="content">
      <xsl:element name="{local-name()}" namespace="{namespace-uri(current())}">
        <xsl:for-each select="@*">
          <xsl:if test="not(name(.)='filter')">
            <xsl:attribute name="{name(.)}">
              <xsl:value-of select="."/>
            </xsl:attribute>
          </xsl:if>
        </xsl:for-each>
        <xsl:copy-of select="node()|text()"/>
      </xsl:element>
    </xsl:variable>
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
    <xsl:variable name="result">
      <xsl:call-template name="conditional-filter">
        <xsl:with-param name="expression" select="@filter"/>
        <xsl:with-param name="environment" select="$environment"/>
        <xsl:with-param name="region" select="$this_region"/>
        <xsl:with-param name="skutype" select="$skutype"/>
        <xsl:with-param name="skuid" select="$skuid"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$result='true'">
      <xsl:choose>
        <xsl:when test="function-available('exslt:node-set')">
          <xsl:apply-templates select="exslt:node-set($content)/*">
            <xsl:with-param name="environment" select="$environment"/>
            <xsl:with-param name="country" select="$country"/>
            <xsl:with-param name="language" select="$language"/>
            <xsl:with-param name="region" select="$this_region"/>
            <xsl:with-param name="skutype" select="$skutype"/>
            <xsl:with-param name="skuid" select="$skuid"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="function-available('msxsl:node-set')">
          <xsl:apply-templates select="msxsl:node-set($content)/*">
            <xsl:with-param name="environment" select="$environment"/>
            <xsl:with-param name="country" select="$country"/>
            <xsl:with-param name="language" select="$language"/>
            <xsl:with-param name="region" select="$this_region"/>
            <xsl:with-param name="skutype" select="$skutype"/>
            <xsl:with-param name="skuid" select="$skuid"/>
          </xsl:apply-templates>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!-- // Conditional filter $(sku.type) | $(sku.format) | $(locale.region) -->
  <xsl:template name="conditional-filter">
    <xsl:param name="expression"/>
    <xsl:param name="environment"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <xsl:param name="region"/>
    <xsl:variable name="parsed_expression">
      <xsl:call-template name="logical-parser">
        <xsl:with-param name="expression" select="normalize-space($expression)"/>
        <xsl:with-param name="environment" select="$environment"/>
        <xsl:with-param name="region" select="$region"/>
        <xsl:with-param name="skutype" select="$skutype"/>
        <xsl:with-param name="skuid" select="$skuid"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="contains($parsed_expression, 'false $or$ true') or contains($parsed_expression, 'true $or$ false')">
        <xsl:choose>
          <xsl:when test="contains(regexp:replace(regexp:replace($parsed_expression, 'false $or$ true', 'gi', 'true'), 'true $or$ false', 'gi', 'true'), 'false')">
            <xsl:value-of select="boolean(false)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="not(boolean(false))"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <!-- Must only contains $and$ logical operators, so any false equals to false -->
          <xsl:when test="contains($parsed_expression, 'false')">
            <xsl:value-of select="boolean(false)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="not(boolean(false))"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Start of Conditional Operators -->
  <xsl:template name="logical-parser">
    <xsl:param name="expression"/>
    <xsl:param name="environment"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <xsl:param name="region"/>
    <xsl:if test="normalize-space($expression)">
      <xsl:choose>
        <xsl:when test="contains($expression, ' $and$ ')">
          <xsl:call-template name="thunder-variables">
            <xsl:with-param name="expression" select="substring-before($expression,' $and$ ')"/>
            <xsl:with-param name="environment" select="$environment"/>
            <xsl:with-param name="region" select="$region"/>
            <xsl:with-param name="skutype" select="$skutype"/>
            <xsl:with-param name="skuid" select="$skuid"/>
          </xsl:call-template>
          <xsl:value-of select="' $and$ '"/>
          <xsl:call-template name="logical-parser">
            <xsl:with-param name="expression" select="substring-after($expression,' $and$ ')"/>
            <xsl:with-param name="environment" select="$environment"/>
            <xsl:with-param name="region" select="$region"/>
            <xsl:with-param name="skutype" select="$skutype"/>
            <xsl:with-param name="skuid" select="$skuid"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="contains($expression, ' $or$ ')">
          <xsl:call-template name="thunder-variables">
            <xsl:with-param name="expression" select="substring-before($expression,' $or$ ')"/>
            <xsl:with-param name="environment" select="$environment"/>
            <xsl:with-param name="region" select="$region"/>
            <xsl:with-param name="skutype" select="$skutype"/>
            <xsl:with-param name="skuid" select="$skuid"/>
          </xsl:call-template>
          <xsl:value-of select="' $or$ '"/>
          <xsl:call-template name="logical-parser">
            <xsl:with-param name="expression" select="substring-after($expression,' $or$ ')"/>
            <xsl:with-param name="environment" select="$environment"/>
            <xsl:with-param name="region" select="$region"/>
            <xsl:with-param name="skutype" select="$skutype"/>
            <xsl:with-param name="skuid" select="$skuid"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="thunder-variables">
            <xsl:with-param name="expression" select="$expression"/>
            <xsl:with-param name="environment" select="$environment"/>
            <xsl:with-param name="region" select="$region"/>
            <xsl:with-param name="skutype" select="$skutype"/>
            <xsl:with-param name="skuid" select="$skuid"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template name="thunder-variables">
    <xsl:param name="expression"/>
    <xsl:param name="environment"/>
    <xsl:param name="skutype"/>
    <xsl:param name="skuid"/>
    <xsl:param name="region"/>
    <xsl:choose>
      <xsl:when test="contains($expression, '$(sku.type)')">
        <xsl:call-template name="logical-operator">
          <xsl:with-param name="expression" select="$expression"/>
          <xsl:with-param name="variable_value" select="$skutype"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($expression, '$(locale.region)')">
        <xsl:call-template name="logical-operator">
          <xsl:with-param name="expression" select="$expression"/>
          <xsl:with-param name="variable_value" select="$region"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($expression, '$(sku.format)')">
        <xsl:call-template name="logical-operator">
          <xsl:with-param name="expression" select="$expression"/>
          <xsl:with-param name="variable_value" select="$skuid"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="logical-operator">
    <xsl:param name="expression"/>
    <xsl:param name="variable_value"/>
    <xsl:choose>
      <xsl:when test="contains($expression, ' $in$ ') or contains($expression, ' $not$ $in$ ')">
        <xsl:variable name="conditional_operator">
          <xsl:choose>
            <xsl:when test="contains($expression, ' $not$ $in$ ')">
              <xsl:value-of select="'$not$ $in$'"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'$in$'"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="expression_variable" select="normalize-space(regexp:replace(substring-before($expression , concat(' ', normalize-space($conditional_operator), ' ')), '\$\((sku\.type|sku\.format|locale\.region)\)', 'g', string($variable_value)))"/>
        <xsl:variable name="expression_values" select="normalize-space(substring-after($expression , concat(' ', normalize-space($conditional_operator), ' ')))"/>
        <xsl:choose>
          <xsl:when test="contains($expression, ' $not$ $in$ ')">
            <xsl:value-of select="not(contains($expression_values, $expression_variable))"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="contains($expression_values, $expression_variable)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="contains($expression, ' $eq$ ') or contains($expression, ' $not$ $eq$ ')">
        <xsl:variable name="conditional_operator">
          <xsl:choose>
            <xsl:when test="contains($expression, ' $not$ $eq$ ')">
              <xsl:value-of select="'$not$ $eq$'"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'$eq$'"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="expression_variable_quotes" select="normalize-space(regexp:replace(substring-before($expression , concat(' ', normalize-space($conditional_operator), ' ')), '\$\((sku\.type|sku\.format|locale\.region)\)', 'g', string($variable_value)))"/>
        <xsl:variable name="expression_values_quotes" select="normalize-space(substring-after($expression , concat(' ', normalize-space($conditional_operator), ' [')))"/>
        <xsl:variable name="expression_variable" select="substring($expression_variable_quotes, 2, string-length($expression_variable_quotes)-2)"/>
        <xsl:variable name="expression_values" select="substring($expression_values_quotes, 2, string-length($expression_values_quotes)-3)"/>
        <!-- Remove last single quote set value as 3 -->
        <xsl:choose>
          <xsl:when test="contains($expression, ' $not$ $eq$ ')">
            <xsl:value-of select="not(regexp:test(string($expression_variable), string($expression_values), 'i'))"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="regexp:test(string($expression_variable), string($expression_values), 'i')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- End of Conditional Operators -->

  <!-- Start of Parsing XML (XML string to XML elements/ nodes) -->
  <!--//https://stackoverflow.com/questions/14508513/how-to-parse-the-xml-inside-cdata-of-another-xml-using-xslt/14512924#14512924 -->
  <xsl:template name="parseXml">
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, '&gt;')">
				<xsl:variable name="topLevelTag">
					<xsl:call-template name="getTopLevelTag">
						<xsl:with-param name="text" select="$text"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="openingTag">
					<xsl:value-of select="$topLevelTag"/>
				</xsl:variable>
				<xsl:variable name="tagName">
					<xsl:call-template name="getTopLevelTagName">
						<xsl:with-param name="text" select="$text"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="closingTag">
					<xsl:value-of select="concat('&lt;/',$tagName,'&gt;')"/>
				</xsl:variable>
				<xsl:variable name="firstNode">
					<xsl:if test="not(contains($topLevelTag,'/&gt;'))">
						<xsl:value-of select="substring-before(substring-after($text,$openingTag),$closingTag)"/>        
					</xsl:if>
				</xsl:variable>
				<xsl:variable name="afterFirstNode">
					<xsl:choose>
						<xsl:when test="not(contains($topLevelTag,'/&gt;'))">
							<xsl:value-of select="substring-after($text,concat($firstNode,$closingTag))"/>        
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring-after($text,$topLevelTag)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:element name="{$tagName}">
					<xsl:call-template name="createAttributes">
						<xsl:with-param name="text" select="$topLevelTag"/>
					</xsl:call-template>
					<xsl:call-template name="parseXml">
						<xsl:with-param name="text" select="$firstNode"/>
					</xsl:call-template>
				</xsl:element>
				<xsl:call-template name="parseXml">
					<xsl:with-param name="text" select="$afterFirstNode"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="getTopLevelTagName">
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, '&gt;')">
				<xsl:variable name="tagWithAttributesWithoutEnd">
					<xsl:value-of select="substring-before($text, '&gt;')"/>
				</xsl:variable>
				<xsl:variable name="tagWithAttributesWithoutBegining">
					<xsl:value-of select="substring-after($tagWithAttributesWithoutEnd, '&lt;')"/>
				</xsl:variable>
				<xsl:variable name="tagName">
					<xsl:choose>
						<xsl:when test="contains($tagWithAttributesWithoutBegining,' ')">
							<xsl:value-of select="substring-before($tagWithAttributesWithoutBegining, ' ')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$tagWithAttributesWithoutBegining"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="$tagName"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="getTopLevelTag">
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, '&gt;')">
				<xsl:variable name="tagWithAttributesWithoutEnd">
					<xsl:value-of select="substring-before($text, '&gt;')"/>
				</xsl:variable>
				<xsl:value-of select="concat($tagWithAttributesWithoutEnd,'&gt;')"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="createAttributes">
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, '=&quot;')">
				<xsl:variable name="attributeName">
					<xsl:value-of select="substring-before(substring-after($text,' '),'=&quot;')"/>
				</xsl:variable>
				<xsl:message>
					<xsl:value-of select="$text"/>
				</xsl:message>
				<xsl:variable name="attributeValue">
					<xsl:value-of select="substring-before(substring-after($text,concat($attributeName,'=&quot;')),'&quot;')"/>
				</xsl:variable>
				<xsl:attribute name="{$attributeName}">
					<xsl:value-of select="$attributeValue"/>
				</xsl:attribute>
				<xsl:call-template name="createAttributes">
					<xsl:with-param name="text" select="substring-after($text,concat($attributeName,'=&quot;',$attributeValue,'&quot;'))"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>        
	</xsl:template>
	<!-- End of Parsing XML (XML string to XML elements/ nodes) -->

</xsl:stylesheet>

