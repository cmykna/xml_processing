<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="xhtml"/>
	<xsl:template match="publication">
		<html>
			<head>
				<link rel="stylesheet" type="text/css" href="file://J:\dev\css\standard.css"/>
				<title>
					<xsl:value-of select="concat(
					substring-before(//publication/@id, '-1'), ' statistics'
					)"/>
				</title>
			</head>
			<body>
				<div class="section">
					<h1>Figures</h1>
					<h2>Totals</h2>
					<xsl:call-template name="figureCounts"/>
					<h2>Chapter Breakdown</h2>
					<xsl:for-each select="descendant::div[@type='chapter']">
						<xsl:call-template name="figureCounts"/>
					</xsl:for-each>
					<br/>
				</div>
				<div class="section">
					<h1>Tables</h1>
					<h2>Totals</h2>
					<xsl:call-template name="tableCounts"/>
					<h2>Chapter Breakdown</h2>
					<xsl:for-each select="descendant::div[@type='chapter']">
						<xsl:call-template name="tableCounts"/>
					</xsl:for-each>
				</div>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="figureCounts">
		<xsl:variable name="figXrefs" select="count(descendant::xref[@type='figure'])"/>
		<xsl:variable name="figXrefInserts" select="count(
			descendant::xref[@type='figure' and @insert='float'])"/>
		<xsl:variable name="figElements" select="count(
			descendant::inserts/figure-group) + count(descendant::inserts/figure)"/>
		<xsl:if test="$figElements and $figXrefs and $figXrefInserts != 0">
			<h3>
				<xsl:value-of select="label"/>
			</h3>
			<p>Figure references in text: <b>
					<xsl:value-of select="$figXrefs"/>
				</b></p>
			<p>Figure insert instructions in text (@insert="float"): <b>
					<xsl:value-of select="$figXrefInserts"/>
				</b></p>
			<xsl:choose>
				<xsl:when test="$figElements &gt; $figXrefInserts">
					<p>Figure elements in &lt;inserts&gt; sections:<b>
							<xsl:value-of select="$figElements"/>
							<span style="color: red;">
										[-<xsl:value-of select="$figElements - $figXrefInserts"/> insert(s)]
									</span>
					</b></p>
										<h4>Figure/figure-group @ids</h4>
					<h5>Figure-groups (<xsl:value-of select="count(descendant::inserts/figure-group)"/>)</h5>
					<xsl:for-each select="descendant::inserts/figure-group">
							<b><span style="color: red;">[<xsl:value-of select="@id"/>]</span></b>&#x0020;
							</xsl:for-each>
					<h5>Single figures (<xsl:value-of select="count(descendant::inserts/figure)"/>)</h5>
					<xsl:for-each select="descendant::inserts/figure">
							<b><span style="color: red;">[<xsl:value-of select="@id"/>]</span></b>&#x0020;
							</xsl:for-each>
				</xsl:when>
				<xsl:when test="$figElements &lt; $figXrefInserts">
					<p>Figure elements in &lt;inserts&gt; sections:
						<b>
							<xsl:value-of select="$figElements"/>
							<span style="color: red;">
							[+<xsl:value-of select="$figXrefInserts - $figElements"/> insert(s)]</span>
						</b></p>
					<h4>Figure/figure-group @ids</h4>
					<h5>Figure-groups (<xsl:value-of select="count(descendant::inserts/figure-group)"/>)</h5>
					<xsl:for-each select="descendant::inserts/figure-group">
							<b><span style="color: red;">[<xsl:value-of select="@id"/>]</span></b>&#x0020;
							</xsl:for-each>
					<h5>Single figures (<xsl:value-of select="count(descendant::inserts/figure)"/>)</h5>
					<xsl:for-each select="descendant::inserts/figure">
							<b><span style="color: red;">[<xsl:value-of select="@id"/>]</span></b>&#x0020;
							</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<p>Figure elements in &lt;inserts&gt; sections:<b>
						<span style="color: green">
							<xsl:value-of select="$figElements"/>
						</span>
					</b></p>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template name="tableCounts">
		<xsl:variable name="tabXrefs" select="count(descendant::xref[@type='table'])"/>
		<xsl:variable name="tabElements" select="count(descendant::inserts/table-wrap)"/>
				<xsl:if test="$tabElements and $tabXrefs != 0">
			<h3>
				<xsl:value-of select="label"/>
			</h3>
		<p>Table references in text: <b>
				<xsl:value-of select="$tabXrefs"/>
			</b></p>
		<p>Table-wrap elements in &lt;inserts&gt; sections: <b>
				<xsl:choose>
					<xsl:when test="$tabElements &gt; $tabXrefs">
						<xsl:value-of select="$tabElements"/>
						<span style="color: red;">
										[-<xsl:value-of select="$tabElements - $tabXrefs"/> insert(s)]
									</span>
					</xsl:when>
					<xsl:when test="$tabElements &lt; $tabXrefs">
						<xsl:value-of select="$tabElements"/>
						<span style="color: red;">
										 [+<xsl:value-of select="$tabXrefs - $tabElements"/> insert(s)]
									</span>
					</xsl:when>
					<xsl:otherwise>
						<span style="color: green">
							<xsl:value-of select="$tabElements"/>
						</span>
					</xsl:otherwise>
				</xsl:choose>
		</b></p>
					</xsl:if>
	</xsl:template>
</xsl:stylesheet>
