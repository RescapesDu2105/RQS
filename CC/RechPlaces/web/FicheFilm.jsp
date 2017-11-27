<%-- 
    Document   : FicheFilm
    Created on : 26-nov.-2017, 21:01:19
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
                <a class="navbar-brand" href="RechPlaces.jsp"><i class="fa fa-film"></i><strong> Rennequinepolis</strong></a>
            </div>
        </nav>    
        <div class="container-fluid col-md-10 mt-3"> 
            <button id="button" class="btn btn-secondary"><i class="fa fa-chevron-left" aria-hidden="true"></i> Retourner sur la page principale</button>
            
            <h1 class="display-4 text-left font-weight-bold">Mad Max Fury Road</h1>
            <hr>
            
            <div class="row mt-3">
                <div class="col">
                    <figure class="figure">
                        <img class="rounded float-left" alt="No free image man (en)" src="https://image.tmdb.org/t/p/w185/kqjL17yufvn9OVLyXYpvtyrFfak.jpg"/>
                        <figcaption class="figure-caption text-center">Date de sortie : 14 mai 2015</figcaption>
                    </figure>
                </div>
                <div class="col-10">
                    <h3>Résumé :</h3>
                    <p>Ancien policier de la route, Max Rockatansky (Tom Hardy) erre désormais seul au volant de son bolide (une Ford Falcon XB 351) dans un monde dévasté où les clans de cannibales, les sectes et les gangs de motards s'affrontent dans des déserts sans fin pour l'essence et l'eau. L'un de ces clans est aux ordres de « Immortan Joe » (Hugh Keays-Byrne), un ancien militaire devenu leader tyrannique2. L'une de ses plus fidèles partisanes, l'« imperator » Furiosa (Charlize Theron), le trahit et s'enfuit avec un bien d'une importance capitale pour le chef de guerre : ses « épouses », un groupe de jeunes femmes lui servant d'esclaves et de « pondeuses ».</p>
                    <!--<p><b>Réalisateur(s) :</b> George Miller</p> -->
                    <div class="row">
                        <div class="col">                        
                            <p><b>Popularité :</b> 120.000 places vendues environ</p>
                        </div>
                        <div class="col">                        
                            <p><b>Nombre de semaines au Box-office :</b> 10</p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col">
                            <p><b>Genre :</b> science-fiction dystopique, road movie</p>
                        </div>
                        <div class="col">                        
                            <p><b>Public cible :</b> Les adolescents rebelles</p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col">
                            <p><b>Réalisateur :</b> Georges Miller</p>
                        </div>
                        <div class="col">
                            
                        </div>
                    </div>
                </div>
            </div>
            <div class="row mt-2">
                <div class="col-md-4">
                    <div id="accordion" role="tablist">
                        <div class="card">
                            <div class="card-header" role="tab" id="headingOne">
                                <h5 class="mb-0">
                                    <a data-toggle="collapse" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                        Acteurs
                                    </a>
                                </h5>
                            </div>

                            <div id="collapseOne" class="collapse show" role="tabpanel" aria-labelledby="headingOne" data-parent="#accordion">
                                <div class="card-body">
                                    <table class="table table-hover table-bordered">
                                        <thead class="thead-dark">
                                          <tr>
                                            <th scope="col" class="text-center">Nom</th>
                                            <th scope="col" class="text-center">Rôle</th>
                                          </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td class="text-center">Tom Hardy</td>
                                                <td class="text-center">Max Rockatansky</td>
                                            </tr>
                                            <tr>
                                                <td class="text-center">Charlize Theron</td>
                                                <td class="text-center">Imperator Furiosa</td>
                                            </tr>
                                          <tr>
                                            <td class="text-center">Nicholas Hoult</td>
                                            <td class="text-center">Nux</td>
                                          </tr>
                                          <tr>
                                            <td class="text-center">Nicholas Hoult</td>
                                            <td class="text-center">Nux</td>
                                          </tr>
                                          <tr>
                                            <td class="text-center">Nicholas Hoult</td>
                                            <td class="text-center">Nux</td>
                                          </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>               
                    </div>
                </div>
                <div class="col">
                    <h3>Séances :</h3>
                    <hr>
                    <div class="row">
                        <div class="col-2">
                            <h4>Lundi :</h4>                            
                        </div>
                        <div class="col">
                            <table class="table table-hover table-bordered">
                                <thead class="thead-dark">
                                    <tr>
                                        <th scope="col" class="text-center">Salle</th>
                                        <th scope="col" class="text-center">Heure</th>
                                        <th scope="col" class="text-center">Places restantes</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="text-center">Salle 2</td>
                                        <td class="text-center">16:30</td>
                                        <td class="text-center">54</td>
                                    </tr>
                                    <tr>
                                        <td class="text-center">Salle 2</td>
                                        <td class="text-center">19:30</td>
                                        <td class="text-center">87</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-2">
                            <h4>Mardi :</h4>                            
                        </div>
                        <div class="col">
                            <table class="table table-hover table-bordered">
                                <thead class="thead-dark">
                                    <tr>
                                        <th scope="col" class="text-center">Salle</th>
                                        <th scope="col" class="text-center">Heure</th>
                                        <th scope="col" class="text-center">Places restantes</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="text-center">Salle 2</td>
                                        <td class="text-center">16:30</td>
                                        <td class="text-center">54</td>
                                    </tr>
                                    <tr>
                                        <td class="text-center">Salle 2</td>
                                        <td class="text-center">19:30</td>
                                        <td class="text-center">87</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js" integrity="sha384-vFJXuSJphROIrBnz7yo7oB41mKfc8JzQZiCq4NCceLEaO4IHwicKwpJf9c9IpFgh" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js" integrity="sha384-alpBpkh1PFOepccYVYDB4do5UnbKysX5WZXm3XxPqe5iKTfUKjNkCk9SaVuEZflJ" crossorigin="anonymous"></script>    
        <script type="text/javascript" src="${pageContext.request.contextPath}/js/FicheFilm.js"></script>
    </body>
</html>
