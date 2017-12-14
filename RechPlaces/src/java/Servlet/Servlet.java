/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlet;

import Beans.Films;
import Classes.DBAccess;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Philippe
 */
public class Servlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
        HttpSession session = request.getSession(true);  
        DBAccess DBAccess = new DBAccess();
                
        System.out.println("[RechPlaces]session = " + request.getParameter("action"));
        
        switch(request.getParameter("action"))
        {
            case "Authentification":
                break;
            case "Recherche": 
                String Popularite = request.getParameter("PopInput");
                if(Popularite != null)
                {
                    if (Popularite.isEmpty())
                    {
                        session.setAttribute("ErrorPop", "Aucune valeur pour la popularité");
                        session.setAttribute("Error", true);
                    }
                    else if (!isDigit(Popularite))
                    {
                        session.setAttribute("ErrorPop", "La valeur pour la popularité n'est pas numérique");
                        session.setAttribute("Error", true);
                    }                            
                }

                String Perennite = request.getParameter("PerInput");
                if(Perennite != null)
                {
                    if (Perennite.isEmpty())
                    {
                        session.setAttribute("ErrorPer", "Aucune valeur pour la perennité");
                        session.setAttribute("Error", true);
                    }
                    else if (!isDigit(Perennite))
                    {
                        session.setAttribute("ErrorPer", "La valeur pour la perennité n'est pas numérique");
                        session.setAttribute("Error", true);
                    }                            
                }

                String Acteurs = request.getParameter("acteursInput");
                if(Acteurs != null)
                {
                    if (!isAlpha(Acteurs))
                    {
                        session.setAttribute("ErrorAct", "Le champ des acteurs contient une ou des valeur(s) numérique(s)");
                        session.setAttribute("Error", true);
                    }                            
                }

                String Realisateurs = request.getParameter("realisateursInput");
                if(Realisateurs != null)
                {
                    if (!isAlpha(Realisateurs))
                    {
                        session.setAttribute("ErrorRea", "Le champ des réalisateurs contient une ou des valeur(s) numérique(s)");
                        session.setAttribute("Error", true);
                    }                            
                }

                String Genres = request.getParameter("genresInput");
                if(Genres != null)
                {
                    if (!isAlpha(Genres))
                    {
                        session.setAttribute("ErrorGen", "Le champ des genres contient une ou des valeur(s) numérique(s)");
                        session.setAttribute("Error", true);
                    }                            
                }
                

                try 
                {
                    String urlParameters;
                    
                    urlParameters = "complexe=";
                    urlParameters += request.getParameter("complexe");
                    urlParameters += "&acteursInput=";
                    urlParameters += request.getParameter("acteursInput").replaceAll(" ", "%20");
                    urlParameters += "&realisateursInput=";
                    urlParameters += request.getParameter("realisateursInput").replaceAll(" ", "%20");;
                    urlParameters += "&genresInput=";
                    urlParameters += request.getParameter("genresInput").replaceAll(" ", "%20");
                    urlParameters += "&titreInput=";
                    urlParameters += request.getParameter("titreInput").replaceAll(" ", "%20");
                    
                    if(!request.getParameter("popularite").equals("Default"))
                    {
                        urlParameters += "&popInput=";
                        urlParameters += request.getParameter("popInput");
                    }
                    
                    if(!request.getParameter("perennite").equals("Default"))
                    {
                        urlParameters += "&perInput=";
                        urlParameters += request.getParameter("perInput");
                    }
                    
                    System.out.println("urlParameters = " + urlParameters);
                    DBAccess.SendPOSTRequest("http://127.0.0.1:9080/ords/rqs/cb.package_RechPlaces.RecupererFilms", urlParameters);
                    System.out.println("Reponse = " + DBAccess.ReceiveResponse());
                } 
                catch (Exception e) 
                {
                    e.printStackTrace();
                }
                                        
                //response.sendRedirect(request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/RechPlaces/RechPlaces.jsp");
                break;            
            case "FicheFilm":
                RecupererFilm(Integer.parseInt(request.getParameter("IdFilm")), session);
                response.sendRedirect(request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/RechPlaces/FicheFilm.jsp");
                break;            
            case "FicheActeur":
                RecupererActeur(Integer.parseInt(request.getParameter("IdActeur")));
                response.sendRedirect(request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/RechPlaces/FicheActeur.jsp");
                break;
            case "AfficherSeancesFilm":
                RecupererSeancesFilm(Integer.parseInt(request.getParameter("IdFilm")));
                response.sendRedirect(request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/RechPlaces/AfficheSeancesFilm.jsp");
                break;
               
            default: break;
        }
    }
    
    public void RecupererFilm(int idFilm, HttpSession session) 
    {
        Films Films = (Films) getServletContext().getAttribute("Films");
        //Film Film = Films.getFilm(idFilm);
        //session.setAttribute("Film", Film);
    }

    public void RecupererActeur(int IdActeur)
    {
        
    }
    
    public void RecupererSeancesFilm(int IdFilm)
    {
        
    }    
    
    public boolean isAlpha(String string)
    {
        char[] chars = string.toCharArray();
        
        for (char c : chars) 
        {
            if(!Character.isLetter(c)) 
            {
                return false;
            }
        }

        return true;
    }    
    public boolean isDigit(String string)
    {
        char[] chars = string.toCharArray();
        
        for (char c : chars) 
        {
            if(!Character.isDigit(c)) 
            {
                return false;
            }
        }

        return true;
    }
    public boolean isAlphaOrDigit(String string)
    {
        char[] chars = string.toCharArray();
        
        for (char c : chars) 
        {
            if(!Character.isLetterOrDigit(c)) 
            {
                return false;
            }
        }

        return true;
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
