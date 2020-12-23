<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
<html>
    <body>
        <h2>CD Collection</h2>
        <table border = "1">
            <tr bgcolor="#9acd32">
                <th style="text-align:left">Title</th>
                <th style="text-align:left">Artist</th>
                <th style="text-align:left">Price</th>
            </tr>
            <!-- Operatory filtrowania outputu 
                1. =  (equal)
                2. != (not equal)
                3. &lt; less than
                4. &gt; greater than -->
            <xsl:for-each select='catalog/cd[artist = "Bob Dylan"]'>
            <!-- sortowanie -->
            <xsl:sort select="@title"/>
            <!-- konstrukcja IF -->
            <xsl:if test="price &lt; 10">
                <!-- konstrukcja choose -->
                <tr>
                    <xsl:choose>
                        <xsl:when test="year &lt; 1980">
                            <!-- odwolanie do wartosci atrybutu -->
                            <td bgcolor="#ff00ff">
                                <xsl:value-of select="@title"/>
                            </td>
                        </xsl:when>
                        <xsl:otherwise>
                            <td>
                                <xsl:value-of select="@title"/>
                            </td>
                        </xsl:otherwise>
                    </xsl:choose>

                    <!-- odwolanie do wartosci elementu -->
                    <td><xsl:value-of select="artist"/></td>
                    <td><xsl:value-of select="price"/></td>
                      
                </tr>
            </xsl:if>
        
            </xsl:for-each>
        </table>
        
    </body>
</html>
</xsl:template>
</xsl:stylesheet>