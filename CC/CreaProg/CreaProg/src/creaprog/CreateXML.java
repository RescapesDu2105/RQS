/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package creaprog;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

/**
 *
 * @author Doublon
 */
public class CreateXML
{
    protected ArrayList<Programmation> programmation;
    protected Document doc;
   
    public CreateXML(ArrayList<Programmation> programmation)
    {
        setProgrammation(programmation);
    }
    
    public ArrayList<Programmation> getProgrammation()
    {
        return programmation;
    }

    public void setProgrammation(ArrayList<Programmation> programmation)
    {
        this.programmation = programmation;
    }
    
    public void CreateDocument()
    {
        try 
        {
            SimpleDateFormat formatterDate = new SimpleDateFormat("dd/mm/yyyy");
            DateFormat formatterTime = new SimpleDateFormat("HH:mm");
            String strDate , strTime;
            
            DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
            
            // root elements
            doc = docBuilder.newDocument();
            Element rootElement = doc.createElement("programmation");
            doc.appendChild(rootElement);

            for(Programmation pr : programmation)
            {
                Element proj = doc.createElement("demande");

                //Element id = doc.createElement("idDemande");
                proj.setAttribute("idDemande", pr.getId());

                strDate=formatterDate.format(pr.getDebut().toString());
                Element debut = doc.createElement("debut");
                debut.appendChild(doc.createTextNode(strDate));

                strDate=formatterDate.format(pr.getFin().toString());
                Element fin = doc.createElement("fin");
                fin.appendChild(doc.createTextNode(strDate));

                Element film = doc.createElement("idMovie"); 
                film.appendChild(doc.createTextNode(pr.getFilm().toString()));

                Element copie = doc.createElement("numCopy");
                copie.appendChild(doc.createTextNode(pr.getCopie().toString()));
                Element salle = doc.createElement("salle");
                salle.appendChild(doc.createTextNode(pr.getSalle().toString()));
                
                strTime=formatterTime.format(pr.getHeure().toString());
                Element heure = doc.createElement("heure");
                heure.appendChild(doc.createTextNode(strTime));

                //proj.appendChild(id);
                proj.appendChild(film);
                proj.appendChild(copie);
                proj.appendChild(debut);
                proj.appendChild(fin);
                proj.appendChild(salle);
                proj.appendChild(heure);
                rootElement.appendChild(proj);
            }   
        } catch (ParserConfigurationException ex)
        {
            Logger.getLogger(CreateXML.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
}
