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
            <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css" integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb" crossorigin="anonymous"></link>
            <h1 class="display-3">Feedbacks 
                <span><xsl:value-of select="$progXML"/></span>
            </h1>
            <body>            
                <div>   
                    <table class ="table table-hover">
                        <thead class="thead-dark">
                            <tr>
                                <th scope="col" class="text-center">idFeedback</th>
                                <th scope="col" class="text-center">Error</th>
                                <th scope="col" class="text-center">isOk</th>
                                <th scope="col" class="text-center">idDemande</th>
                                <th scope="col" class="text-center">Complexe</th>
                                <th scope="col" class="text-center">Fin</th>
                                <th scope="col" class="text-center">Movie</th>
                                <th scope="col" class="text-center">Copy</th>
                                <th scope="col" class="text-center">Salle</th>
                                <th scope="col" class="text-center">Heure</th>                            
                            </tr>
                        </thead>
                        <tbody>                        
                            <xsl:apply-templates select="/feedback/programmation"/>
                        </tbody>
                    </table>
                </div>
                <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js" integrity="sha384-vFJXuSJphROIrBnz7yo7oB41mKfc8JzQZiCq4NCceLEaO4IHwicKwpJf9c9IpFgh" crossorigin="anonymous"></script>
                <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js" integrity="sha384-alpBpkh1PFOepccYVYDB4do5UnbKysX5WZXm3XxPqe5iKTfUKjNkCk9SaVuEZflJ" crossorigin="anonymous"></script>
                <script src="javascript.js"></script>
                <script>
                </script>
            </body>
        </html>
        
    </xsl:template>
    
    <xsl:template match="/feedback/programmation">  
        <tr class="tr">
            <th scope="row" class="text-center"><xsl:value-of select="@id"/></th>
            <td class="text-center"><xsl:value-of select="error"/></td>
            <td class="text-center isOk"><xsl:value-of select="isok"/></td>
       
            <xsl:variable name="demID" select="@id"/>
            <td class="text-center"><xsl:value-of select="$demID"/></td>
            <td class="text-center"><xsl:value-of select="$programmation/programmation/demande[@idDemande=$demID]/complexe"/></td>
            <td class="text-center"><xsl:value-of select="$programmation/programmation/demande[@idDemande=$demID]/fin"/></td>
            <td class="text-center"><xsl:value-of select="$programmation/programmation/demande[@idDemande=$demID]/movie"/></td>
            <td class="text-center"><xsl:value-of select="$programmation/programmation/demande[@idDemande=$demID]/copy"/></td>
            <td class="text-center"><xsl:value-of select="$programmation/programmation/demande[@idDemande=$demID]/salle"/></td>
            <td class="text-center"><xsl:value-of select="$programmation/programmation/demande[@idDemande=$demID]/heure"/></td>
        </tr>
    </xsl:template>
    
</xsl:stylesheet>