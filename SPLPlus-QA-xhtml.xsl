<?xml version="1.0"?>
<!--

A stylesheet for configuring serialization of output
  for Apex SPLPlus QA transformation
  according to Apex specifications:
  
  XHTML
  character references in decimal form
  
-->
<xsl:transform version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:saxon="http://saxon.sf.net/"
  extension-element-prefixes="saxon"
  exclude-result-prefixes="#all">
  
  <xsl:output method="xhtml" encoding="US-ASCII"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    saxon:character-representation="hex"/>

  <xsl:include href="SPLPlus-QA.xsl"/>
  
</xsl:transform>