<%-- 
    Document   : JSPFicheActeur
    Created on : 07-nov.-2017, 8:48:20
    Author     : Philippe
--%>

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
        <br><br><br><br>
        <div class="container" id="main">
<!--            <div class="col-12">
                <div class="col-8">
                    On affiche la photo
                    <
                </div>
                <div class="col-4">
                    On affiche les infos personnelles de l'acteur
                </div>
            </div>
            <div class="col-12">
                On affiche sa filmographie
            </div>-->
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
                        {
                            out.println("<h4>Mort(e) le " + session.getAttribute("DateDeces") + "</h4>");                          
                        }   %>
                </article>
                <br><br><br><br><br><br><br>
                <article>
                    <h4>Filmographie :</h4>
                    
                </article>
            </section>
        </div>
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js" integrity="sha384-vFJXuSJphROIrBnz7yo7oB41mKfc8JzQZiCq4NCceLEaO4IHwicKwpJf9c9IpFgh" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js" integrity="sha384-alpBpkh1PFOepccYVYDB4do5UnbKysX5WZXm3XxPqe5iKTfUKjNkCk9SaVuEZflJ" crossorigin="anonymous"></script>
    </body>
</html>
