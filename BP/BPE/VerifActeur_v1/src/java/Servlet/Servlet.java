/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlet;

import Bean.Bean_DB_MongoDB;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringReader;
import java.util.Collections;
import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonNumber;
import javax.json.JsonObject;
import javax.json.JsonReader;
import javax.json.JsonString;
import javax.json.JsonValue;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.bson.Document;

/**
 *
 * @author Philippe
 */
@WebServlet(name = "Servlet", urlPatterns = {""})
public class Servlet extends HttpServlet 
{

    @Override
    public void init(ServletConfig config) throws ServletException
    {
        super.init(config);
        ServletContext sc = getServletContext();
        sc.log("-- démarrage de la servlet");
        System.out.println("Démarrage de la servlet");
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
        StringBuilder jb = new StringBuilder();
        String line;
        try 
        {
            BufferedReader reader = request.getReader();
            while ((line = reader.readLine()) != null)
            {
                jb.append(line);
            }
        } 
        catch (IOException e) { /*report an error*/ }
        
        String json = jb.toString();
        System.out.println(json);        
        
        StringReader stringParser = new StringReader(json);
        //JsonParser parser = Json.createParser(stringParser);// Création d'un parser
        JsonReader reader = Json.createReader(stringParser);// Création d'un reader
        JsonObject JsonActeur = reader.readObject();// Création d'un objet   
        //System.out.println("JsonActeur = " + JsonActeur);
        
        JsonObject JsonFilm = JsonActeur.getJsonArray("films").getJsonObject(0);
        //System.out.println("JsonFilm = " + JsonFilm);
        Document Doc = Document.parse(json);        
        System.out.println("Doc = " + Doc);
        
        int IdActeur = JsonActeur.getInt("_id");
        System.out.println("IdActeur = " + IdActeur);
        int IdFilm = JsonFilm.getInt("_id");
        System.out.println("IdFilm = " + IdFilm);
        
        
        //parcourirModele(array, null, 0);
        
        Bean_DB_MongoDB BeanDB = new Bean_DB_MongoDB();         
        
        Document DocActeur = BeanDB.getActeur(IdActeur);        
        System.out.println("Acteur = " + DocActeur);
        
        if(DocActeur != null)
        {
            System.out.println("Je vérifie la filmo");
            Document Trouve = BeanDB.ChercherFilmDansFilmographieActeur(IdActeur, IdFilm);
            System.out.println("Trouve = " + Trouve);
            if(Trouve == null)
            {  
                Document DocFilm = Document.parse(JsonFilm.toString());
                System.out.println("DocFilm = " + DocFilm);
                if (DocFilm != null)
                {
                    BeanDB.InsererFilmDansFilmographie(IdActeur, DocFilm);
                }
                else
                    System.out.println("Problème de transformation en string pour le JsonObject Film !");
            }        
            
            response.setContentType("text/html;charset=UTF-8");
            try (PrintWriter out = response.getWriter()) 
            {
                out.println("ok");
            }
            catch (IOException ex) 
            {
                ex.printStackTrace();//Logger.getLogger(Servlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        else
        {            
            System.out.println("J'insere l'acteur");
            DocActeur = Document.parse(JsonActeur.toString());
            System.out.println("DocActeur = " + DocActeur);
            BeanDB.InsererActeur(DocActeur);
            
            response.setContentType("text/html;charset=UTF-8");
            try (PrintWriter out = response.getWriter()) 
            {
                out.println("ok");
            }
            catch (IOException ex) 
            {
                ex.printStackTrace();//Logger.getLogger(Servlet.class.getName()).log(Level.SEVERE, null, ex);
            }

        }
    }
    
    public static void parcourirModele(final JsonValue element, final String cle, final int niveau) 
    {
        String indentation = String.join("", Collections.nCopies(niveau, ".."));
        int niveauSuivant = niveau+1;
        if (cle != null) {
            System.out.print(indentation+"Key " + cle + ": ");
        }
        
        switch (element.getValueType()) 
        {
            case OBJECT:
                System.out.println(indentation+"Objet");
                JsonObject object = (JsonObject) element;
                object.keySet().forEach((nom) -> {
                    parcourirModele(object.get(nom), nom, niveauSuivant);
        });
                break;
            case ARRAY:
                System.out.println(indentation+"Tableau");
                JsonArray array = (JsonArray) element;
                array.forEach((val) -> {
                    parcourirModele(val, null, niveauSuivant);
        });
                break;
            case STRING:
                JsonString st = (JsonString) element;
                System.out.println(" String " + st.getString());
                break;
            case NUMBER:
                JsonNumber num = (JsonNumber) element;
                System.out.println(" Nombre " + num.toString());
                break;
            case TRUE:
            case FALSE:
            case NULL:
            System.out.println(" " +element.getValueType().toString());
            break;
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