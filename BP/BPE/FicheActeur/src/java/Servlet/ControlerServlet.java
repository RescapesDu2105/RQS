package Servlet;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import Bean.Bean_DB_MongoDB;
import Beans.Acteur;
import Beans.Film;
import Beans.Films;
import com.mongodb.client.FindIterable;
import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
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
    
    public void Rechercher(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException, ServletException
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
                String[] CompleteName = doc.getString("nom").split(" ");
                Acteur Acteur = new Acteur(CompleteName[0], CompleteName[1], doc.getString("DateAnnif"), doc.getString("LieuNaiss"), !doc.getString("DateDeces").isEmpty() ? doc.getString("DateDeces") : null, doc.getString("Image"));
                
                /*session.setAttribute("Nom", doc.getString("nom"));
                session.setAttribute("DateNaissance", doc.getString("DateAnnif"));
                if (!doc.getString("DateDeces").isEmpty())
                {
                    session.setAttribute("DateDeces", doc.getString("DateDeces"));
                
                }
                
                session.setAttribute("LieuNaissance", doc.getString("LieuNaiss"));                
                session.setAttribute("Image", doc.get("Image")); */
                session.removeAttribute("Acteur");
                session.setAttribute("Acteur", Acteur);
                RequestDispatcher rd = getServletContext().getRequestDispatcher("/JSPFicheActeur.jsp");
                rd.forward(request, response);
                //response.sendRedirect(request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/FicheActeur/JSPFicheActeur.jsp");
            }
            else
            {                
                session.setAttribute("Error", "L'acteur n'a pas été trouvé !");            
                response.sendRedirect(request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/FicheActeur/");
            }
            
            FindIterable<Document> docs = BeanDB.FilmographieActeur(Integer.parseInt(request.getParameter("inputIdActeur")));
            //Films Filmographie = new Films();
            ArrayList<Film> Filmographie = new ArrayList<>();
            for(Document document : docs)
            {
                String Title = document.get("title").toString();
                System.out.println("Title = " + Title);
                String Ori = document.get("original_title").toString();
                System.out.println("Ori = " + Ori);
                String Poster = document.get("poster_path") != null ? "http://image.tmdb.org/t/p/w185" + document.get("poster_path").toString() : "http://image.tmdb.org/t/p/w185" + "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/No_free_image_man_%28en%29.svg/256px-No_free_image_man_%28en%29.svg.png";
                System.out.println("Poster = " + Poster);
                String Date = document.getString("release_date");
                System.out.println("Date = " + Date);
                String Role = document.get("actors", ArrayList.class).get(0).toString().split("character=")[1].split(",", 0)[0];
                System.out.println("Role = " + Role);
                
                
                Film Film = new Film(Title, Ori, Poster, Date, Role);
                /*HashMap<String, Object> Film = new HashMap<>();
                Film.put("title", document.get("title"));
                Film.put("original_title", document.get("original_title"));
                Film.put("poster_path", document.get("poster_path"));
                Film.put("release_date", document.get("release_date"));
                Film.put("character", document.get("actors", ArrayList.class).get(0).toString().split("character=")[1].split(",", 0)[0]);*/
                //Filmographie.getFilmographie().add(Film);
                Filmographie.add(Film);
            }
            
            session.removeAttribute("Filmographie");
            session.setAttribute("Filmographie", Filmographie);
            
            RequestDispatcher rd = getServletContext().getRequestDispatcher("/JSPFicheActeur.jsp");
            rd.forward(request, response);
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
