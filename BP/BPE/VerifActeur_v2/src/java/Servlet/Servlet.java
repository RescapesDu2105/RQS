/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlet;

import Bean.Bean_DB_MongoDB;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.StringReader;
import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonReader;
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
        catch (IOException e) 
        { 
            System.exit(1);
        }
        
        String json = jb.toString();
        //String json = getBody(request, response);
        System.out.println(json);   
        
        //System.out.println("getBody() = " + getBody(request, response));      
                
        StringReader stringParser = new StringReader(json);
        JsonReader reader = Json.createReader(stringParser);// Création d'un reader
        JsonObject JsonObject = reader.readObject();// Création d'un objet
            
        Bean_DB_MongoDB BeanDB = new Bean_DB_MongoDB();   
        
        if(request.getParameter("action").equals("verification"))
        {
            JsonObject JsonFilm = JsonObject.getJsonArray("films").getJsonObject(0);        
            int IdActeur = JsonObject.getInt("_id");
            int IdFilm = JsonFilm.getInt("_id");
            
                System.out.println("IdActeur = " + IdActeur);
                System.out.println("IdFilm = " + IdFilm);
            
            Document DocActeur = BeanDB.getActeur(IdActeur);
            if(DocActeur != null)
            {
                System.out.println("Je vérifie la filmo");
                Document Trouve = BeanDB.ChercherFilmDansFilmographieActeur(IdActeur, IdFilm);
                    
                //System.out.println("Trouve = " + Trouve);
                
                if(Trouve == null)
                {  
                    Document DocFilm = Document.parse(JsonFilm.toString());
                    if (DocFilm != null)
                    {
                        System.out.println("J'insere dans la filmo : " + IdActeur + "/" + IdFilm);
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
                    ex.printStackTrace();
                }
            }
            else
            {            
                System.out.println("J'insere l'acteur : " + IdActeur);
                DocActeur = Document.parse(JsonObject.toString());
                BeanDB.InsererActeur(DocActeur);

                response.setContentType("text/html;charset=UTF-8");
                try (PrintWriter out = response.getWriter()) 
                {
                    out.println("ok");
                }
                catch (IOException ex) 
                {
                    ex.printStackTrace();
                }
            }
        }
        else // rollback
        {
            int IdActeur = JsonObject.getInt("_idAct");
            //System.out.println("IdActeur = " + IdActeur);
            int IdFilm = JsonObject.getInt("_idFilm");
            //System.out.println("IdFilm = " + IdFilm);
            
            Document DocActeur = BeanDB.getActeur(IdActeur);
            
            if(DocActeur != null)
            {
                System.out.println("Je retire le film de la filmo");      
                BeanDB.RemoveFilm(IdActeur, IdFilm);

                response.setContentType("text/html;charset=UTF-8");
                try (PrintWriter out = response.getWriter()) 
                {
                    out.println("ok");
                }
                catch (IOException ex) 
                {
                    ex.printStackTrace();
                }
            }
        }
    }
    
    public String getBody(HttpServletRequest request, HttpServletResponse response) throws IOException 
    {
        InputStream is = request.getInputStream();
        String body = null;

        response.setContentType("text/html;charset=UTF-8");
        try 
        {
           if (is != null) 
           {
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                byte[] buffer = new byte[32767];
                int read = 0;
                while ((read = is.read(buffer, 0, buffer.length)) != -1) {
                        baos.write(buffer, 0, read);
                }		
                baos.flush();		
                body = new String(baos.toByteArray());
           }
           else
           {
               System.err.println("Impossible de récupérer le flux de la requête");
               return null;
           }
       } 
       catch (IOException ex) 
       { 
           System.err.println("Erreur lors de la lecture : " + ex);
       } 
       finally 
       {
           if (is != null) 
           {
               try 
               {
                   is.close();
               } 
               catch (IOException ex)
               {
                    System.err.println("Erreur lors de la fermeture du flux : " + ex);
               }
           }
        }

        return body;
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