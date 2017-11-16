<%-- 
    Document   : JSPFicheActeur
    Created on : 07-nov.-2017, 8:48:20
    Author     : Philippe
--%>

<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.Locale"%>
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
        <link rel="icon" href="../../favicon.ico">
        <title>RQS - Fiche acteur</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css" integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb" crossorigin="anonymous">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"> 
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
            <div class="collapse navbar-collapse" id="navbarCollapse">
                <a class="navbar-brand" href="#"><i class="fa fa-cinema"></i><strong> Rennequinepolis</strong></a>
            </div>
        </nav>
<<<<<<< HEAD
        <br><br><br><br>
        <div class="container" id="main">
            <aside style="float:left;">
                <img class="rounded float-left" alt="No free image man (en)" src=<% out.println(session.getAttribute("Image") != null ? ("http://image.tmdb.org/t/p/w185" + session.getAttribute("Image")) : "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/No_free_image_man_%28en%29.svg/256px-No_free_image_man_%28en%29.svg.png"); %>/>
                <h5>Photo de <% out.println(session.getAttribute("Nom")); %></h5>
            </aside>

            <section>
                <br><br><br><br>
                <article>
                    <h4><% out.println(session.getAttribute("Nom")); %></h4>
                    <h4><% SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd"); out.println("Né le " + DateFormat.getDateInstance(DateFormat.MEDIUM, Locale.FRANCE).format(formatter.parse(session.getAttribute("DateNaissance").toString())) + " à " + session.getAttribute("LieuNaissance")); %></h4>    
                    <%  if(session.getAttribute("DateDeces") != null)
=======
        <div class="container-fluid" id="main"> 
                       
            <div class="row">
                <div class="col-md-10 mx-auto">
                    <div>
                        <h1 class="display-3"><% out.println(session.getAttribute("Nom")); %></h1>
                    </div>
                    
                    <div class="jumbotron jumbotron-fluid">
                        <div class="container">
                            
                            <img class="rounded float-left" alt="No free image man (en)" src=<% out.println(session.getAttribute("Image") != null ? ("http://image.tmdb.org/t/p/w185" + session.getAttribute("Image")) : "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/No_free_image_man_%28en%29.svg/256px-No_free_image_man_%28en%29.svg.png"); %>/>
                            
                            <h2 class="text-center">Date de naissance :</h2>
                            <p class="lead text-center">
                                <% SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd"); out.println(DateFormat.getDateInstance(DateFormat.MEDIUM, Locale.FRANCE).format(formatter.parse(session.getAttribute("DateNaissance").toString()))); %>
                            </p>
                            <h2 class="text-center">Lieu de naissance :</h2>
                            <p class="lead text-center"><% out.println(session.getAttribute("LieuNaissance")); %></p>
                          
                            <h2 class="text-center">Date de décès :</h2>
                            <p class="lead text-center">14 novembre 2017</p>
                        <%  if(session.getAttribute("DateDeces") != null)
                            {
                        %>
                                <h2 class="text-center">Date de décès :</h2>
                                <p class="lead"><% out.println(session.getAttribute("DateDeces")); %></p>                          
                        <%  }   %>
                        <br>
                        </div>
                    </div>
                </div>
            </div>
                
            <div class="row">
                <div class="col-md-10 mx-auto">
                    <h2>Biographie :</h2>
                   
                </div>
            </div>
                
            <div class="row">
                <div class="col-md-10 mx-auto">
                    <br>
                    <h2>Filmographie :</h2>
                    <% 
                        ArrayList<HashMap<String, Object>> Filmographie = (ArrayList<HashMap<String, Object>>) session.getAttribute("Filmographie");   
                    %>
                               
                    <%
                        if(Filmographie.size() > 0) 
>>>>>>> 5c8d724dca222c71df63878aebd79936dd95581e
                        {
                            int i = 0;
                            for(int j = 1 ; i < Filmographie.size() ; j++)
                            {%>
                                <div class="card-group">
                            <%  for(i = (6 * (j-1)) ; i < (6*j); i++)
                                {                          
                                    //System.out.println("i = " + i);
                                    //System.out.println("5*j = " + 6*j);
                        //System.out.println("Film = " + Filmographie.get(i));
                    %>                    
                                    <div class="card">
                                        <% if (i < Filmographie.size()) { %>
                                        <img class="card-img-top" src=<% out.println(Filmographie.get(i).get("poster_path") != null ? ("http://image.tmdb.org/t/p/w185" + Filmographie.get(i).get("poster_path").toString()) : "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/No_free_image_man_%28en%29.svg/256px-No_free_image_man_%28en%29.svg.png"); %> alt=<% out.println(Filmographie.get(i).get("title").toString()); %>>
                                        <div class="card-body">
                                            <h4 class="card-title"><% out.println(Filmographie.get(i).get("title").toString() + "(" + (!Filmographie.get(i).get("release_date").equals("") ? Filmographie.get(i).get("release_date").toString().substring(0, 4) : "?") + ")"); %></h4>
                                        <p class="card-text"><small class="text-muted"><% out.println("Titre original : " + Filmographie.get(i).get("original_title").toString()); %></small></p>
                                        <p class="card-text"><% out.println(!Filmographie.get(i).get("character").equals("") ? "Rôle : " + Filmographie.get(i).get("character").toString() : "Rôle : ?"); %></p>
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
