<?xml version="1.0"?>
<!--

A stylesheet harness for testing the table processing
  on a sample file 'trouble-tables.xml'
  
  
  Also:  
  configuring serialization of output
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

  
  <xsl:import href="SPLPlus-QA.xsl"/>
  
  <xsl:output method="xhtml" encoding="US-ASCII"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    saxon:character-representation="hex"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="comment()"/>
  
  <xsl:template match="table-set">
    <html>
      <head>
        <title>Table-work (color HTML output)</title>
        <link rel="stylesheet" type="text/css" href="splplus-QA-color.css" />
        <style type="text/css">
          
          
          table	{ 
          table-layout: fixed; 
          font-size: 100%; 
          border-collapse: collapse; 
          border-color: black; 
          border-width: 4px; 
          }
          
          
          
          
          /* only for use in splplus-QA-color.css */
          .auto-generated { 
          background-color: white; 
          border: 2px dotted blue; 
          }
          
          .rowsep-1 { 
          border-bottom-style: solid; 
          border-bottom-width: thin; 
          }
          
          tfoot tr td { 
          text-align: left; 
          }
          
          table .QA-warning { 
          display: none; visibility: collapse; 
          }
          
        </style>
        
        <body>
          <xsl:apply-templates/>
        </body>
      </head>
    </html>
  </xsl:template>
  
  <xsl:template match="file">
    <span class="QA-warning">RE: TABLE EXCERPTS FROM PDR <xsl:text/>
      <xsl:value-of select="@file"/>
    </span>
    <br />
    <br />
    <xsl:apply-templates/>
  </xsl:template>
  
</xsl:transform>