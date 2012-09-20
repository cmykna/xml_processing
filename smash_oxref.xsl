<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
		<xsl:output method="xml" encoding="US-ASCII" omit-xml-declaration="no" 
			doctype-public="-//OXFORD//DTD OUP//EN"
			doctype-system="OxRefML.dtd" indent="no"/>
	<!-- copy-through template -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="OPR">
		<OPR id="grrb-dart-b1" ttype="opr" category="longRef">
			<wmeta>
				<tle>The Grove Encyclopedia of <hi>Decorative Arts</hi></tle>
				<alphasort>Grove Encyclopedia of Decorative Arts, The</alphasort>
				<cite></cite>
				<isbn>0195189483</isbn>
				<pdate><year>2006</year></pdate>
				<cpy>&amp;copy; 2006 by Oxford University Press, Inc.</cpy>
			</wmeta>
			<letter value="A">
				<xsl:for-each select="letter[@value='A']">
					<xsl:apply-templates/>
				</xsl:for-each>
			</letter>
			<letter value="B">
				<xsl:for-each select="letter[@value='B']">
					<xsl:apply-templates/>
				</xsl:for-each>
			</letter>
			<letter value="C">
				<xsl:for-each select="letter[@value='C']">
					<xsl:apply-templates/>
				</xsl:for-each>
			</letter>
			<letter value="D">
				<xsl:for-each select="letter[@value='D']">
					<xsl:apply-templates/>
				</xsl:for-each>
			</letter>
			<letter value="E">
				<xsl:for-each select="letter[@value='E']">
					<xsl:apply-templates/>
				</xsl:for-each>
			</letter>
			<letter value="F">
				<xsl:for-each select="letter[@value='F']">
					<xsl:apply-templates/>
				</xsl:for-each>
			</letter>
			<letter value="G">
				<xsl:for-each select="letter[@value='G']">
					<xsl:apply-templates/>
				</xsl:for-each>
			</letter>
			<letter value="H">
				<xsl:for-each select="letter[@value='H']">
					<xsl:apply-templates/>
				</xsl:for-each>
			</letter>
			<letter value="I">
				<xsl:for-each select="letter[@value='I']">
					<xsl:apply-templates/>
				</xsl:for-each>
			</letter>
			<letter value="J">
				<xsl:for-each select="letter[@value='J']">
					<xsl:apply-templates/>
				</xsl:for-each>
			</letter>
			<letter value="K">
				<xsl:for-each select="letter[@value='K']">
					<xsl:apply-templates/>
				</xsl:for-each>
			</letter>
			<letter value="L">
				<xsl:for-each select="letter[@value='L']">
					<xsl:apply-templates/>
				</xsl:for-each>
			</letter>
			<letter value="M">
				<xsl:for-each select="letter[@value='M']">
					<xsl:apply-templates/>
				</xsl:for-each>
			</letter>
			<letter value="N">
				<xsl:for-each select="letter[@value='N']">
					<xsl:apply-templates/>
				</xsl:for-each>
			</letter>
			<letter value="O">
				<xsl:for-each select="letter[@value='O']">
					<xsl:apply-templates/>
				</xsl:for-each>
			</letter>
			<letter value="P">
				<xsl:for-each select="letter[@value='P']">
					<xsl:apply-templates/>
				</xsl:for-each>
			</letter>
			<letter value="Q">
				<xsl:for-each select="letter[@value='Q']">
					<xsl:apply-templates/>
				</xsl:for-each>
			</letter>
			<letter value="R">
				<xsl:for-each select="letter[@value='R']">
					<xsl:apply-templates/>
				</xsl:for-each>
			</letter>
			<letter value="S">
				<xsl:for-each select="letter[@value='S']">
					<xsl:apply-templates/>
				</xsl:for-each>
			</letter>
			<letter value="T">
				<xsl:for-each select="letter[@value='T']">
					<xsl:apply-templates/>
				</xsl:for-each>
			</letter>
			<letter value="U">
				<xsl:for-each select="letter[@value='U']">
					<xsl:apply-templates/>
				</xsl:for-each>
			</letter>
			<letter value="V">
				<xsl:for-each select="letter[@value='V']">
					<xsl:apply-templates/>
				</xsl:for-each>
			</letter>
			<letter value="W">
				<xsl:for-each select="letter[@value='W']">
					<xsl:apply-templates/>
				</xsl:for-each>
			</letter>
			<letter value="X">
				<xsl:for-each select="letter[@value='X']">
					<xsl:apply-templates/>
				</xsl:for-each>
			</letter>
			<letter value="Y">
				<xsl:for-each select="letter[@value='Y']">
					<xsl:apply-templates/>
				</xsl:for-each>
			</letter>
			<letter value="Z">
				<xsl:for-each select="letter[@value='Z']">
					<xsl:apply-templates/>
				</xsl:for-each>
			</letter>
		</OPR>
	</xsl:template>	
</xsl:stylesheet>