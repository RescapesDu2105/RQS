/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package creaprog;

import java.io.IOException;
import java.util.ArrayList;

/**
 *
 * @author Doublon
 */
public class CreaProg {

    /**
     * @param args the command line arguments
     */
    private static final String CSVfile="D:\\GitHub\\RQS\\CC\\CreaProg\\";
    private static final String separator=";";    
    private static final String regex="(?<=;|^)([^;]*)(?=;|$)";
    
    public static void main(String[] args) 
    {        
        //CSVUtils test = new CSVUtils(CSVfile,separator,regex,true);
        CSVUtils test = new CSVUtils(CSVfile+args[0],separator,regex,true);
        ArrayList<Programmation> programmes = new ArrayList<>();
        CreateXML docXML ;
        boolean schemaValide;
        
        try
        {
            programmes=test.Lire();
            docXML=new CreateXML(programmes);
            docXML.CreateDocument();
            if(schemaValide=docXML.iSValidate())
                docXML.WriteFile();
            else
                System.out.println("Schema n'est pas valide !!");
            
        } catch (IOException ex)
        {
             System.out.println("Fichier introuvable");
        }      
    }
    
}
