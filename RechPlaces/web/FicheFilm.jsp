<%-- 
    Document   : FicheFilm
    Created on : 26-nov.-2017, 21:01:19
    Author     : Philippe
--%>

<%@page import="Beans.Acteur"%>
<%@page import="Classes.Genre"%>
<%@page import="Classes.Tailles_Posters"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="Panier" scope="session" class="Beans.Panier"/>
<jsp:useBean id="Film" scope="session" class="Beans.Film"/>
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
                    <h1 class="display-4 text-left font-weight-bold"><%= Film.getTitle() %></h1>
                    <hr>
                </div>
            </div>
            
            <div class="row mt-2">
                <div class="col">
                    <figure class="figure">
                        <img class="rounded float-left" alt="Image <%= Film.getTitle() %>" src="<%= Film.getPosterPath(Tailles_Posters.POSTER_SIZE_W185) %>"/>
                        <!-- <figcaption class="figure-caption text-center">Date de sortie : 14 mai 2015</figcaption> -->
                    </figure>
                </div>
                <div class="col-10">
                    <p><b>Réalisateur : </b> 
                        <% 
                            String realisateurs = "";
                            for(int i = 0 ; i < Film.getRealisateurs().size() ; i++) 
                            { 
                                realisateurs += (Film.getRealisateurs().get(i).getNom() + ", "); 
                            } 
                            realisateurs = realisateurs.substring(0, realisateurs.length() - 2);
                            out.println(realisateurs);
                        %>
                    </p>   
                    <p><b>Genre :</b> 
                        <% 
                            String genres = "";
                            for(int i = 0 ; i < Film.getGenres().size() ; i++) 
                            { 
                                genres += (Film.getGenres().get(i).getNom() + ", "); 
                            } 
                            genres = genres.substring(0, genres.length() - 2);
                            out.println(genres);
                        %>
                    </p>
                    <p><b>Popularité : </b><%= Film.getPopularite() %> places vendues environ</p>                    
                    <p><b>Nombre de semaines au Box-office : </b><%= Film.getPerennite() %></p>                    
                    <p><b>Public cible : </b><%= Film.getCertification() %></p>
                    <p><b>Date de réalisation : </b><%= Film.getDateReal() %></p>
                    <p><b>Durée : </b><%= Film.getDuree() %> minutes</p>
                    <p><b>Budget : </b><%= Film.getBudget() %> $</p>
                    <p><b>Moyenne des votes : </b><%= Film.getVoteAverage() %> avec <%= Film.getVoteCount() %> votes</p>
                </div>
            </div>
            
            <div class="row">    
                <div class="col">                                     
                    <p><b>Acteurs :</b></p>
                    <table class="table table-sm table-hover table-bordered">
                        <thead class="thead-dark">
                          <tr>
                            <th scope="col" class="text-center">Nom</th>
                            <th scope="col" class="text-center">Rôle</th>
                          </tr>
                        </thead>
                        <tbody>
                            <%
                                for(int i = 0 ; i < Film.getActeurs().size() ; i++)
                                { 
                                    Acteur acteur = Film.getActeurs().get(i);
                                %>
                                <tr>
                                    <td class="text-center"><a href="Servlet?action=FicheActeur&IdActeur=<%= acteur.getId() %>"><%= acteur.getNom() %></a></td>
                                    <td class="text-center"><%= acteur.getRole() %></td>
                                </tr>
                            <%  } %>
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
