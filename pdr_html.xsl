<?xml version="1.0" encoding="UTF-8"?>
	<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
		<xsl:output method="xhtml" encoding="US-ASCII"/>
		<!-- copy-through template -->
		<xsl:template match="@*|node()">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()"/>
			</xsl:copy>
		</xsl:template>
		<!-- Zap! -->
		<xsl:template match="head"/>
		<xsl:template match="div[@class='document-header']"/>
		<xsl:template match="div[@class='section comp-metadata']"/>
		<!-- Zap <HR> at the top of the document. -->
		<xsl:template match="body/hr[1]"/>
		<!-- Boilerplate header -->
		<xsl:template match="div[@class='section title-section']">
<!--			<a name="PDRHEAD">
				<xsl:apply-templates/>
			</a>-->
			<header>
			<p><a name="PDRHEAD"></a></p>
				<p><b><font size="+2"><xsl:apply-templates/></font></b></p>
			<!--<xsl:for-each select="h1/span">
				<xsl:choose>
					<!- - Ugly XPATH syntax here :P - ->
					<xsl:when test="@class != 'fill'
						and @class != 'right'
						and @class != 'entityref'
						and @class != 'phonetic'">
						<p><b><font size="+2"><xsl:value-of select="."/></font></b></p>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>-->
			</header>
		</xsl:template>
		
		<!-- Just want to take this class attr. outta here. -->
		<xsl:template match="p[@class='First']">
			<p><xsl:apply-templates/></p>
		</xsl:template>
		<!-- Let's look at all these section heads and add corresponding wrapper tags. -->
		<xsl:template match="div[@class='section']">
			<xsl:choose>
				<xsl:when test="h1/text()='DESCRIPTION'">
					<description>
						<a name="PDRDES01"></a>
						<xsl:apply-templates/>
					</description>
				</xsl:when>
				<xsl:when test="h1/text()='CLINICAL PHARMACOLOGY'">
					<actions>
						<a name="PDRACT01"></a>
						<xsl:apply-templates/>
					</actions>
				</xsl:when>
				<xsl:when test="h1/text()='INDICATIONS AND USAGE'">
					<indications>
						<a name="PDRIND01"></a>
						<xsl:apply-templates/>
					</indications>
				</xsl:when>
				<xsl:when test="h1/text()='CONTRAINDICATIONS'">
					<contraindications>
						<a name="PDRCON01"></a>
						<xsl:apply-templates/>
					</contraindications>
				</xsl:when>
				<xsl:when test="h1/text()='WARNINGS'">
					<warnings>
						<a name="PDRWAR01"></a>
						<xsl:apply-templates/>
					</warnings>
				</xsl:when>
				<xsl:when test="h1/text()='PRECAUTIONS'">
					<precautions>
						<a name="PDRPRE01"></a>
						<xsl:apply-templates/>
					</precautions>
				</xsl:when>
				<xsl:when test="h1/text()='ADVERSE REACTIONS'">
					<adverse_reactions>
						<a name="PDRADV01"></a>
						<xsl:apply-templates/>
					</adverse_reactions>
				</xsl:when>
				<xsl:when test="h1/text()='OVERDOSAGE'">
					<overdose>
						<a name="PDROVE01"></a>
						<xsl:apply-templates/>
					</overdose>
				</xsl:when>
				<xsl:when test="h1/text()='DOSAGE AND ADMINISTRATION'">
					<dosage>
						<a name="PDRDOS01"></a>
						<xsl:apply-templates/>
					</dosage>
				</xsl:when>
				<xsl:when test="h1/text()='HOW SUPPLIED'">
					<how_supplied>
						<a name="PDRHOW01"></a>
						<xsl:apply-templates/>
					</how_supplied>
				</xsl:when>
				<xsl:when test="h1/text()='CLINICAL STUDIES'">
					<clinical_studies>
						<a name="PDRCLI01"></a>
						<xsl:apply-templates/>
					</clinical_studies>
				</xsl:when>
				<xsl:when test="h1/text()='ANIMAL PHARMACOLOGY AND TOXICOLOGY'">
					<animal_pharmacology>
						<a name="PDRANI01"></a>
						<xsl:apply-templates/>
					</animal_pharmacology>
				</xsl:when>
				<xsl:when test="h1/text()='REFERENCES'">
					<references>
						<a name="PDRREF01"></a>
						<xsl:apply-templates/>
					</references>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:template>
		<xsl:template match="span[@class='Figure']">
			<p><a name="{concat('PDRFIG-', substring-after(img/@alt, 'MM'))}"></a></p>
			<center>
			<table border="1">
			<tr><td><xsl:apply-templates/></td></tr>
			</table>
			</center>
		</xsl:template>
		<xsl:template match="div[@class='BOXED section']">
			<center>
				<table border="1">
					<tr>
						<td><xsl:apply-templates/></td>
					</tr>
				</table>
			</center>
		</xsl:template>
		<xsl:template match="table">
			<table border="1px" align="center" width="100%">
				<xsl:apply-templates/>
			</table>
		</xsl:template>
		<!-- Formatting elements -->
		<xsl:template match="span[@class='Sub']">
			<sub><xsl:apply-templates/></sub>
		</xsl:template>
		<xsl:template match="span[@class='Sup']">
			<sup><xsl:apply-templates/></sup>
		</xsl:template>
		<xsl:template match="span[@class='italics']">
			<i><xsl:apply-templates/></i>
		</xsl:template>
		<xsl:template match="span[@class='bold']">
			<b><xsl:apply-templates/></b>
		</xsl:template>
		<xsl:template match="span[@class='bold-italics']">
			<b><i><xsl:apply-templates/></i></b>
		</xsl:template>
		<xsl:template match="span[@class='bold-underline']">
			<b><u><xsl:apply-templates/></u></b>
		</xsl:template>
		<xsl:template match="span[@class='sans-serif']">
			<font face="Arial"><xsl:apply-templates/></font>
		</xsl:template>
		<xsl:template match="span[@class='run-in h2']">
			<font size="+1" face="Arial"><b><xsl:apply-templates/></b></font>
		</xsl:template>
		<xsl:template match="span[@class='run-in h3']">
			<font size="+1" face="Arial"><b><xsl:apply-templates/></b></font>
		</xsl:template>
		<xsl:template match="span[@class='center']">
			<center><xsl:apply-templates/></center>
		</xsl:template>
		<!-- Zap! -->
		<xsl:template match="p[@class='ProdGuide_crossref center italics']"/>
		<xsl:template match="p[@class='ProdGuide_crossref First center italics']"/>
		<xsl:template match="p[@class='comp-generated First']"/>
		<xsl:template match="p[@class='comp-generated']"/>
		<xsl:template match="span[@class='space-leader-fill']"/>
		<xsl:template match="span[@class='fill']"/>
		<xsl:template match="span[@class='right']">
			<font align="right"><xsl:apply-templates/></font>
		</xsl:template>
	</xsl:stylesheet>
