<%-- 
    Document   : ModalSeanceFilm
    Created on : 02-déc.-2017, 16:38:32
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
                
                <button type="button" class="btn btn-info mr-1">
                    <a id="redirection" href="FicheFilm.jsp">
                        <i class="fa fa-chevron-left" aria-hidden="true"></i> 
                        Retourner sur la fiche du film
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
            
            <h1>Seances pour "Mad Max Fury Road" sur le complexe CC1 :</h1>
            <hr>
            <!-- <form class="form-inline">
                <div class="card mx-auto">
                    <div class="card-body">                        
                        <div class="row">
                            <div class="col">
                                <label for="complexeInput">Complexe</label>
                                <select name="complexeInput" id="complexeInput" type="text" class="form-control">
                                    <option value="CC1">CC1</option>
                                    <option value="CC2">CC2</option>
                                    <option value="CC3">CC3</option>
                                    <option value="CC4">CC4</option>
                                    <option value="CC5">CC5</option>
                                    <option value="CC6">CC6</option>
                                </select>
                            </div>
                            
                            <div class="col">
                                <label for="dayInput">Jour</label>
                                <select name="dayInput" id="complexeInput" type="text" class="form-control">
                                    <option value="Lundi">Lundi</option>
                                    <option value="Mardi">Mardi</option>
                                    <option value="Mercredi">Mercredi</option>
                                    <option value="Jeudi">Jeudi</option>
                                    <option value="Vendredi">Vendredi</option>
                                    <option value="Samedi">Samedi</option>
                                    <option value="Dimanche">Dimanche</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
            </form> -->
            
            
        </div>
    </body>
</html>
