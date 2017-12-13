<%-- 
    Document   : ModalConnexion
    Created on : 02-déc.-2017, 18:13:48
    Author     : Philippe
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div class="modal fade" id="ModalConnexion" tabindex="-1" role="dialog" aria-labelledby="ModalConnexion" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">                
                <h4 class="modal-title" id="exampleModalLabel"><i class="fa fa-sign-in"></i> Connexion</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form class="form-signin" id="loginform" action="Servlet" method="POST">
                <%  if(session.getAttribute("ErrorLogin") != null)
                    { %>
                        <div class="alert alert-danger" role="alert"> <%= session.getAttribute("ErrorLogin") %></div>                         
                    <% 
                        session.setAttribute("ErrorLogin", null);
                    }   %>
                    <div class="form-group">
                        <label for="username"><i class="fa fa-user"></i> Nom d'utilisateur</label>
                        <input type="text" name="inputLogin" id="inputLogin" class="form-control" placeholder="Entrer le nom d'utilisateur" autofocus>
                    </div>
                    <div class="form-group">
                        <label for="password"><i class="fa fa-key"></i> Mot de passe</label>
                        <input type="password" name="inputPassword" id="inputPassword" class="form-control" placeholder="Entrer le mot de passe">  
                    </div>
                    <div class="form-check checkbox">
                        <label><input id="inputCB" type="checkbox" name="Inscription" onclick="InscriptionAddInfos(this);"> Je suis un nouveau client</label>
                    </div>
                    <input id="inputHidden" type="hidden" name="action" value="Authentification">
                </form>
            </div>
            <div class="modal-footer">                
                <button class="btn btn-lg btn-success btn-block" type="submit" id="submit"><i class="fa fa-power-off"></i> Connexion</button>
            </div>
        </div>
    </div>
</div>