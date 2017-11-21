/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlet;

import Bean.Bean_DB_MongoDB;
import com.mongodb.util.JSON;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.StringReader;
import java.util.Arrays;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;
import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;
import javax.json.JsonReader;
import javax.json.JsonString;
import javax.json.stream.JsonParser;
import javax.json.stream.JsonParser.Event;
import static javax.json.stream.JsonParser.Event.KEY_NAME;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Philippe
 */
@WebServlet(name = "Servlet", urlPatterns = {"/VerifActeur_v1"})
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
        String [] Req ;
        //HttpSession session = request.getSession(true);
        
        String json = request.getReader().lines().collect(Collectors.joining(System.lineSeparator()));
        System.out.println(json);
        JsonParser parser = Json.createParser(new StringReader(json));// Création d'un parser
        JsonReader reader = Json.createReader(new StringReader(json));// Création d'un reader
        JsonObject object = reader.readObject();// Création d'un objet
        int idActeur = 0;
        boolean trouve=false;
        Event event = null; 
        
        /*while(!trouve && parser.hasNext())
        {   
            event = parser.next();
            if(event==KEY_NAME &&  parser.getString().equals("ID"))
            {
                event = parser.next();
                idActeur =  parser.getInt();
                trouve=true;
            }
        }
        System.out.println("IdActeur : "+ idActeur);*/
        
        while(!trouve && parser.hasNext())
        {   
            event = parser.next();
            if(event==KEY_NAME &&  parser.getString().equals("FILMS"))
            {
                //Array = object.getJsonArray("FILMS");
                trouve=true;
            }
        }
        
        System.out.println("");
        /*while (parser.hasNext()) 
        {
            event = parser.next();
            if(event == KEY_NAME && parser.getString().equals("FILMS"))
                System.out.println("trouve");
            System.out.print("event=" + event);
            switch (event) 
            {
                case KEY_NAME:
                    System.out.print(" cle=" + parser.getString());
                    break;
                
                case VALUE_STRING:
                    System.out.print(" valeur=" + parser.getString());
                    break;
                
                case VALUE_NUMBER:
                    if (parser.isIntegralNumber()) 
                    {
                        System.out.println(" valeur=" + parser.getInt());
                    }
                    else
                    {
                        System.out.println(" valeur=" + parser.getBigDecimal());
                    }
                    break;
                    
                case VALUE_NULL:
                    System.out.print(" valeur=null");
                    break;
            }
            System.out.println("");
        }
        /*Req=json.split("#");
        System.out.println(Req[0]);
        Bean_DB_MongoDB BeanDB = new Bean_DB_MongoDB();
         
        if(Req[0].equals("VERIFICATION"))
        {
            boolean trouve = BeanDB.ChercherActeur(Integer.parseInt(Req[1]));
            if(!trouve)
            {
                System.out.println("je Verifie");
                response.setContentType("text/html;charset=UTF-8");
                try (PrintWriter out = response.getWriter()) 
                {
                    out.println("ko");
                }
                catch (IOException ex) 
                {
                    ex.printStackTrace();//Logger.getLogger(Servlet.class.getName()).log(Level.SEVERE, null, ex);
                }  
            }
            else
            {
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
        else if(Req[0].equals("INSERTION"))
        {
            System.out.println("j'insere");
            BeanDB.VerifierActeur(Req[1]);
            response.setContentType("text/html;charset=UTF-8");
            try (PrintWriter out = response.getWriter()) 
            {
                System.out.println("je Verifie");
                out.println("ok");
            }
            catch (IOException ex) 
            {
                ex.printStackTrace();//Logger.getLogger(Servlet.class.getName()).log(Level.SEVERE, null, ex);
            }  
        }*/

        //BeanDB.VerifierActeur(json);
          
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
