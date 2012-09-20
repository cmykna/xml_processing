<?xml version='1.0' encoding='ISO-8859-1'?>
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	 ImpArchival XML to Extenza-NLM header transform v2.
	 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	 Last updated: 09/27/06 cmc
	 Version: 2.0
	 XSLT processor target: Saxon 8
	 Whitespace settings: Strip all (-sall)
	 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	 CHANGE LOG:
	 10/04/06
	 1) Article IDs now use the comp-style "journalCode-v#i#a#" 
	 notation. Extenza doesn't particularly appear to care what 
	 kind of ID values it gets, as long as they're unique.
	 
	
	 INFO:
	
	 Originally implemented as a quick-and-dirty solution
	 for processing XML for Springer Publishing journals
	 headed to Extenza, this version attempts to organize
	 and document template rules and minimize processing pre-
	 and post-transformation.
	
	 Pre-processing steps (now taken care of by
	 target XML from comp)
	 [## DELETED STEPS #1 & 4, 10/04/06 ##]
	 2) Populate //pub-info[@fpage and @lpage] with
		page numbers from article pdfs.
	 3) Inspect //contributor-group and //affiliation-group
		for proper coding of affiliations and corresponding
		author values.
		a) @affiliation is likely to come out of Penta with
		   the same value for each author, even when there are
		   multiple affiliations in the PDF. The correct info
		   is usually either stuck in a PI in //contributor or
		   crammed into one //affiliation-group/affiliation.
		b) @cor is always used for each //contributor.
		   Springer articles almost always have only one
		   actual corresponding author, called out in the
		   Offprints blurb at the end of the PDF. @cor should
		   be deleted in all other //contributors.
	 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	 TODO:
	 1) Strip whitespace in //article-title/text()
	 2) Re-convert char entities from decimal to hex.
	 3) Find a simpler way to process affiliation info,
		 possibly with <xsl:for-each-group>. See lines 212-234.
	 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-->
<xsl:stylesheet version="2.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:xlink="http://www.w3.org/1999/xlink">
	<xsl:output method="xml" 
				encoding="US-ASCII" 
				omit-xml-declaration="no" 
				doctype-public="-//NLM//DTD Journal Archiving and Interchange DTD v1.0 20021201//EN" 
				doctype-system="nlm-dtd/archivearticle.dtd" 
				indent="no"/>
	<!-- Initialize issue-specific variables for plugin in result tree -->
	<!-- $article_ID is used to generate base values for all IDs in the article -->
	<xsl:variable name="article_ID" select="/article/@id"/>
	<!-- $Springer_DOI_prefix, $publisher_name, ISSNs: static values -->
	<xsl:variable name="Springer_DOI_prefix">10.1891</xsl:variable>
	<xsl:variable name="publisher_name">Springer Publishing Company</xsl:variable>
	<xsl:variable name="vivi_ISSN">0886-6708</xsl:variable>
	<xsl:variable name="rtnp_ISSN">0889-7182</xsl:variable>
	<xsl:variable name="cmaj_ISSN">1521-0987</xsl:variable>
	<xsl:variable name="hhci_ISSN">1540-4153</xsl:variable>
	<xsl:variable name="ehpp_ISSN">1523-150X</xsl:variable>
	<xsl:variable name="jcop_ISSN">0889-8391</xsl:variable>
	<!-- Slurp journal abbreviation from $article_ID -->
	<xsl:variable name="this_journal" select="tokenize(/article/@id, '-')[1]"/>
	<!-- ISSN for current journal: processed here to keep sequence
		 constructors in main templates to a minimum -->
	<xsl:variable name="this_issn">
		<xsl:choose>
			<xsl:when test="$this_journal = 'vv'">
				<xsl:value-of select="$vivi_ISSN"/>
			</xsl:when>
			<xsl:when test="$this_journal = 'rtnp'">
				<xsl:value-of select="$rtnp_ISSN"/>
			</xsl:when>
			<xsl:when test="$this_journal = 'cmj'">
				<xsl:value-of select="$cmaj_ISSN"/>
			</xsl:when>
			<xsl:when test="$this_journal = 'hhci'">
				<xsl:value-of select="$hhci_ISSN"/>
			</xsl:when>
			<xsl:when test="$this_journal = 'ehppij'">
				<xsl:value-of select="$ehpp_ISSN"/>
			</xsl:when>
			<xsl:when test="$this_journal = 'rtnpij'">
				<xsl:value-of select="$rtnp_ISSN"/>
			</xsl:when>
			<xsl:when test="$this_journal = 'jcpiq'">
				<xsl:value-of select="$jcop_ISSN"/>
			</xsl:when>

			<xsl:otherwise>
				<xsl:message terminate="no">No ISSN found.</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- Expand comp-shorthand journal name for plugin to
		 //journal-id -->
	<xsl:variable name="publisherID">
		<xsl:choose>
			<xsl:when test="$this_journal = 'vv'">
				<xsl:value-of select="vivi"/>
			</xsl:when>
			<xsl:when test="$this_journal = 'rtnp'">
				<xsl:value-of select="rtnp"/>
			</xsl:when>
			<xsl:when test="$this_journal = 'cmj'">
				<xsl:value-of select="cmaj"/>
			</xsl:when>
			<xsl:when test="$this_journal = 'hhci'">
				<xsl:value-of select="hhci"/>
			</xsl:when>
			<xsl:when test="$this_journal = 'ehppij'">
				<xsl:value-of select="ehpp"/>
			</xsl:when>
			<xsl:when test="$this_journal = 'rtnpij'">
				<xsl:value-of select="rtnp"/>
			</xsl:when>
			<xsl:when test="$this_journal = 'jcpiq'">
				<xsl:value-of select="jcop"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message terminate="no">No 4-character value for //journal-id available.</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- $cpYear generated from timestamp when XSLT is run.
		 Small possibility of inaccuracy when dealing with
		 backlogged issues in the early months of the year :P -->
	<xsl:variable name="cpYear">
		<xsl:value-of select="format-date(current-date(), '[Y]')"/>
	</xsl:variable>
	<!-- PULL data from input tree to generate article wrapper. -->
	<xsl:template match="article">
		<article dtd-version="1.0" xml:lang="en" article-type="{./@article-type|./@type}">
			<front>
				<journal-meta>
					<journal-id journal-id-type="publisher-id">
						<xsl:value-of select="$publisherID"/>
					</journal-id>
					<abbrev-journal-title abbrev-type="full">
						<xsl:value-of select="//journal-title"/>
					</abbrev-journal-title>
					<issn pub-type="ppub">
						<xsl:value-of select="$this_issn"/>
					</issn>
					<publisher>
						<publisher-name>
							<xsl:value-of select="$publisher_name"/>
						</publisher-name>
					</publisher>
				</journal-meta>
				<xsl:apply-templates select="//article-meta"/>
			</front>
			
			<xsl:apply-templates select="//end"/>
		</article>
	</xsl:template>
	<!-- PULL data to generate //article-meta and children -->
	<xsl:template match="article-meta">
		<article-meta>
			<article-id pub-id-type="publisher-id">
				<xsl:value-of select="$article_ID"/>
			</article-id>
			<article-id pub-id-type="doi">
				<xsl:value-of select="concat($Springer_DOI_prefix, '/', $article_ID)"/>
			</article-id>
			<title-group>
				<article-title>
					<xsl:value-of select="descendant::article-title-head"/>
				</article-title>
				<xsl:if test="descendant::article-title-head/@rh-title">
					<alt-title>
						<xsl:value-of select="descendant::article-title-head/@rh-title"/>
					</alt-title>
				</xsl:if>
			</title-group>
			<!-- CHANGE CONTEXT to //article-meta and begin //contributor-group processing -->
			<xsl:apply-templates select="contributor-group"/>
			<!-- CHANGE CONTEXT to //author-notes and process them over to result tree. -->
			<xsl:apply-templates select="author-notes"/>
			<xsl:apply-templates select="pub-info"/>
			<copyright-statement>&#x00A9; <xsl:value-of select="$publisher_name"/></copyright-statement>
			<copyright-year><xsl:value-of select="$cpYear"/></copyright-year>
			<related-article related-article-type="pdf" xlink:href="{concat($article_ID, '.pdf')}"></related-article>
			<abstract>
				<title>Abstract</title>
				<xsl:for-each select="abstract/section/subsect1/p">
					<p><xsl:value-of select="."/></p>
				</xsl:for-each>
			</abstract>
			<kwd-group>
				<xsl:for-each select="kwd-group/kwd">
					<xsl:choose>
						<xsl:when test="position() = last()">
							<kwd><xsl:value-of select="."/></kwd>
						</xsl:when>
						<xsl:otherwise>
							<kwd><xsl:value-of select="."/></kwd><x><xsl:text>; </xsl:text></x>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</kwd-group>
			<counts>
				<fig-count count="{count(//figure)}"/>
				<table-count count="{count(//table-wrap)}"/>
				<ref-count count="{count(//ref-item)}"/>
			</counts>
		</article-meta>
	</xsl:template>
	<!-- PULL data and generate //contributor-group -->
	<xsl:template match="contributor-group">
		<contrib-group>
			<xsl:for-each select="contributor">
				<!-- Sequence constructers for new IDs assume penta export
				attributes are \w+-\w+-\w+ (tokenized with '-' char). -->
				<xsl:variable name="affID"
							  select="concat($article_ID,
									  '-',
									  tokenize(@affiliation, '-')[3])"/>
				<xsl:variable name="supValue"
					select="substring-after($affID, 'aff')"/>
				<!-- Begin sending <contrib> elements to the result tree. -->
				<contrib>
					<xsl:if test="@cor">
						<xsl:attribute name="corresp">yes</xsl:attribute>
					</xsl:if>
					<name>
						<given-names>
							<xsl:value-of select="name/given-names"/>
						</given-names>
						<x><xsl:text> </xsl:text></x>
						<surname>
							<xsl:value-of select="name/surname"/>
						</surname>
						<!-- Processing name suffixes like Jr., Sr, etc. -->
						<xsl:if test="name/name-suffix[@type='name']">
							<x><xsl:text>, </xsl:text></x>
							<suffix>
								<xsl:value-of select="name/name-suffix[@type='name']"/>
							</suffix>
						</xsl:if>
					</name>
					<!-- Processing author degrees and certifications. -->
					<xsl:if test="name/name-suffix[@type='degrees']">
						<x><xsl:text>, </xsl:text></x>
							<degrees>
								<xsl:value-of select="name/name-suffix[@type='degrees']"/>
							</degrees>
						<xsl:if test="self::contributor != //contributor[last()]">
							<x><xsl:text>, </xsl:text></x>
						</xsl:if>
					</xsl:if>
					<!-- Sending a link to the author's affiliation info to result tree. -->
					<xref ref-type="aff" rid="{$affID}">
						<sup>
							<xsl:value-of select="$supValue"/>
						</sup>
					</xref>
					<!-- If this is the FIRST author through the grind, we know that we'll 
						definately need the <aff> info here. If this is NOT the first author, compare 
						@affiliation to the preceding contributor's @affiliation. If they're not equal,
						we're dealing with a new affiliation and will need <aff> info. -->
					<xsl:if test="self::contributor = 
									 //contributor[position()][1] or 
									 self::contributor/@affiliation != 
									 preceding-sibling::contributor/@affiliation">
						<aff id="{$affID}">
							<label>
								<sup>
									<xsl:value-of select="$supValue"/>
								</sup>
							</label>
							<!-- Change every <p> in the corresponding affiliation info
								  to an <addr-line>. Yes, this is slight tag abuse. Luckily, 
								  Extenza's concerned with formatting, not content, and this
								  is what makes it look best. -->
							<xsl:for-each select="//affiliation-group/affiliation[@id=$affID]/child::*">
								<addr-line><xsl:value-of select="."/></addr-line>
							</xsl:for-each>
						</aff>
					</xsl:if>
					<!-- Grab corresponding author's email info and throw it in the result tree. -->
					<xsl:if test="@cor">
						<xsl:variable name="corID">
							<xsl:value-of select="@cor"/>
						</xsl:variable>
						<email xlink:href="{//author-notes/fn[@id=$corID]/descendant::email/@mailto}">
							<xsl:value-of select="//author-notes/fn[@id=$corID]/descendant::email"/>
						</email>
					</xsl:if>
				</contrib>
			</xsl:for-each>
		</contrib-group>
	</xsl:template>
	<!-- PULL data and generate author-notes. Current sequence constructor
		 assumes there's only one corresponding author with a "Requests for offprints..."
		 style author-notes entry. -->
	<xsl:template match="author-notes">
		<author-notes>
			<title>Offprints</title>
				<corresp id="{fn/@id}">
					<!-- Whitespace in result tree messed up here. I'll fix it when
						 I've got an hour to spend fucking with <xsl:text/> -->
					<xsl:text>Requests for offprints should be directed to:</xsl:text>
					<!-- Throwing all parts of the address into <addr-lines>. Still ugly and
						 hacky, still what works best for Extenza. We're expecting AT LEAST
						 <name> and <institution> elements to work with here. -->
					<addr-line><xsl:value-of select="fn/corresp/name"/></addr-line>
					<addr-line><xsl:value-of select="fn/corresp/institution"/></addr-line>
					<!-- Throw <address> descendants into a temp tree so we don't have to
						 keep pathing down from <author-notes> -->
					<xsl:variable name="addrLine" select="fn/corresp/address/addr-line"/>
					<xsl:if test="$addrLine/institution">
						<addr-line><xsl:value-of select="$addrLine/institution"/></addr-line>
					</xsl:if>
					<xsl:if test="$addrLine/street-addr">
						<addr-line><xsl:value-of select="$addrLine/street-addr"/></addr-line>
					</xsl:if>
					<!-- Add more branches for just <city> and just <state> (those
						 cases will probably be rare) -->
					<xsl:choose>
						<xsl:when test="$addrLine/city and $addrLine/state">
							<addr-line><xsl:value-of select="$addrLine/city"/><xsl:text>, </xsl:text><xsl:value-of select="$addrLine/state"/></addr-line>
						</xsl:when>
					</xsl:choose>
					<xsl:if test="$addrLine/zip">
						<addr-line><xsl:value-of select="$addrLine/zip"/></addr-line>
					</xsl:if>
					<email xlink:href="{fn/corresp/email/@mailto}"><xsl:value-of select="fn/corresp/email"/></email>
				</corresp>
		</author-notes>
	</xsl:template>
	<xsl:template match="pub-info">
		<pub-date pub-type="ppub">
			<month><xsl:value-of select="@month"/></month>
			<year><xsl:value-of select="@year"/></year>
		</pub-date>
		<volume><xsl:value-of select="@volume"/></volume>
		<issue><xsl:value-of select="@issue"/></issue>
		<fpage><xsl:value-of select="@fpage"/></fpage>
		<lpage><xsl:value-of select="@lpage"/></lpage>
	</xsl:template>
	<xsl:template match="end">
		<back>
			<xsl:apply-templates mode="copythru"/>
		</back>
	</xsl:template>
	<xsl:template match="@*|node()" mode="copythru">
		<xsl:copy>
			<xsl:apply-templates mode="copythru"/>
		</xsl:copy>
	</xsl:template>
	<!-- There's probably a more elegant way to select these text nodes that need to be
		 sent through with <x> tags around them, but I don't feel like messing with it now :P -->
	<xsl:template match="person-group/text()|
				//ref-item/citation/text()| 
				citation/person-group/name/text()" mode="copythru">
		<x><xsl:value-of select="."/></x>
	</xsl:template>
	<xsl:template match="//ref-item" mode="copythru">
		<xsl:element name="ref">
			<xsl:attribute name="id">
				<xsl:value-of select="@id"/>
			</xsl:attribute>
			<xsl:apply-templates mode="copythru"/>
		</xsl:element>
	
	</xsl:template>
	<xsl:template match="//i" mode="copythru">
		<italic><xsl:apply-templates mode="copythru"/></italic>
	</xsl:template>
	<xsl:template match="//ref[@type='editorial-query']" mode="copythru"/>
	<xsl:template match="//ref-list/head" mode="copythru"><title>References</title></xsl:template>
	<xsl:template match="//url" mode="copythru"><ext-link ext-link-type="uri" xlink:href="{text()}"><xsl:value-of select="."/></ext-link></xsl:template>
	<xsl:template match="//chapter-title" mode="copythru"><article-title><xsl:value-of select="."></xsl:value-of></article-title></xsl:template>
</xsl:stylesheet>
