<?xml version="1.0"?>
<xsl:transform version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="#all">

  <xsl:import href="identity-fallback.xsl"/>
  <!-- If no other templates match an element, we fall
  back to an identity (element-copying) transform
  NOTE: THIS MEANS WE CANNOT DEPEND ON THE USUAL DEFAULT
  PROCESSING BUT MUST EXPLICITLY MATCH EVERYTHING IN THIS
  STYLESHEET -->

  <xsl:import href="db-tables/db-xhtml-table.xsl"/>
  <!-- Import modified Docbook table modules -->

  <!-- string-value flags for display setting:
         'clean' means emulating the PDF
         'color' means with color, frame, ToC enhancement -->
  <xsl:param name="proof" select="'clean'"/>

  <xsl:param name="splplus-cals" select="true()"/>
  <!-- triggers custom overrides of Docbook table-handling logic -->

  <xsl:param name="default.table.frame" select="'none'"/>

  <xsl:param name="default.table.width" select="''"/>

  <xsl:param name="table.borders.with.css" select="0"/>

  <xsl:variable name="colorproof" select="$proof='color'"/>
  <!-- this is a boolean value set to true if $proof is set to color -->

  <!-- This is the CSS link for the output -->
  <xsl:variable name="css">
    <xsl:choose>
      <xsl:when test="$colorproof">splplus-QA-color.css</xsl:when>
      <xsl:otherwise>splplus-QA-clean.css</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- xxx do we need these?
  <xsl:param name="update-check-url-base" select="''"/>
  <xsl:param name="standardSections" select="/.."/> -->



  <xsl:strip-space elements="*"/>
  <!-- strip whitespace-only text nodes by default -->

  <!-- preserve whitespace-only text nodes in any element
       allowed to have #PCDATA content -->
  <xsl:preserve-space
    elements="title name addr text content value
      originalText delimiter prefix suffix
      country state county city postalCode streetAddressLine
      houseNumber houseNumberNumeric direction
      streetName streetNameBase streetNameType additionalLocator
      unitID unitType carrier censusTract family given digits
      linkHtml sub sup footnote footnoteRef paragraph item
      caption number source tabhead tab entry"/>

  <!-- declare a key to access elements by their @ID value -->
  <xsl:key name="element-by-ID" match="*" use="@ID|@id"/>

  <xsl:template match="@styleCode">
    <!-- globally, any @styleCode attribute selected for processing
         should assign a class to the result element -->
    <xsl:call-template name="assign-class">
      <xsl:with-param name="style-attrs" select="."/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="assign-class">
    <xsl:param name="style-attrs" select="/.."/>
    <xsl:param name="string" select="''"/>
    <xsl:variable name="class-value">
      <xsl:for-each select="$style-attrs">
        <xsl:value-of select="."/>
        <xsl:text> </xsl:text>
      </xsl:for-each>
      <xsl:value-of select="$string"/>
      <xsl:apply-templates select="." mode="special-class"/>
    </xsl:variable>
    <xsl:if test="normalize-space($class-value)">
    <xsl:attribute name="class">
      <xsl:value-of select="normalize-space($class-value)"/>
    </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!-- SPECIAL CLASS MODE is to assign special classes to elements
       based on type or other criteria, exclusive of assignments
       made in other ways (passed through etc.) -->
  <xsl:template match="*" mode="special-class"/>

  <xsl:template match="section[code[@code='TS' and @codeSystem='comp']]" mode="special-class">
    <xsl:text> title-section</xsl:text>
  </xsl:template>

  <xsl:template match="section[code[@code='CMS' and @codeSystem='comp']]" mode="special-class">
    <xsl:text> comp-metadata</xsl:text>
  </xsl:template>

  <!-- DOCUMENT ELEMENT TEMPLATE -->
  <xsl:template match="/document">
    <html>
      <head>
        <title><xsl:value-of select="document/title"/></title>
        <link rel="stylesheet" type="text/css" href="{$css}"/>
      </head>
      <body>
        <div class="document-header">
          <h1>Physicians' Desk Reference</h1>
          <h2>2007 Edition PROOF</h2>
          <xsl:apply-templates select="node()[not(self::component)]"/>
          <p style="text-align:center; font-size:80%">
            <xsl:text>Generated on </xsl:text>
            <!--<xsl:value-of select="exsl:date()"/>-->
            <xsl:value-of select="format-date(current-date(),'[MNn] [D], [Y]')"/>
            <xsl:text> at </xsl:text>
            <!--<xsl:value-of select="exsl:time()"/>-->
            <xsl:value-of select="format-time(current-time(),'[h]:[m01] [Pn]')"/>
          </p>
          <p style="text-align:center; font-size:80%">Final placement of tables will be determined on composed pages</p>
        </div>
        <hr/>
        <xsl:call-template name="contents-table"/>
        <xsl:apply-templates select="component"/>
      </body>
    </html>
  </xsl:template>


  <xsl:template match="document/*">
    <xsl:call-template name="attr-label-block"/>
  </xsl:template>

  <xsl:template match="component" priority="5">
    <xsl:apply-templates/>
    <xsl:apply-templates mode="include"
      select="*[not(self::section)]//table-here[not(ancestor::paragraph|ancestor::list)]"/>
    <!-- including any tables called out outside any section children and not
         otherwise called out with a paragraph or list) -->
  </xsl:template>

  <xsl:template match="document/title" priority="3">
    <p class="DocumentTitle">
      <xsl:apply-templates select="@*" mode="report"/>
      <xsl:apply-templates/>
    </p>
    <xsl:call-template name="flushtitlefootnotes"/>
  </xsl:template>

  <xsl:template match="structuredBody">
    <xsl:apply-templates/>
  </xsl:template>


  <!-- FOOTNOTES -->

  <xsl:template match="footnote"/>

  <xsl:template match="footnoteRef">
    <xsl:variable name="ref" select="@IDREF"/>
    <xsl:variable name="target" select="key('element-by-ID',$ref)"/>
    <xsl:variable name="globalnumber" select="count($target/preceding::footnote)+1"/>
    <a href="#footnote-{$globalnumber}" name="footnote-reference-{$globalnumber}"
      class="Sup">
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <!-- The flushtitlefootnotes template is called
       at the end of every document title and section title -->
  <xsl:template match="flushfootnotes" name="flushtitlefootnotes">
    <xsl:variable name="footnotes" select=".//footnote[not(ancestor::table-wrap)]"/>
        <xsl:if test="$footnotes">
      <hr class="Footnoterule"/>
      <div class="Footnotes">
        <xsl:apply-templates mode="footnote" select="$footnotes"/>
      </div>
    </xsl:if>
  </xsl:template>

  <!-- The flushfootnotes template is called at the end of every section -->
  <xsl:template match="flushfootnotes" name="flushfootnotes">
    <xsl:variable name="footnotes" select=".//footnote[not(ancestor::table-wrap)]"/>
        <xsl:if test="$footnotes">
      <hr class="Footnoterule"/>
      <div class="Footnotes">
        <xsl:apply-templates mode="footnote" select="$footnotes"/>
      </div>
    </xsl:if>
      <!--/xsl:otherwise>
    </xsl:choose-->
  </xsl:template>

  <!-- mode: footnote - to output the footnotes from one region -->
  <xsl:template mode="footnote" match="*">
    <xsl:apply-templates mode="footnote"/>
  </xsl:template>

  <xsl:template match="footnote" mode="footnote">
    <xsl:variable name="globalnumber">
      <xsl:number level="any"/>
    </xsl:variable>
    <p class="Footnote">
      <a name="footnote-{$globalnumber}" href="#footnote-reference-{$globalnumber}">
      <xsl:apply-templates/>
        </a>
    </p>
  </xsl:template>

  <xsl:template match="table-wrap//footnote" mode="footnote">
    <xsl:variable name="globalnumber">
      <xsl:number level="any"/>
    </xsl:variable>
    <tr class="tfoot">
      <td colspan="{ancestor::table-wrap/cals-table/tgroup/@cols}">
        <xsl:for-each select="@styleCode[.='1']">
          <hr size="2px" width="120px" align="left" />
        </xsl:for-each>
        <p class="Footnote">
          <a name="footnote-{$globalnumber}" href="#footnote-reference-{$globalnumber}">
            <xsl:apply-templates/>
          </a>
        </p>
      </td>
    </tr>
  </xsl:template>

  <xsl:template mode="footnote" match="section|table"/>

  <!-- CROSS REFERENCE linkHtml -->

  <xsl:template match="linkHtml[@href]">
    <xsl:variable name="label" select="substring-after(@href,'#')"/>
    <xsl:variable name="target" select="key('element-by-ID',$label)"/>
    <xsl:variable name="report-string">
      <xsl:choose>
        <xsl:when test="not(starts-with(@href,'#'))">
          <xsl:text> link (@href='</xsl:text>
          <xsl:value-of select="@href"/>
          <xsl:text>') not constructed properly</xsl:text>
        </xsl:when>
        <xsl:when test="not($label and $target)">
          <xsl:text> link to '</xsl:text>
          <xsl:value-of select="$label"/>
          <xsl:text>' identifies no target in this document</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <span style="font-size:80%">
            <xsl:text> (link to </xsl:text>
            <xsl:value-of select="name($target)"/>
            <xsl:text>[@ID='</xsl:text>
            <xsl:value-of select="@href"/>
            <xsl:text>'])</xsl:text>
          </span>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <a>
      <xsl:if test="$target">
        <xsl:attribute name="href">
          <xsl:value-of select="@href"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
      <xsl:if test="$colorproof">
        <span class="QA-warning">
          <xsl:copy-of select="$report-string"/>
        </span>
      </xsl:if>
    </a>
  </xsl:template>

  <!-- SECTION MODEL -->

  <xsl:template match="section">
    <xsl:if test="not(@type='inserts') or $colorproof">
      <div>
        <xsl:call-template name="assign-class">
          <xsl:with-param name="style-attrs" select="@styleCode | @type"/>
          <xsl:with-param name="string" select="'section'"/>
        </xsl:call-template>
        <xsl:apply-templates select="@*" mode="report"/>
        <a name="{@ID}"/>
        <xsl:apply-templates/>
      </div>
      <xsl:apply-templates select=".//table-here[not(ancestor::paragraph|ancestor::list)]" mode="include"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="section/title">
    <xsl:param name="sectionLevel" select="count(ancestor::section)"/>
    <xsl:if test="not(@styleCode='run-in')">
      <!-- if this is a run-in title, it will be included with
        the first paragraph -->
      <xsl:variable name="tag" select="concat('h',$sectionLevel)"/>
      <xsl:element name="{$tag}">
        <xsl:call-template name="assign-title-class"/>
        <xsl:apply-templates select="@*" mode="report"/>
<!--        <xsl:if test="not(../preceding-sibling::section[title] or ../parent::component/preceding-sibling::component/section/title)">-->
          <!-- recursive processing of run-in titles -->
          <xsl:apply-templates select="preceding::title[1][@styleCode='run-in'][. >> current()/preceding::paragraph[1]]" mode="run-in"/>
          <!-- if this title is in a first section, also grab the nearest title above it if it's a run-in  -->
<!--        </xsl:if>-->
        <xsl:apply-templates/>
      </xsl:element>
      <xsl:call-template name="flushtitlefootnotes"/>
    </xsl:if>
    <!-- 11-15-05: add the footnote to the section title -->
  </xsl:template>

  <xsl:template match="title">
    <!-- for titles not directly inside sections (an h4 comes out clean) -->
    <h4 class="{name(..)}-title">
      <xsl:apply-templates/>
    </h4>
  </xsl:template>
  
  <xsl:template match="title" mode="run-in">
    <xsl:variable name="sectionLevel" select="count(ancestor::section)"/>
    <!-- recursive processing of run-in titles -->
    <xsl:apply-templates mode="run-in"
      select="preceding::title[1][@styleCode='run-in']
                              [. >> current()/preceding::paragraph[1]]"/>
    <!-- if this title is in a first section, also grab the nearest title above it if it's a run-in  -->
    <span>
      <xsl:call-template name="assign-title-class">
        <xsl:with-param name="run-in" select="true()"/>
      </xsl:call-template>
      <a name="{ancestor::section[1]/@ID}">
        <xsl:apply-templates select="ancestor::section[1]/title/node()"/>
      </a>
    </span>
  </xsl:template>

  <xsl:template name="assign-title-class">
    <xsl:param name="run-in" select="false()"/>
    <xsl:variable name="sectionLevel" select="count(ancestor::section)"/>
    <xsl:variable name="tag" select="concat('h',$sectionLevel)"/>
    <xsl:attribute name="class">
      <xsl:if test="$run-in">run-in </xsl:if>
      <!-- section titles greater than three levels deep (i.e. sub3, sub4 etc.)
        are marked as "alert" (formatting is expected to be overridden by 
        content element children -->
      <xsl:if test="$sectionLevel &gt; 3">
        <xsl:text>alert </xsl:text>
      </xsl:if>
      <xsl:if test="@language='local'">
        <xsl:text>local </xsl:text>
        <!-- Another value is assigned for titles where local formatting should override
          the default, just in case the CSS finds this useful -->
      </xsl:if>
      <xsl:value-of select="$tag"/>
    </xsl:attribute>
  </xsl:template>
  
  <xsl:template match="id | code">
    <xsl:if test="$colorproof">
      <p class="QA-warning">
        <xsl:value-of select="name()"/>
        <xsl:apply-templates select="@*" mode="literal"/>
      </p>
    </xsl:if>
  </xsl:template>

  <xsl:template match="text">
    <xsl:call-template name="attr-label-block"/>
    <xsl:apply-templates/>
    <xsl:call-template name="flushfootnotes"/>
  </xsl:template>

  <!-- DISPLAY SUBJECT STRUCTURED INFORMATION -->

  <xsl:template match="excerpt|subjectOf"/>

  <xsl:template match="section/subject"/>
  <!-- This element won't be in SPLPlus -->

  <!-- PARAGRAPH MODEL -->

  <xsl:template match="paragraph">
    <p>
      <xsl:call-template name="assign-class">
        <xsl:with-param name="style-attrs"
          select="@styleCode |
                  @class[normalize-space()='center' or
                         normalize-space()='indent']"/>
        <xsl:with-param name="string">
          <xsl:if test="not(preceding-sibling::paragraph)">First </xsl:if>
          <xsl:if test="@styleCode='ProdGuide_crossref'">center italics </xsl:if>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:apply-templates select="@*" mode="report"/>
      <xsl:apply-templates select="preceding::title[1][@styleCode='run-in'][. >> current()/preceding::paragraph[1]]" mode="run-in"/>
      <xsl:if test="@styleCode='ProdGuide_crossref'">Shown in Product Identification Guide, page </xsl:if>
      <xsl:apply-templates select="caption"/>
      <xsl:apply-templates select="node() except caption"/>
    </p>
    <xsl:apply-templates select=".//table-here" mode="include"/>
  </xsl:template>

  <xsl:template match="paragraph/caption">
    <span>
      <xsl:call-template name="assign-class">
        <xsl:with-param name="style-attrs" select="@styleCode"/>
        <xsl:with-param name="string" select="'ParagraphCaption'"/>
      </xsl:call-template>
      <xsl:apply-templates select="@*" mode="report"/>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <!-- the old poor man's footnote -->
  <xsl:template match="paragraph[contains(@styleCode,'Footnote') and caption]">
    <dl class="Footnote">
      <xsl:apply-templates select="@*" mode="report"/>
      <dt><xsl:apply-templates select="caption"/></dt>
      <dd><xsl:apply-templates select="node() except caption"/></dd>
    </dl>
  </xsl:template>

  <!-- LIST MODEL -->

  <!-- listType='unordered' is default, if any item has a caption,
       all should have a caption -->

  <xsl:template match="list[not(item/caption)]">
    <xsl:call-template name="attr-label-block"/>
    <xsl:apply-templates select="caption"/>
    <ul>
      <xsl:call-template name="assign-class">
        <xsl:with-param name="style-attrs" select="@styleCode | @class | @type"/>
      </xsl:call-template>
      <xsl:apply-templates select="node()[not(self::caption)]"/>
    </ul>
    <xsl:apply-templates select=".//table-here[not(ancestor::paragraph)]" mode="include"/>
  </xsl:template>

  <xsl:template match="list[@listType='ordered' and
       not(item/caption)]" priority="1">
    <xsl:call-template name="attr-label-block"/>
    <xsl:apply-templates select="caption"/>
    <ol>
      <xsl:call-template name="assign-class">
        <xsl:with-param name="style-attrs" select="@styleCode | @class | @type"/>
      </xsl:call-template>
      <xsl:apply-templates select="node()[not(self::caption)]"/>
    </ol>
  </xsl:template>

  <xsl:template match="list/item[not(parent::list/item/caption)]">
    <li>
      <xsl:apply-templates select="@*" mode="report"/>
      <xsl:apply-templates/>
    </li>
  </xsl:template>

  <!-- lists with custom captions -->
  <xsl:template match="list[item/caption]">
    <xsl:call-template name="attr-label-block"/>
    <xsl:apply-templates select="caption"/>
    <dl>
      <xsl:call-template name="assign-class">
        <xsl:with-param name="style-attrs" select="@styleCode | @class | @type"/>
      </xsl:call-template>
      <xsl:apply-templates select="node()[not(self::caption)]"/>
    </dl>
    <xsl:apply-templates select=".//table-here[not(ancestor::paragraph)]" mode="include"/>
  </xsl:template>

  <xsl:template match="list/item[../item/caption]">
    <xsl:apply-templates select="caption"/>
    <dd>
      <xsl:call-template name="assign-class">
        <xsl:with-param name="style-attrs" select="@styleCode | @type"/>
      </xsl:call-template><xsl:apply-templates select="@*" mode="report"/>
      <xsl:apply-templates select="node()[not(self::caption)]"/>
    </dd>
  </xsl:template>

  <xsl:template match="list/item/caption">
    <dt>
      <xsl:call-template name="assign-class">
        <xsl:with-param name="style-attrs" select="@styleCode | @type"/>
      </xsl:call-template><xsl:apply-templates select="@*" mode="report"/>
      <xsl:apply-templates/>
    </dt>
  </xsl:template>

  <xsl:template match="list/caption">
    <p>
      <xsl:call-template name="assign-class">
        <xsl:with-param name="style-attrs" select="@styleCode"/>
        <xsl:with-param name="string" select="'ListCaption'"/>
      </xsl:call-template>
      <xsl:apply-templates select="@*" mode="report"/>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <!-- TABLE MODEL -->
  <!-- table rendering code HAS BEEN REMOVED from this spot in the FDA stylesheet -->

  <xsl:template match="table-here">
    <!-- a callout for a table, table-here is rendered as an inline
         indicator, with the table itself placed after the paragraph,
         list, text, section or component inside which the table-here appears -->
    <xsl:if test="$colorproof">
      <span>
        <xsl:call-template name="assign-class">
          <xsl:with-param name="string" select="'Tablehere'"/>
        </xsl:call-template>
        <xsl:text>[table callout here: </xsl:text>
        <xsl:apply-templates select="@*" mode="report"/>
        <xsl:text>]</xsl:text>
      </span>
    </xsl:if>
  </xsl:template>

  <xsl:template match="table-here" mode="include">
    <!-- a callout for a table, table-here is rendered as an inline
         indicator, with the table itself placed after the paragraph,
         list, or text inside which the table-here appears -->
    <xsl:variable name="target" select="key('element-by-ID',@rid)"/>
    <xsl:if test="not($target)">
      <p class="QA-warning">NOTE: table-here not resolving</p>
      <xsl:call-template name="attr-label-block"/>
    </xsl:if>
    <xsl:apply-templates select="$target"/>
  </xsl:template>

  <xsl:template match="table-wrap">
    <div class="Table">
      <xsl:call-template name="attr-label-block"/>
      <xsl:apply-templates/>
      <br/>
    </div>
  </xsl:template>

  <xsl:template match="cals-table">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="table-wrap//footnote"/>
  <!-- footnotes are picked up in a special mode, so are suppressed
       from regular traversal -->

  <!-- content elements are quite troublesome. Structurally they are inline,
       but semantically they sometimes represent blocks. Since HTML does
       not allow blocks (such as p or div) in the midst of running text,
       content elements that designate block structures are handled as if
       they were inline, except they are postpended with a line break (br).

       Accordingly, in several cases formatting properly assigned to blocks
       (center- and right-flush formatting) or otherwise not readily
       handled by HTML (dot- and space-leaders) must be represented
       by literal description in the output, not appropriate formatting.

       When @emphasis='yes' content is mapped to HTML em.

       An XSLT 2.0 xsl:next-match cascade traps content elements with
       settings on more than one attribute.

   -->

  <xsl:template match="content[@styleCode='center']" priority="2">
    <span class="fill">
      <xsl:text>&#xA0;.&#xA0;.&#xA0;.&#xA0; center &#xA0;.&#xA0;.&#xA0;.&#xA0;</xsl:text>
    </span>
    <xsl:next-match/>
    <span class="fill">
      <xsl:text>&#xA0;.&#xA0;.&#xA0;.&#xA0; center &#xA0;.&#xA0;.&#xA0;.&#xA0;</xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="content[@styleCode='right']" priority="2">
    <span class="fill">
      <xsl:text>&#xA0;.&#xA0;.&#xA0;.&#xA0; right flush &#xA0;.&#xA0;.&#xA0;.&#xA0;</xsl:text>
    </span>
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="content[@emphasis='yes']" priority="1">
    <em>
      <xsl:next-match/>
    </em>
  </xsl:template>

  <xsl:template match="content">

<!-- As commented in the DTD, titles expect styling from content elements with values
     (center | right | plain-text | bold | italics |
      underline | dash-underline | bold-italics | italics-underline |
      bold-underline | bold-italics-underline) -->

<!-- values of @styleCode allowed on content:
    (Title-Stacked | subTitle-descriptive | subTitle-generic |
     Title-prefix | phonetic | dot-leader-fill | space-leader-fill |
     center | right | plain-text | bold | italics | underline |
     dash-underline | bold-italics | italics-underline | bold-underline |
     bold-italics-underline | cross-ref | sans-serif) -->

<!-- We face a special requirement to emulate Penta formatting of section titles
     with respect to overriding formatting of content element @styleCode values when:
     - The content/@styleCode values are any of
          (bold | italics | underline | dash-underline | bold-italics | italics-underline
           | bold-underline | bold-italics-underline | sans-serif )
     - The title appears in a section level less than or equal to 3 (that is, up to a sub2 section),
       and is not set to @language='local' -->

<!-- To accommodate these special cases, we set a styleCode-overrides variable -->
    <xsl:variable name="styleCode-overrides"
      select="('bold', 'italics', 'underline', 'dash-underline', 'bold-italics',
      'italics-underline', 'bold-underline', 'bold-italics-underline', 'sans-serif' )"/>

    <span>
      <xsl:call-template name="assign-class">
        <xsl:with-param name="style-attrs" select="@styleCode
          [not(ancestor::title[parent::section]
            [count(ancestor::section) &lt;= 3]
            [not(@language='local' or ../code[@displayName='Title_section'])]
          (: we skip the @styleCode when we are inside particular titles :)
           and .=$styleCode-overrides)
          (: and when we have particular values :) ]
          | @emphasis | @revised"/>
      </xsl:call-template>
      <xsl:apply-templates select="@*" mode="report"/>
      <xsl:apply-templates select="." mode="fill"/>
      <xsl:apply-templates/>
      <xsl:for-each select="@styleCode
        [contains('phonetic subTitle-descriptive Title-Stacked Title-prefix',.)]">
        <br/>
      </xsl:for-each>
    </span>
  </xsl:template>


  <xsl:template match="content" mode="fill"/>
  <!-- this default prevents the content of content from duplicating,
       since this mode is only to append data to certain content elements -->

  <xsl:template match="content[@styleCode='dot-leader-fill']" mode="fill">
    <span class="fill"> [ ... ... dot-leader-fill ... ... ] </span>
  </xsl:template>

  <xsl:template match="content[@styleCode='space-leader-fill']" mode="fill">
    <span class="fill"> [ &#xA0;&#xA0;&#xA0; space-leader-fill &#xA0;&#xA0;&#xA0; &#xA0;&#xA0;&#xA0; &#xA0;&#xA0;&#xA0; ] </span>
  </xsl:template>


  <!-- We don't use <sub> and <sup> elements here because IE produces
       ugly uneven line spacing. -->
  <xsl:template match="sub">
    <span class="Sub">
      <xsl:apply-templates select="@*" mode="report"/>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="sup">
    <span class="Sup">
      <xsl:apply-templates select="@*" mode="report"/>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="br">
    <br/>
  </xsl:template>

  <xsl:template
      match="renderMultiMedia[@referencedObject]">
    <xsl:variable name="reference" select="@referencedObject"/>
    <xsl:variable name="gi">
      <!-- we want this in a div if a child of a table, otherwise in line -->
      <xsl:choose>
        <xsl:when test="parent::table">div</xsl:when>
        <xsl:otherwise>span</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$gi}">
      <xsl:call-template name="assign-class">
        <xsl:with-param name="style-attrs" select="@styleCode | @emphasis | @revised"/>
        <xsl:with-param name="string" select="'Figure'"/>
      </xsl:call-template>
      <xsl:choose>
        <xsl:when test="$gi='table'">
          <xsl:call-template name="attr-label-block"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="attr-label-span"/>
        </xsl:otherwise>
      </xsl:choose>
      <img src="{//observationMedia[@ID=$reference]//reference/@value}" alt="{@referencedObject}"/>
      <xsl:apply-templates select="caption"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="renderMultiMedia/caption">
    <p>
      <xsl:call-template name="assign-class">
        <xsl:with-param name="style-attrs" select="@styleCode | @emphasis | @revised"/>
        <xsl:with-param name="string" select="'MultiMediaCaption'"/>
      </xsl:call-template>
      <xsl:apply-templates select="@*" mode="report"/>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="observationMedia">
    <div>
      <xsl:call-template name="assign-class">
        <xsl:with-param name="style-attrs" select="@class-code"/>
        <xsl:with-param name="string" select="'ObservationMedia'"/>
      </xsl:call-template>
      <xsl:call-template name="attr-label-block"/>
      <xsl:apply-templates select="value"/>
      <img src="{reference/@value}" alt="{@ID}"/>
    </div>
  </xsl:template>

  <xsl:template match="observationMedia/value">
    <p>
      <xsl:call-template name="assign-class">
        <xsl:with-param name="style-attrs" select="@class-code"/>
        <xsl:with-param name="string" select="concat('ObservationMedia-',name())"/>
      </xsl:call-template>
      <xsl:value-of select="name()"/>
      <xsl:text>: </xsl:text>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="observationMedia/value/reference">
    <xsl:text>(reference </xsl:text>
    <xsl:value-of select="@value"/>
    <xsl:text>)</xsl:text>
  </xsl:template>


  <!-- QA REPORTING TEMPLATES -->

  <!-- attributes we've either accounted for sufficiently, or don't need
       to see reported - pls check this list! -->
  <xsl:template match="@mediaType | @integrityCheckAlgorithm" mode="report"/>

  <xsl:template match="@classCode | @moodCode | @representation" mode="report"/>

  <xsl:template match="@class[.='normal']" mode="report"/>

  <xsl:template match="@styleCode" mode="report"/>

  <!-- default attribute processing in 'report' mode -->
  <xsl:template match="@*" mode="report">
    <xsl:if test="$colorproof">
      <span class="QA-warning">
        <xsl:text> </xsl:text>
        <xsl:value-of select="local-name(..)"/>
        <xsl:text>/@</xsl:text>
        <xsl:value-of select="local-name()"/>
        <xsl:text>: </xsl:text>
        <span style="font-size:140%; font-weight: normal; color:darkred">
          <xsl:value-of select="."/>
        </span>
      </span>
    </xsl:if>
  </xsl:template>

  <!-- literal mode is for writing out attribute value literals -->
  <xsl:template match="@*" mode="literal">
    <xsl:text> @</xsl:text>
    <xsl:value-of select="local-name()"/>
    <xsl:text>='</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>'</xsl:text>
  </xsl:template>

  <xsl:template name="contents-table">
    <xsl:if test="$colorproof">
      <div class="contents">
        <h5 style="margin:0em">Outline view of sections for proofing:</h5>
        <xsl:apply-templates select="/document" mode="contents"/>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="component | structuredBody" mode="contents">
    <xsl:apply-templates select="component | structuredBody | section" mode="contents"/>
  </xsl:template>

  <xsl:template match="document | section" mode="contents">
    <xsl:variable name="suppress" select="count(.|$toc-suppress)=count($toc-suppress)"/>
    <!-- $suppress gets a Boolean value of true() if the node is among
         those we'd like to suppress from the contents table -->
    <xsl:if test="not($suppress)">
      <div class="contents-section">
        <span class="contents-entry">
          <a href="#{@ID}">
            <xsl:apply-templates select="title" mode="contents"/>
            <xsl:if test="not(normalize-space(title))">_____</xsl:if>
          </a>
        </span>

        <xsl:apply-templates select="component" mode="contents"/>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:variable name="toc-suppress" select="
    //section[@type='inserts'] |
    //section[code[@codeSystem='comp' and @code='CMS']] |
    //section[code[@codeSystem='comp' and @code='CLOSER']]"/>
  <!-- this variable collects all the sections we WISH TO SUPPRESS from
       the ToC (with their descendants) ... for now:
       any section w/ @type='inserts'
       any section marked as a comp system CLOSER -->


  <!-- A utility template for creating a block where we can report
    attributes of interest (when no better place is available) -->
  <xsl:template name="attr-label-block">
    <xsl:variable name="attr-label">
      <xsl:apply-templates select="@*" mode="report"/>
    </xsl:variable>
    <xsl:if test="$colorproof and string($attr-label)">
      <p class="QA-warning">
        <xsl:copy-of select="$attr-label"/>
      </p>
    </xsl:if>
  </xsl:template>

  <!-- Another utility template works the same way,
       but is to be used in line -->
  <xsl:template name="attr-label-span">
    <xsl:variable name="attr-label">
      <xsl:apply-templates select="@*" mode="report"/>
    </xsl:variable>
    <xsl:if test="$colorproof and string($attr-label)">
      <span class="QA-warning">
        <xsl:copy-of select="$attr-label"/>
      </span>
    </xsl:if>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:analyze-string select="." regex="\[\i\c+;\]">
      <xsl:matching-substring>
        <span class="entityref">
          <xsl:text>&amp;</xsl:text>
          <xsl:value-of select="translate(.,'[]','')"/>
        </span>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="."/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>


</xsl:transform>
