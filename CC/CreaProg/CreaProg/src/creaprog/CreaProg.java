/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package creaprog;

import java.io.IOException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Doublon
 */
public class CreaProg {

    /**
     * @param args the command line arguments
     */
    private static final String CSVfile="D:\\GitHub\\RQS\\CC\\CreaProg\\Programmation.csv";
    private static final String separator=";";
    private static final String regex="(?<=;|^)([^;]*)(?=;|$)";
    
    public static void main(String[] args) 
    {        
        //CSVUtils test = new CSVUtils(CSVfile,separator,regex,true);
        System.out.println("args = " + args[0]);
        CSVUtils test = new CSVUtils(args[0],separator,regex,true);
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
            Logger.getLogger(CreaProg.class.getName()).log(Level.SEVERE, null, ex);
        }      
    }
    
}
