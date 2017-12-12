<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template match="/">
        <feedback>
            <xsl:apply-templates/>
        </feedback>
    </xsl:template>
    <xsl:template match="programmation">
        <programmation>
            <xsl:copy-of select="error"/>
            <id> <xsl:value-of select="/feedback/programmation/@id"/></id>
        </programmation>
    </xsl:template>
    
</xsl:stylesheet>