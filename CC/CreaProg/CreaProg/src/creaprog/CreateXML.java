/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package creaprog;

import java.io.File;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.SAXException;
import creaprog.Programmation;
import javax.xml.transform.OutputKeys;

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
                //System.out.println("id : "+pr.getId());

                Element complexe = doc.createElement("complexe");
                complexe.appendChild(doc.createTextNode(pr.getComplexe()));
                //System.out.println("complexe : "+pr.getComplexe());
                
                strDate=formatterDate.format(pr.getDebut());
                Element debut = doc.createElement("debut");
                debut.appendChild(doc.createTextNode(strDate));
                //System.out.println("strDate : "+strDate);

                strDate=formatterDate.format(pr.getFin());
                Element fin = doc.createElement("fin");
                fin.appendChild(doc.createTextNode(strDate));
                //System.out.println("strDate : "+strDate);
                
                Element film = doc.createElement("movie"); 
                film.appendChild(doc.createTextNode(pr.getFilm().toString()));
                //System.out.println("film : "+pr.getFilm().toString());

                Element copie = doc.createElement("copy");
                copie.appendChild(doc.createTextNode(pr.getCopie().toString()));
                //System.out.println("copie : "+pr.getCopie().toString());
                
                Element salle = doc.createElement("salle");
                salle.appendChild(doc.createTextNode(pr.getSalle().toString()));
                //System.out.println("salle : "+pr.getSalle().toString());
                
                strTime=formatterTime.format(pr.getHeure());
                Element heure = doc.createElement("heure");
                heure.appendChild(doc.createTextNode(strTime));
                //System.out.println("strTime : "+strTime);

                //proj.appendChild(id);
                proj.appendChild(complexe);
                proj.appendChild(debut);
                proj.appendChild(fin);
                proj.appendChild(film);
                proj.appendChild(copie);
                proj.appendChild(salle);
                proj.appendChild(heure);
                rootElement.appendChild(proj);
            }   
        } catch (ParserConfigurationException ex)
        {
            Logger.getLogger(CreateXML.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public boolean iSValidate()
    {
        try 
        {
            SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
            File xsd = new File("D:\\GitHub\\RQS\\CC\\CreaCC\\XSD\\listeprogrammation.xsd");
            if(!xsd.exists())
            {
                System.out.println("Fichier XSD non trouvé !");
                System.exit(1);
            }
            Source schemaFile = new StreamSource(xsd);
            Schema schema = factory.newSchema(schemaFile);

            Validator validator = schema.newValidator();


            validator.validate(new DOMSource(doc));
            System.out.println("Fichier XML validé");
            
            return true;
            
        } 
        catch (SAXException ex)
        {
            System.out.println("Problème pour parser !");
            System.exit(1);
        }
        catch (IOException ex)
        {
            System.out.println("Problème avec le fichier XSD !");   
            System.exit(1);
        }

        System.out.println("Fichier XML non validé !");
        System.exit(1);
        
        return false;
    }
    
    public void WriteFile()
    {
        try
        {
            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            Transformer transformer = transformerFactory.newTransformer();
            transformer.setOutputProperty(OutputKeys.INDENT,"yes");
            transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount","4");
            DOMSource source = new DOMSource(doc);        
            StreamResult result = new StreamResult(new File("D:\\GitHub\\RQS\\CC\\CreaCC\\XSD\\programmations.xml"));
            transformer.transform(source, result);
            
            //StreamResult consoleResult = new StreamResult(System.out);
            //transformer.transform(source, consoleResult);
            System.out.println("Fichier XML créé !");   
        } 
        catch (TransformerException ex)
        {
            System.out.println("Problème transformer le CSV en XML !");            
            System.exit(1);
        } 
    }
}
