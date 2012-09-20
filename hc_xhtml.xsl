<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
		<xsl:output method="xml" encoding="US-ASCII" omit-xml-declaration="no" 
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" indent="no"/>
	<!-- copy-through template -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="html">
		<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII"/>
				<link rel="stylesheet" href="hcWebStyle.css" type="text/css"/>
				<title/>
			</head>
			<xsl:apply-templates/>
		</html>
	</xsl:template>
	<xsl:template match="body">
		<body>
			<div class="main">
				<xsl:apply-templates/>
			</div>
		</body>
	</xsl:template>
	<xsl:template match="div[@class='Sect']">
		<xsl:choose>
			<xsl:when test="count(child::*)=1 and img">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				<div class="section">
					<xsl:apply-templates/>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="span[contains(string(@style), 'font-weight:bold')]" priority="6">
		<i><xsl:apply-templates/></i>
	</xsl:template>
	<xsl:template match="span[contains(string(@style), 'font-style:italic')]" priority="5">
		<i><xsl:apply-templates/></i>
	</xsl:template>
	<xsl:template match="span[contains(string(@style), 'font-variant:small-caps')]" priority="4">
		<span style="font-variant:small-caps;"><xsl:apply-templates/></span>
	</xsl:template>
	<xsl:template match="span[@style]" priority="3">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="//*[@style]" priority="1">
		<xsl:element name="{name()}">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
<!--	<xsl:template match="@style"/>-->
	<xsl:template match="img" priority="2"/>
	<xsl:template match="head"/>
	<xsl:template match="style"/>
</xsl:stylesheet>