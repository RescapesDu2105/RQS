<%-- 
    Document   : JSPFicheActeur
    Created on : 07-nov.-2017, 8:48:20
    Author     : Philippe
--%>

<%@page import="Classes.Tailles_Posters"%>
<%@page import="Classes.JouerFilm"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.Locale"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="Acteur" scope="session" class="Beans.Acteur" />
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
        <meta name="description" content="">
        <meta name="author" content="">
        <link rel="icon" href="../../favicon.ico">
        <title>RQS - Fiche acteur</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css" integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb" crossorigin="anonymous">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">     
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/FicheActeur.css">
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark justify-content-between">
            <a class="navbar-brand" href="RechPlaces.jsp"><i class="fa fa-cinema"></i><strong> Rennequinepolis</strong></a>
            <form class="form-inline">
                <button type="button" class="btn btn-info mr-1">
                    <a id="redirection" href="RechPlaces.jsp">
                        <i class="fa fa-chevron-left" aria-hidden="true"></i> 
                        Retourner sur la page principale
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
        <div class="container-fluid" id="main"> 
                       
            <div class="row">
                <div class="col-md-10 mx-auto">
                    <div>
                        <h1 class="display-3"><%= Acteur.getNom() %></h1>
                    </div>
                    
                    <div class="jumbotron jumbotron-fluid">
                        <div class="container">
                            
                            <img class="rounded float-left" alt="Image de <%= Acteur.getNom() %>" src="<%= Acteur.getURLImageProfil() %>"/>
                            
                            <h2 class="text-center">Date de naissance :</h2>
                            <p class="lead text-center">
                                <% SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd"); out.println(DateFormat.getDateInstance(DateFormat.MEDIUM, Locale.FRANCE).format(formatter.parse(Acteur.getDateNaissance()))); %>
                            </p>
                            <h2 class="text-center">Lieu de naissance :</h2>
                            <p class="lead text-center"><%= Acteur.getLieuNaissance() %></p>
                          
                        <%  if(Acteur.getDateDeces() != null)
                            {
                        %>
                                <h2 class="text-center">Date de décès :</h2>
                                <p class="lead"><% formatter.format(formatter.parse(Acteur.getDateDeces())); %></p>                          
                        <%  }  
                            else
                            { %>
                                <br>
                        <%  } %>
                        <br>
                        </div>
                    </div>
                </div>
            </div>
                
            <div class="row">
                <div class="col-md-10 mx-auto">
                    <br>
                    <h2>Filmographie :</h2>                               
                    <%
                        System.out.println("size = " + Acteur.getFilmographie().size());
                        if(Acteur.getFilmographie().size() > 0) 
                        {
                            int i = 0;
                            for(int j = 1 ; i < Acteur.getFilmographie().size() ; j++)
                            {%>
                                <div class="card-group">
                            <%  for(i = (6 * (j-1)) ; i < (6*j); i++)
                                {                          
                    %>                    
                                    <div class="card">
                                        <%  if (i < Acteur.getFilmographie().size()) 
                                            { 
                                                JouerFilm jouerFilm = Acteur.getFilmographie().get(i);
                                        %>
                                        <img class="card-img-top" src="<%= jouerFilm.getPosterPath(Tailles_Posters.POSTER_SIZE_W185) != null ? jouerFilm.getPosterPath(Tailles_Posters.POSTER_SIZE_W185) : "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/No_free_image_man_%28en%29.svg/256px-No_free_image_man_%28en%29.svg.png" %>" alt="Image du film <%= jouerFilm.getTitle() %>">
                                        <div class="card-body">
                                            <h4 class="card-title"><%= jouerFilm.getTitle() + "(" + (jouerFilm.getReleaseDate() != null ? jouerFilm.getReleaseDate().substring(0, 4) : "?") + ")" %></h4>
                                        <% if(jouerFilm.getOriginalTitle() != null) { %> <p class="card-text"><small class="text-muted"><%= "Titre original : " + jouerFilm.getOriginalTitle() %></small></p> <% } %>
                                        <p class="card-text"><%= jouerFilm.getCharacter() != null ? "Rôle : " + jouerFilm.getCharacter() : "Rôle : ?" %></p>
                                        </div>
                                        <% } %>
                                    </div>                                    
                        <%      }  %>
                                </div>
                        <%  }
                        }  %>
                </div>
            </div>>
        </div>
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js" integrity="sha384-vFJXuSJphROIrBnz7yo7oB41mKfc8JzQZiCq4NCceLEaO4IHwicKwpJf9c9IpFgh" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js" integrity="sha384-alpBpkh1PFOepccYVYDB4do5UnbKysX5WZXm3XxPqe5iKTfUKjNkCk9SaVuEZflJ" crossorigin="anonymous"></script>
    </body>
</html>
