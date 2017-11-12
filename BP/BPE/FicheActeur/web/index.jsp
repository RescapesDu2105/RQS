<%-- 
    Document   : JSPFicheActeur
    Created on : 07-nov.-2017, 7:27:45
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
        <link rel="icon" href="../../favicon.ico">
        <title>RQS - Recherche</title>
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
            <%  if(session.getAttribute("Error") != null)
                { 
                    out.println("<div class=\"col-md-6 mx-auto\">");
                    out.println("<div class=\"alert alert-danger\" role=\"alert\">"+ session.getAttribute("Error") +"</div>"); 
                    out.println("</div>");
                    session.setAttribute("Error", null);
                } %>
                          
            <div class="col-md-7 mx-auto">
                <form class="form-inline" id="searchForm" action="ControlerServlet" method="POST">

                    <div class="form-group">
                        <label for="idActeur"><i class="fa fa-user"></i> Recherche d'un acteur</label>
                    </div>
                    <div class="form-group mx-md-3">
                        <input type="text" name="inputIdActeur" id="inputIdActeur" class="form-control" placeholder="Entrer le numéro" autofocus>
                    </div>                        
                    <input id="inputHidden" type="hidden" name="action" value="Recherche">
                    <button class="btn btn-lg btn-success" type="submit" id="submit"><i class="fa fa-search"></i> Rechercher</button>    
                </form>
            </div>
        </div> <!-- /container -->
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js" integrity="sha384-vFJXuSJphROIrBnz7yo7oB41mKfc8JzQZiCq4NCceLEaO4IHwicKwpJf9c9IpFgh" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js" integrity="sha384-alpBpkh1PFOepccYVYDB4do5UnbKysX5WZXm3XxPqe5iKTfUKjNkCk9SaVuEZflJ" crossorigin="anonymous"></script>
    </body>
</html>
