/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlet;

import Bean.Bean_DB_MongoDB;
import Beans.Acteur;
import Beans.Film;
import Beans.Films;
import Beans.Realisateur;
import Classes.DBAccess;
import Classes.Genre;
import Classes.JouerFilm;
import Classes.Tailles_Posters;
import com.mongodb.client.FindIterable;
import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonObject;
import javax.json.JsonReader;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.bson.Document;

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
                        urlParameters += "&popularite=";
                        urlParameters += request.getParameter("popularite");
                        
                        urlParameters += "&popInput=";
                        urlParameters += request.getParameter("popInput");
                    }
                    
                    if(!request.getParameter("perennite").equals("Default"))
                    {
                        urlParameters += "&perennite=";
                        urlParameters += request.getParameter("perennite");
                        
                        urlParameters += "&perInput=";
                        urlParameters += request.getParameter("perInput");
                    }
                    
                    System.out.println("urlParameters = " + urlParameters);
                    DBAccess.SendPOSTRequest("http://127.0.0.1:9080/ords/rqs/cb.package_RechPlaces.RecupererFilms", urlParameters);
                    String json = DBAccess.ReceiveResponse();                    
                    StringReader stringParser = new StringReader(json);
                    JsonReader reader = Json.createReader(stringParser);// Création d'un reader
                    JsonObject JsonObject = reader.readObject();// Création d'un objet
                    JsonObject ObjectFilm;
                    int length = JsonObject.getJsonArray("films").size();
                    
                    Films films = new Films();
                    for(int i = 0 ; i < length ; i++)
                    {
                        ObjectFilm = JsonObject.getJsonArray("films").getJsonObject(i);
                        //System.out.println("VoteAverage = " + Float.valueOf(ObjectFilm.getString("VOTE_AVERAGE").replaceAll(",", ".")));
                        Film film = new Film(ObjectFilm.getInt("IDFILM"), ObjectFilm.getString("PATHIMAGE"), ObjectFilm.getString("TITRE"), ObjectFilm.getString("TITRE_ORIGINAL"), 
                                ObjectFilm.getInt("COMPLEXEPOPULARITE"), ObjectFilm.getInt("COMPLEXEPERENITE"), ObjectFilm.getString("NOMCERTI"), 
                                Float.valueOf(ObjectFilm.getString("VOTE_AVERAGE").replaceAll(",", ".")), ObjectFilm.getInt("VOTE_COUNT"), ObjectFilm.getInt("DUREE"), ObjectFilm.getInt("BUDGET"), 
                                ObjectFilm.getString("DATE_REAL"));
                        JsonArray acteurs = ObjectFilm.getJsonArray("ARTISTS");
                        JsonArray genres = ObjectFilm.getJsonArray("GENRES");
                        JsonArray realisateurs = ObjectFilm.getJsonArray("REALISATEURS");
                        
                        for(int j = 0 ; j < acteurs.size() ; j++)
                        {
                            film.getActeurs().add(new Acteur(acteurs.getJsonObject(j).getInt("IDART"), acteurs.getJsonObject(j).getString("NOMART"), acteurs.getJsonObject(j).getString("ROLE")));
                        }
                        
                        for(int j = 0 ; j < genres.size() ; j++)
                        {
                            film.getGenres().add(new Genre(genres.getJsonObject(j).getString("NOMGENRE")));
                        }
                        
                        for(int j = 0 ; j < realisateurs.size() ; j++)
                        {
                            film.getRealisateurs().add(new Realisateur(realisateurs.getJsonObject(j).getString("NOMART")));
                        }
                        
                        films.getFilms().add(film);
                    }
                    
                    session.setAttribute("Films", films);                    
                } 
                catch (Exception e) 
                {
                    e.printStackTrace();
                }
                                        
                response.sendRedirect(request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/RechPlaces/RechPlaces.jsp");
                break;            
            case "FicheFilm":
                RecupererFilm(Integer.parseInt(request.getParameter("IdFilm")), session);
                response.sendRedirect(request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + "/RechPlaces/FicheFilm.jsp");
                break;            
            case "FicheActeur":
                RecupererActeur(Integer.parseInt(request.getParameter("IdActeur")), session);
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
        Films films = (Films) session.getAttribute("Films");
        Film film = films.getFilm(idFilm);
        session.setAttribute("Film", film);
    }

    public void RecupererActeur(int IdActeur, HttpSession session) 
    {
        Bean_DB_MongoDB BeanDB = new Bean_DB_MongoDB();
        Acteur acteur = ((Film) session.getAttribute("Film")).getActeur(IdActeur);
        Document doc = BeanDB.getActeur(acteur.getId());
        //System.out.println("doc = " + doc);
        
        if (doc != null)
        {            
            acteur.setDateNaissance(doc.getString("birthday"));
            acteur.setLieuNaissance(doc.getString("place_of_birth"));
            acteur.setDateDeces(doc.getString("deathday") != null ? doc.getString("deathday") : null);
            acteur.setImageProfil(doc.getString("poster_path"));
        }
        else
        {                
            session.setAttribute("Error", "L'acteur n'a pas été trouvé !");           
            
        }

        //System.out.println("id = " + acteur.getId());
        ArrayList<Document> films = (ArrayList<Document>) doc.get("films");
        //System.out.println("films = " + films);       
        for(Document document : films)
        {
            JouerFilm film = new JouerFilm(document.get("titre").toString(), document.containsKey("original_title") ? document.get("original_title").toString() : null, document.containsKey("poster_path") ? document.get("poster_path").toString() : null, /*document.getString("release_date"),*/ document.containsKey("character") ? document.get("character").toString() : null);
            //System.out.println("o = " + film.getOriginalTitle());
            //System.out.println("c = " + film.getCharacter());
            acteur.getFilmographie().add(film);
        }

        session.setAttribute("Acteur", acteur);
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
