<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output 
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
		doctype-system="DTD/xhtml1-strict.dtd" 
		method="xhtml"/>
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="DOCUMENT">
        <html>
        	<head>
        		<title><xsl:value-of select="AT"/></title>
        		<link href="../berg.css" rel="stylesheet" type="text/css" />
        	</head>
        	<body>
        		<div id="main">
        			<xsl:apply-templates/>
        		</div>
        	</body>
        	
       	</html>
    </xsl:template>
    <xsl:template match="AT">
        <p class="article_title"><xsl:apply-templates/></p>
    </xsl:template>
    <xsl:template match="KWH">
        <span class="keyword_head"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="KWT">
        <span class="keyword"><xsl:apply-templates/></span>
    </xsl:template>
    <xsl:template match="GlH">
        <span class="glossary_head"><xsl:apply-templates/></span>
    </xsl:template>
	<xsl:template match="GlT">
		<span class="glossary_term"><xsl:apply-templates/></span>
	</xsl:template>
	<xsl:template match="Tx">
		<div class="para">
			<p class="para_number"></p>
			<p class="copy"><xsl:apply-templates/></p>
		</div>
	</xsl:template>
	<xsl:template match="term">
		<span class="term"><xsl:apply-templates/></span>
	</xsl:template>
	<xsl:template match="H1">
		<h1><xsl:apply-templates/></h1>
	</xsl:template>
	<xsl:template match="AAu">
		<p class="byline"><xsl:apply-templates/></p>
	</xsl:template>
	<xsl:template match="ABibH">
		<p class="bibliography_head"><xsl:apply-templates/></p>
	</xsl:template>
	<xsl:template match="ABib">
		<p class="bibliography_entry"><xsl:apply-templates/></p>
	</xsl:template>
	<xsl:template match="surname">
		<span class="surname"><xsl:apply-templates/></span>
	</xsl:template>
	<xsl:template match="forename">
		<span class="forename"><xsl:apply-templates/></span>
	</xsl:template>
	<xsl:template match="titleM">
		<span class="titleM"><xsl:apply-templates/></span>
	</xsl:template>
	<xsl:template match="pubPlace">
		<span class="pubPlace"><xsl:apply-templates/></span>
	</xsl:template>
	<xsl:template match="publisher">
		<span class="publisher"><xsl:apply-templates/></span>
	</xsl:template>
	<xsl:template match="date">
		<span class="date"><xsl:apply-templates/></span>
	</xsl:template>
	<xsl:template match="titleC">
		<span class="titleC"><xsl:apply-templates/></span>
	</xsl:template>
	<xsl:template match="pp">
		<span class="pp"><xsl:apply-templates/></span>
	</xsl:template>
	<xsl:template match="titleA">
		<span class="titleA"><xsl:apply-templates/></span>
	</xsl:template>
	<xsl:template match="titleJ">
		<span class="titleJ"><xsl:apply-templates/></span>
	</xsl:template>
	<xsl:template match="vol">
		<span class="vol"><xsl:apply-templates/></span>
	</xsl:template>
	<xsl:template match="NtE">
		<p class="note_to_editor"><xsl:apply-templates/></p>
	</xsl:template>
	<xsl:template match="ASeeA">
		<p class="see_also"><xsl:apply-templates/></p>
	</xsl:template>
	<xsl:template match="ASeeAI">
		<a href="{text()}"><xsl:value-of select="."/></a>
	</xsl:template>
</xsl:stylesheet>
