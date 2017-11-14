package Servlet;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import Bean.Bean_DB_MongoDB;
import com.mongodb.client.FindIterable;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.bson.Document;

/**
 *
 * @author Philippe
 */
@WebServlet(urlPatterns = {"/ControlerServlet"})
public class ControlerServlet extends HttpServlet {

    @Override
    public void init(ServletConfig config) throws ServletException
    {
        super.init(config);
        ServletContext sc = getServletContext();
        sc.log("-- démarrage de la servlet de controle");
        System.out.println("Démarrage de la servlet de controle");
    }
    
    @Override
    public void destroy() { }
    
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
        String Action = request.getParameter("action");
        
        switch (Action) 
        {
            case "Recherche":
                Rechercher(request, response, session);
                break;
            default:
                break;
        }
    }
    
    public void Rechercher(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException
    {
        Bean_DB_MongoDB BeanDB = new Bean_DB_MongoDB();
      
        if (request.getParameter("inputIdActeur").isEmpty())
        {
            session.setAttribute("Error", "Le champ est vide !");            
            response.sendRedirect(request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/FicheActeur/");
        }
        else
        {            
            Document doc = BeanDB.getActeur(Integer.parseInt(request.getParameter("inputIdActeur")));
            if (doc != null)
            {
                session.setAttribute("Nom", doc.getString("nom"));
                session.setAttribute("DateNaissance", doc.getString("DateAnnif"));
                if (!doc.getString("DateDeces").isEmpty())
                {
                    session.setAttribute("DateDeces", doc.getString("DateDeces"));
                
                }
                
                session.setAttribute("LieuNaissance", doc.getString("LieuNaiss"));                
                session.setAttribute("Image", doc.get("Image")); 
                response.sendRedirect(request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/FicheActeur/JSPFicheActeur.jsp");
            }
            else
            {                
                session.setAttribute("Error", "L'acteur n'a pas été trouvé !");            
                response.sendRedirect(request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/FicheActeur/");
            }
            
            FindIterable<Document> docs = BeanDB.FilmographieActeur(Integer.parseInt(request.getParameter("inputIdActeur")));
            ArrayList<HashMap<String, Object>> Filmographie = new ArrayList<>();
            for(Document document : docs)
            {
                HashMap<String, Object> Film = new HashMap<>();
                Film.put("title", document.get("title"));
                Film.put("original_title", document.get("original_title"));
                Film.put("poster_path", document.get("poster_path"));
                //System.out.println("Poster = " + document.get("poster_path"));
                Film.put("release_date", document.get("release_date"));
                Film.put("character", document.get("actors", ArrayList.class).get(0).toString().split("character=")[1].split(",", 0)[0]);
                //System.out.println("Film = " + document.get("actors", ArrayList.class).get(0).toString().split("character=")[1].split(",", 0)[0]);
                System.out.println("Film = " + Film);
                Filmographie.add(Film);
            }
            
            //System.out.println("Test1 = " + "http://image.tmdb.org/t/p/w185" + Filmographie.get(10).get("poster_path").toString());
            session.removeAttribute("Filmographie");
            session.setAttribute("Filmographie", Filmographie);
        }        
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
