<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <!-- 
        Created: 2/27/07 by cmc
        Cleanup xsl for PDR SPL-schema XML.
        This transform assumes input is invalid SPL created from
    	DGr and SA's old SPL+ > SPL > Schema hack.
    -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
	<!-- 
		Most //table-here elements got commented out by
		the conversion; let's take care of the ones
		that were missed.
		TODO: Why are certain table-here's not being commented?
		TODO: There's GOT to be a way to copy an empty element to the result tree inside a comment.
	-->
	<xsl:template match="table-here">
		<!-- Doing it this way is totally ghetto and will require another
			 post-processing step. Using xsl:comment is the way to go, but
			 I can't figure out a way to turn the entire context node into a 
			 string and pass it into xsl:comment. Blast! -->
		<xsl:text>&lt;!- -</xsl:text><xsl:copy-of select="."/><xsl:text>- -&gt;</xsl:text>
	</xsl:template>
	<xsl:template match="//linkHtml[ancestor::title]">
		<!-- Schema doesn't allow //title[descendant::linkHtml]. The tagging needs to 
			 be commented, but the text node needs to be preserved. Additional comment
			 delimiters will be added in the second pass to make this happen.
			 Reconstructing the element right in the stylesheet to do it in one pass is possible, but
			 there's no good way to make sure the attributes are correct.	
			 - - Actually, fuck it. Gonna do it anyway.
		-->
		&lt;- -<linkHtml href="{@href}" name="{@name}">- -&gt;<xsl:apply-templates/>&lt;- -</linkHtml>- -&gt;
	</xsl:template>
	<xsl:template match="//content[ancestor::linkHtml]">
		<!-- Schema doesn't allow //linkHtml/content. As with //title[descendant::linkHtml], element
			 tags must be commented and text nodes preserved. -->
		
			&lt;- -<content styleCode="{@styleCode}">- -&gt;<xsl:value-of select="."/>&lt;- -</content>- -&gt;
		 
		<!--<xsl:text>&lt;!- -</xsl:text><xsl:copy><xsl:apply-templates/></xsl:copy><xsl:text>- -&gt;</xsl:text>-->
	</xsl:template>
	
	<xsl:template match="//list">
		<!-- The only attributes in SPL lists are: @styleCode, @listType, @language, and @ID.
			 I'm deleting the SPL+ leftovers by rebuilding the element tag and ommiting non-schema @'s.
		-->
		<xsl:element name="list">
			<xsl:if test="@styleCode">
				<xsl:attribute name="styleCode" select="@styleCode"/>	
			</xsl:if>
			<xsl:if test="@listType">
				<xsl:attribute name="listType" select="@listType"/>
			</xsl:if>
			<xsl:if test="@ID">
				<xsl:attribute name="ID" select="@ID"/>
			</xsl:if>
			<xsl:if test="@language">
				<xsl:attribute name="language" select="@language"/>
			</xsl:if>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="id[@compId]">
		<id root="{@root}"/><xsl:text>&lt;!- -</xsl:text><id compId="{@compId}" root="{@root}"/><xsl:text>- -&gt;</xsl:text>
	</xsl:template>
</xsl:stylesheet>
