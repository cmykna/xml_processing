<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="xml" encoding="US-ASCII" omit-xml-declaration="no" indent="yes"/>
	
	<xsl:preserve-space elements="*"/>
	
	<xsl:template match="/">
		<xsl:element name="submission">
			<xsl:apply-templates mode="issue_data"/>
			<xsl:apply-templates mode="article_data"/>
		</xsl:element>
	</xsl:template>
	
	<!-- This template builds issue metedata from 
		  information taken out of the first article
	     document in the journal. -->
	<xsl:template match="manifest" mode="issue_data">
			<xsl:attribute name="version" select="string('2.0')" />
			<xsl:element name="issue_meta">
				<xsl:variable name="issue_metadata" select="document(input[1])"/>
				<xsl:element name="jcode">
					<xsl:value-of select="$issue_metadata/descendant::journal-id"/>
				</xsl:element>
				<xsl:comment>The following element value will have to be changed by hand on a per-issue basis.</xsl:comment>
				<xsl:element name="coverdate">YYYY/MM/DD</xsl:element>
				<xsl:element name="stringdate">
					<xsl:value-of select="$issue_metadata/descendant::string-date"/>
				</xsl:element>
				<xsl:element name="volume">
					<xsl:value-of select="$issue_metadata/descendant::article-meta/volume"/>
				</xsl:element>
				<xsl:element name="issue">
					<xsl:value-of select="$issue_metadata/descendant::article-meta/issue"/>
				</xsl:element>
			</xsl:element>
	</xsl:template>
	
	<!-- Now we start the irritating process of grabbing
		  relavent data from each article file and formatting
		  it into a nice, Extenza-readable manifest. -->
	<xsl:template match="manifest" mode="article_data">
		<xsl:for-each select="document(input)">
			<xsl:element name="article">
				<xsl:attribute name="doi">
					<xsl:value-of select="//article-id[@pub-id-type='doi']"/>
				</xsl:attribute>
				<xsl:element name="title">
					<xsl:value-of select="//front/article-meta/title-group/article-title"/>
				</xsl:element>
				<xsl:element name="authors">
					<!--<xsl:value-of select="//front//contrib/name"/>-->
					<xsl:for-each select="//contrib">
						<xsl:value-of select="name"/>
						<!--<xsl:value-of select="name/given-names"/><xsl:text> </xsl:text><xsl:value-of select="name/surname"/><xsl:text>, </xsl:text><xsl:value-of select="degrees"/><xsl:text>, </xsl:text>-->
					</xsl:for-each>
				</xsl:element>
				<xsl:element name="fpage">
					<xsl:value-of select="//front//fpage"/>
				</xsl:element>
				<xsl:element name="lpage">
					<xsl:value-of select="//front//lpage"/>
				</xsl:element>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>

	
	
</xsl:stylesheet>
