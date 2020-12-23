<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--The <xsl:apply-templates> element applies a template to the current 
    element or to the current element's child nodes.
    If we add a "select" attribute to the <xsl:apply-templates> element,
    it will process only the child elements that matches the value of
    the attribute. We can use the "select" attribute to specify in which
     order the child nodes are to be processed. -->

<!-- Template dla całego roota-->

<xsl:template match="/">
  <html>
  <body>
  <h2>My CD Collection</h2>  
  <xsl:apply-templates/>  
  </body>
  </html>
</xsl:template>

<xsl:template match="cd">
  <p>
    <xsl:apply-templates select="title"/>  
    <xsl:apply-templates select="artist"/>
  </p>
</xsl:template>

<xsl:template match="title">
  Title: <span style="color:#ff0000">
  <xsl:value-of select="."/></span>
  <br />
</xsl:template>

<xsl:template match="artist">
  Artist: <span style="color:#00ff00">
  <xsl:value-of select="."/></span>
  <br />
</xsl:template>

</xsl:stylesheet>