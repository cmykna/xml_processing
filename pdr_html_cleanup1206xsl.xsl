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
	<xsl:template match="UL[@CLASS='Arabic numbered normal']">
		<OL>
			<xsl:apply-templates/>
		</OL>
	</xsl:template>
</xsl:stylesheet>