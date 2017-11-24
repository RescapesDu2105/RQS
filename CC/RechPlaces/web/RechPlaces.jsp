<%-- 
    Document   : RechPlaces
    Created on : 23-nov.-2017, 11:37:12
    Author     : Philippe
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
        <meta name="description" content="">
        <meta name="author" content="">
        <title>RQS - Recherche de places libres</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css" integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb" crossorigin="anonymous">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <div class="collapse navbar-collapse" id="navbarCollapse">
                <a class="navbar-brand" href="#"><i class="fa fa-film"></i><strong> Rennequinepolis</strong></a>
            </div>
        </nav>
        <div class="container" id="main"> 
            <div class="col-md-12 mt-5"></div>
                <h2 class="display-4 text-center">Recherche de places disponibles</h2>
                <div class="card">
                    <div class="card-body">
                        <h2 class="card-title text-center">Critères de recherche</h2>
                        <form class="form-inline" id="searchForm" action="ControlerServlet" method="GET">
                            <div class="row mx-auto">
                                <div class="col">
                                    <label for="complexeInput">Complexe</label>
                                    <select name="complexeInput" id="complexeInput" type="text" class="form-control" placeholder="First name">
                                        <option value="CC1">CC1</option>
                                        <option value="CC2">CC2</option>
                                        <option value="CC3">CC3</option>
                                        <option value="CC4">CC4</option>
                                        <option value="CC5">CC5</option>
                                        <option value="CC6">CC6</option>
                                    </select>
                                </div>
                                <div class="col" id="divPopSel">
                                    <label for="populariteSelect">La popularité des films</label>
                                    <select name="populariteSelect" id="populariteSelect" type="text" class="form-control" placeholder="Inf" style="width: 165px;">
                                        <option value="Default">Par défaut</option>
                                        <option value="Inf">Inférieure à</option>
                                        <option value="Sup">Supérieure à</option>
                                        <option value="Egale">Égale à</option>
                                    </select>
                                </div>
                                <!--<div class="col">   
                                    <label for="PopInput">Valeur</label>
                                    <input type="text" name="PopInput" id="PopInput" class="form-control" style="width: 75px;" hidden>
                                </div> -->
                                <div class="col" id="divPerSel">
                                    <label for="perenniteSelect">La pérennité des films</label>
                                    <select name="perenniteSelect" id="perenniteSelect" type="text" class="form-control" placeholder="Inf" style="width: 165px;">
                                        <option value="Default">Par défaut</option>
                                        <option value="Inf">Inférieure à</option>
                                        <option value="Sup">Supérieure à</option>
                                        <option value="Egale">Égale à</option>
                                    </select>
                                </div>
                                <!--<div class="col">   
                                    <label for="PopInput">Valeur</label>
                                    <input type="text" name="PopInput" id="PopInput" class="form-control" style="width: 75px;" hidden> 
                                </div>-->
                            </div>
                            <div class="row mx-auto">
                                <div class="col">   
                                    <label for="acteursInput">Le(s) acteur(s)</label>
                                    <input type="text" name="acteursInput" id="acteursInput" class="form-control">
                                </div>
                                <div class="col">   
                                    <label for="realisateursInput">Le(s) réalisateur(s)</label>
                                    <input type="text" name="realisateursInput" id="realisateursInput" class="form-control">
                                </div>
                                <div class="col">   
                                    <label for="genresInput">Le(s) genre(s)</label>
                                    <input type="text" name="genresInput" id="genresInput" class="form-control">
                                </div>
                                <div class="col">   
                                    <label for="titreInput">Le titre ou une partie du titre</label>
                                    <input type="text" name="titreInput" id="titreInput" class="form-control" style="width: 300px;">
                                </div>
                            </div>
                            <div class="row mx-auto mt-4">                                
                                <div class="col">
                                    <button class="btn btn-lg btn-success" type="submit" id="submit"><i class="fa fa-search"></i> Rechercher</button>
                                </div>                                
                            </div>
                        </form>
                    </div>
                </div>
            </div>  
        </div>
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js" integrity="sha384-vFJXuSJphROIrBnz7yo7oB41mKfc8JzQZiCq4NCceLEaO4IHwicKwpJf9c9IpFgh" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js" integrity="sha384-alpBpkh1PFOepccYVYDB4do5UnbKysX5WZXm3XxPqe5iKTfUKjNkCk9SaVuEZflJ" crossorigin="anonymous"></script> 
        <script>
                document.addEventListener("DOMContentLoaded", function() {
                    document.querySelector('select[name="populariteSelect"]').onchange=FctPopularite; }, false);

                document.addEventListener("DOMContentLoaded", function() { 
                    document.querySelector('select[name="perenniteSelect"]').onchange=FctPerennite; }, false);
            

            function FctPopularite(event)
            {
                console.log(event.target.value);
                switch(event.target.value)
                {
                    case "Default" :                        
                        var divPopularite = document.getElementById("divPopularite");
                        divPopularite.parentElement.removeChild(divPopularite);

                        break;
                    default:
                        if(!document.getElementById("divPopularite"))
                        {
                            var col = document.createElement("div");
                            col.setAttribute("class", "col");
                            col.setAttribute("id", "divPopularite");

                            var label = document.createElement("label");
                            label.setAttribute("for", "PopInput");
                            label.innerText = "Valeur";

                            var input = document.createElement("input");
                            input.setAttribute("type", "text");
                            input.setAttribute("name", "PopInput");
                            input.setAttribute("id", "PopInput");
                            input.setAttribute("class", "form-control");
                            input.style.width = "75px";
                            
                            col.appendChild(label);
                            col.appendChild(input);
                            var divPopSel = document.getElementById('divPopSel');
                            divPopSel.parentElement.insertBefore(col, document.getElementById('divPerSel'));
                        }                        
                        break;
                }
            }

            function FctPerennite(event)
            {
                switch(event.target.value)
                {
                    case "Default" :
                        var divPerennite = document.getElementById("divPerennite");
                        divPerennite.parentElement.removeChild(divPerennite);

                        break;
                    default:
                        if(!document.getElementById("divPerennite"))
                        {
                            var col = document.createElement("div");
                            col.setAttribute("class", "col");
                            col.setAttribute("id", "divPerennite");

                            var label = document.createElement("label");
                            label.setAttribute("for", "PerInput");
                            label.innerText = "Valeur";

                            var input = document.createElement("input");
                            input.setAttribute("type", "text");
                            input.setAttribute("name", "PerInput");
                            input.setAttribute("id", "PerInput");
                            input.setAttribute("class", "form-control");
                            input.style.width = "75px";
                            
                            col.appendChild(label);
                            col.appendChild(input);

                            var divPopSel = document.getElementById('divPopSel');
                            divPopSel.parentElement.appendChild(col);
                        }
                        break;
                }
            }
        </script>
    </body>
</html>
