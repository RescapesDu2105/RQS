<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="1.0">
    <xsl:param name="progXML"/>
    <xsl:variable name="programmation" select="document($progXML)"/>
    
    <xsl:template match="/">    
        <html>
            <head>
                <title>FeedBack<xsl:value-of select="$progXML"/></title>
            </head>
            <h1>Feedbacks 
                <span><xsl:value-of select="$progXML"/></span>
            </h1>
            <body>            
                <div>
                    <xsl:apply-templates select="/feedback/programmation"/>
                </div>
            </body>
        </html>
        
    </xsl:template>
    
    <xsl:template match="/feedback/programmation">
        <feedback>
            <div><xsl:value-of select="@id"/></div>
            <div><xsl:value-of select="error"/></div>
            <div><xsl:value-of select="isok"/></div>
        </feedback>
    
        <programmation>
            <xsl:variable name="demID" select="@id"/>
            <div><xsl:value-of select="$demID"/></div>
            <div><xsl:value-of select="$programmation/programmation/demande[@idDemande=$demID]/complexe"/></div>
            <div><xsl:value-of select="$programmation/programmation/demande[@idDemande=$demID]/fin"/></div>
            <div><xsl:value-of select="$programmation/programmation/demande[@idDemande=$demID]/movie"/></div>
            <div><xsl:value-of select="$programmation/programmation/demande[@idDemande=$demID]/copy"/></div>
            <div><xsl:value-of select="$programmation/programmation/demande[@idDemande=$demID]/salle"/></div>
            <div><xsl:value-of select="$programmation/programmation/demande[@idDemande=$demID]/heure"/></div>
        </programmation>
    </xsl:template>
    
</xsl:stylesheet>