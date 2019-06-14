<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
  version   = "1.0"
  xmlns = "http://riboseinc.com/isoxml"
  xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"
  xmlns:ltx = "http://dlmf.nist.gov/LaTeXML"
  xmlns:str = "http://exslt.org/strings"
  extension-element-prefixes = "str"
  exclude-result-prefixes = "ltx str">

<xsl:output
  method = "xml"
  encoding = "UTF-8"/>

  <!-- remove latexml processing instructions -->
  <xsl:template match="/processing-instruction('latexml')">
    <xsl:apply-templates select="*"/>
  </xsl:template> 

  <!-- identity -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template> 

  <!-- erase tags (present in headings) -->
  <xsl:template match="ltx:tags"/>

  <!-- unwrap children of paras (which should be a single p) -->
  <xsl:template match="ltx:para">
    <xsl:apply-templates select="*"/>
  </xsl:template>

  <!-- insert content of ps -->
  <xsl:template match="ltx:p">
    <p><xsl:apply-templates select="node()"/></p>
  </xsl:template>

  <!-- get text of titles -->
  <xsl:template match="ltx:title">
    <xsl:if test="text()">
      <!-- TODO: remove title from terms -->
      <title><xsl:apply-templates select="text()"/></title>
    </xsl:if>
  </xsl:template>

  <xsl:template match="ltx:section|ltx:subsection">
    <clause>
      <xsl:copy-of select="@obligation"/>
      <preferred><xsl:value-of select="ltx:title/text()"/></preferred>
      <xsl:for-each select="str:tokenize(@alternate, ',')">
        <alternate><xsl:value-of select="."/></alternate>
      </xsl:for-each>
      <xsl:for-each select="str:tokenize(@deprecated, ',')">
        <deprecated><xsl:value-of select="."/></deprecated>
      </xsl:for-each>
      <xsl:if test="@domain">
        <domain><xsl:value-of select="@domain"/></domain>
      </xsl:if>
      <xsl:apply-templates/>
    </clause>
  </xsl:template>

  <xsl:template match="ltx:section[ltx:title/text()='Foreword' or @heading='foreword' or @foreword]">
    <foreword>
      <xsl:attribute name="obligation">informative</xsl:attribute>
      <xsl:apply-templates/>
    </foreword>
  </xsl:template>

  <xsl:template match="ltx:section[ltx:title/text()='Abstract' or @heading='abstract' or @abstract]">
    <abstract>
      <xsl:attribute name="obligation">informative</xsl:attribute>
      <xsl:apply-templates/>
    </abstract>
  </xsl:template>

  <xsl:template match="ltx:section[ltx:title/text()='Introduction' or @heading='introduction' or @introduction]">
    <introduction>
      <xsl:attribute name="obligation">informative</xsl:attribute>
      <xsl:apply-templates/>
    </introduction>
  </xsl:template>

  <xsl:template match="ltx:section[ltx:title/text()='Terms and definitions' or @heading='terms and definitions' or @termsanddefinitions]">
    <terms>
      <xsl:attribute name="obligation">normative</xsl:attribute>
      <xsl:apply-templates/>
    </terms>
  </xsl:template>

  <xsl:template match="ltx:section[ltx:title/text()='Normative references' or @heading='normative references' or @normativereferences]">
    <references>
      <xsl:attribute name="obligation">informative</xsl:attribute>
      <xsl:apply-templates/>
    </references>
  </xsl:template>

  <xsl:template match="ltx:document">
    <iso-standard>
      <!-- all sections preceding and excluding the first numbered one are grouped in the preface -->
      <preface>
        <xsl:for-each select="(ltx:section[@inlist])[1]/preceding-sibling::ltx:section">
          <xsl:apply-templates select="."/>
        </xsl:for-each>
      </preface>
      <!-- all sections following and including the first numbered one are grouped as clauses -->
      <sections>
        <!-- NOTE: unnumbered sections following the first numbered one are just suppressed -->
        <xsl:for-each select="ltx:section[@inlist]">
          <xsl:apply-templates select="."/>
        </xsl:for-each>
      </sections>
    </iso-standard>
  </xsl:template>

</xsl:stylesheet>