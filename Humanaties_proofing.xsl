<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output encoding="UTF-8" method="xhtml" 
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"/>
	<!--<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	-->
	<xsl:template match="*">
	<!-- Elements with no template matches are highlighted in red. -->
		<div class="unmatched">
			&lt;<xsl:value-of select="name()"/>&gt;
			<xsl:apply-templates/>
			&lt;/<xsl:value-of select="name()"/>&gt;
			</div>
<!--		<div class="{name()}">
			<xsl:text>No matching rule for this element.</xsl:text>
			<span class="elename"><xsl:value-of select="name()"/></span><xsl:apply-templates/>
		</div>-->
	</xsl:template>
	<xsl:template match="DOCUMENT">
		<html>
			<head>
				<title>Proof</title>
				<link href="humanaties.css" rel="stylesheet" type="text/css"/>
			</head>
			<body>
				<div id="main">
					<xsl:apply-templates/>
				</div>
			</body>
		</html>
	</xsl:template>
	<!-- Part Styles -->
	<xsl:template match="PN|PT|PST|PEp|PEpA|PITx|PITx-f|PITx-m|PITx-l">
		<div class="{name()}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!-- Chapter Styles -->
	<xsl:template match="CN">
		<div class="CN">
			<div class="elename"><xsl:value-of select="name()"/></div>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="CT">
		<div class="CT">
			<div class="elename"><xsl:value-of select="name()"/></div>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="CAu">
		<div class="CAu">
			<div class="elename"><xsl:value-of select="name()"/></div>
			<i><xsl:apply-templates/></i>
		</div>
	</xsl:template>
	<!-- inline styles -->
	<xsl:template match="AC">
		<span style="text-transform:uppercase;"><xsl:apply-templates/></span>
	</xsl:template>
	<xsl:template match="SC">
		<span style="font-variant:small-caps;"><xsl:apply-templates/></span>
	</xsl:template>
	<xsl:template match="I">
		<i><xsl:apply-templates/></i>
	</xsl:template>
	<!-- Refs and callouts -->
	<xsl:template match="BNRef">
		<span style="background:yellow;"><sup><xsl:value-of select="."/></sup></span>
	</xsl:template>
	<xsl:template match="FgCO">
		<span style="background:#ff14c0;"><xsl:value-of select="."/></span>
	</xsl:template>
	<!-- Extracts -->
	<xsl:template match="Ex">
		<blockquote><p><xsl:apply-templates/></p></blockquote>
	</xsl:template>
	<!-- Text -->
	<xsl:template match="TxC">
		<div class="TxC">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="Tx">
		<div class="Tx">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<!-- Heads -->
	<xsl:template match="H1">
		<div class="H1"><div class="elename"><xsl:value-of select="name()"/></div>
		<h1><xsl:apply-templates/></h1></div>
	</xsl:template>
</xsl:stylesheet>
