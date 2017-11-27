/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package creaprog;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Time;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *
 * @author Doublon
 */


public class CSVUtils {

    protected String csvFile;
    protected String separator;
    protected String regex;
    protected boolean skipFirstLine;

    public CSVUtils(String csvFile, String separator, String regex, boolean skipFirstLine) 
    {
        setCsvFile(csvFile);
        setSeparator(separator);
        setRegex(regex);
        setSkipFirstLine(skipFirstLine);
    }
    
    public String getCsvFile() 
    {
        return csvFile;
    }

    public String getSeparator() 
    {
        return separator;
    }

    public String getRegex() 
    {
        return regex;
    }

    public boolean isSkipFirstLine() 
    {
        return skipFirstLine;
    }

    public void setCsvFile(String csvFile) 
    {
        this.csvFile = csvFile;
    }

    public void setSeparator(String separator) 
    {
        this.separator = separator;
    }

    public void setRegex(String regex) 
    {
        this.regex = regex;
    }

    public void setSkipFirstLine(boolean skipFirstLine) 
    {
        this.skipFirstLine = skipFirstLine;
    }
    
    public ArrayList<Programmation> Lire() throws FileNotFoundException, IOException
    {
        ArrayList<Programmation> programmes = new ArrayList<>();
        ArrayList<String> split ;
        DateFormat formatterTime = new SimpleDateFormat("HH:mm");
        
        try (BufferedReader br = new BufferedReader(new FileReader(getCsvFile()))) 
        {
            String line;
            if(isSkipFirstLine())
            {
                br.readLine(); 
            }
            
            Pattern p = Pattern.compile(regex);

            while ((line = br.readLine()) != null) 
            {
                split = new ArrayList<>();
                Matcher m = p.matcher(line.trim());
            
                Programmation pr;
                     
                while (m.find()) 
                {
                    if (!m.group().isEmpty()) 
                    {
                        split.add(m.group());              
                    }
                }
                
                if(split.size() != 7)
                {
                    System.out.println("Trop de champ");
                    //System.exit(0);
                }
                else
                {
                    pr = new Programmation(split.get(0), split.get(1), split.get(2), Integer.parseInt(split.get(3)), 
                            Integer.parseInt(split.get(4)), Integer.parseInt(split.get(5)), split.get(6));
                    programmes.add(pr);
                }
            }
            br.close();
        }
        return programmes;
        
    }
     
}
