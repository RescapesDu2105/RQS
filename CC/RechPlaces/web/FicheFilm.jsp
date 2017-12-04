<%-- 
    Document   : FicheFilm
    Created on : 26-nov.-2017, 21:01:19
    Author     : Philippe
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="Panier" scope="session" class="Beans.Panier"/>
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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/RechPlaces.css">
    </head>
    <body>
        <nav class="navbar sticky-top navbar-dark bg-dark justify-content-between">
            <a class="navbar-brand" href="RechPlaces.jsp"><i class="fa fa-film"></i><strong> Rennequinepolis</strong></a>
            <form class="form-inline">
                <button type="button" class="btn btn-info mr-1">
                    <a id="redirection" href="RechPlaces.jsp">
                        <i class="fa fa-chevron-left" aria-hidden="true"></i> 
                        Retourner sur la page principale
                    </a>
                </button>        
                <% //if(Film) %>
                <button type="button" class="btn btn-danger mr-1">
                    <a id="redirection" href="Servlet?action=AfficherSeancesFilm&IdFilm=1001">
                        <i class="fa fa-ticket" aria-hidden="true"></i>
                        Afficher les séances pour ce film 
                    </a>
                </button>
                
                <%  if(session.getAttribute("isConnected") != null) { %>
                    <button type="button" class ="btn btn-success ml-1"> 
                        <a id="redirection" href="Servlet?action=AfficherPanier">0
                            <i class="fa fa-shopping-cart" aria-hidden="true"></i>
                            Panier
                        </a>
                    </button>
                <% } else { %>
                    <button type="button" class ="btn btn-success ml-1" data-toggle="modal" data-target="#ModalConnexion"> 
                        <i class="fa fa-power-off" aria-hidden="true"></i>
                        Se connecter pour voir le panier
                    </button>
                <% } %>
            </form>
        </nav>    
        <div class="container-fluid col-md-10 mt-3"> 
            
            <div class="row">
                <div class="col">
                    <h1 class="display-4 text-left font-weight-bold">Mad Max Fury Road</h1>
                    <hr>
                </div>
            </div>
            
            <div class="row mt-2">
                <div class="col">
                    <figure class="figure">
                        <img class="rounded float-left" alt="No free image man (en)" src="https://image.tmdb.org/t/p/w185/kqjL17yufvn9OVLyXYpvtyrFfak.jpg"/>
                        <figcaption class="figure-caption text-center">Date de sortie : 14 mai 2015</figcaption>
                    </figure>
                </div>
                <div class="col-10">
                    <h3>Résumé :</h3>
                    <p class="lead">Ancien policier de la route, Max Rockatansky (Tom Hardy) erre désormais seul au volant de son bolide (une Ford Falcon XB 351) dans un monde dévasté où les clans de cannibales, les sectes et les gangs de motards s'affrontent dans des déserts sans fin pour l'essence et l'eau. L'un de ces clans est aux ordres de « Immortan Joe » (Hugh Keays-Byrne), un ancien militaire devenu leader tyrannique2. L'une de ses plus fidèles partisanes, l'« imperator » Furiosa (Charlize Theron), le trahit et s'enfuit avec un bien d'une importance capitale pour le chef de guerre : ses « épouses », un groupe de jeunes femmes lui servant d'esclaves et de « pondeuses ».</p>
                </div>
            </div>
            
            <div class="row">    
                <div class="col">
                    <p><b>Popularité :</b> 120.000 places vendues environ</p>                    
                    <p><b>Nombre de semaines au Box-office :</b> 10</p>
                    <p><b>Genre :</b> science-fiction dystopique, road movie</p>
                    <p><b>Public cible :</b> Les adolescents rebelles</p>
                    <p><b>Réalisateur :</b> Georges Miller</p>                    
                    <p><b>Acteurs :</b></p>
                    <table class="table table-sm table-hover table-bordered">
                        <thead class="thead-dark">
                          <tr>
                            <th scope="col" class="text-center">Nom</th>
                            <th scope="col" class="text-center">Rôle</th>
                          </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="text-center"><a href="Servlet?action=FicheActeur&IdActeur=1001">Tom Hardy</a></td>
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
                
        <jsp:include page="ModalConnexion.jsp"></jsp:include>
                
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js" integrity="sha384-vFJXuSJphROIrBnz7yo7oB41mKfc8JzQZiCq4NCceLEaO4IHwicKwpJf9c9IpFgh" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js" integrity="sha384-alpBpkh1PFOepccYVYDB4do5UnbKysX5WZXm3XxPqe5iKTfUKjNkCk9SaVuEZflJ" crossorigin="anonymous"></script>    
        <script type="text/javascript" src="${pageContext.request.contextPath}/js/FicheFilm.js"></script>
    </body>
</html>
