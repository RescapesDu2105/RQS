/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package creaprog;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.sql.Time;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Doublon
 */
public class Programmation 
{
    protected String complexe ;
    protected Date debut ;
    protected Date fin ;
    protected Integer film ;
    protected Integer copie ;
    protected Integer salle ;
    protected Date heure;
    protected String id  ;

    public Programmation(String complexe ,String debut, String fin, Integer film, Integer copie, Integer salle, String heure) 
    {
        setComplexe(complexe);
        setDebut(debut);
        setFin(fin);
        setFilm(film);
        setCopie(copie);
        setSalle(salle);
        setHeure(heure);
        generateId();
    }
    
    private void generateId() 
    {
        try 
        {
            SecureRandom prng = SecureRandom.getInstance("SHA1PRNG");
            setId(new Integer(Math.abs(prng.nextInt())).toString());
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(Programmation.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void setComplexe(String complexe)
    {
        this.complexe = complexe;
    }

    
    public void setSalle(Integer salle) 
    {
        this.salle = salle;
        System.out.println("Salle : "+ salle);
    }

    public void setId(String id) 
    {
        this.id = id;
        System.out.println("id : "+ id);
    }
    
    public void setDebut(String debut) 
    {
        try
        {
            SimpleDateFormat formatterDate = new SimpleDateFormat("dd/mm/yyyy");
            this.debut=formatterDate.parse(debut);
            
            //String strDate = formatterDate.format(this.debut);
            //System.out.println("debut : " + strDate);
            //System.out.println(formatterDate.parse(debut));
            
        } catch (ParseException ex)
        {
            Logger.getLogger(Programmation.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void setFin(String fin) 
    {
        try
        {
            SimpleDateFormat formatterDate = new SimpleDateFormat("dd/mm/yyyy");
            this.fin=formatterDate.parse(fin);
        } catch (ParseException ex)
        {
            Logger.getLogger(Programmation.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void setFilm(Integer film) 
    {
        this.film = film;
        System.out.println("film : "+ film);
    }

    public void setCopie(Integer copie) 
    {
        this.copie = copie;
        System.out.println("copie : "+ copie);
    }
    
    public void setHeure(String heure) 
    {
        
        try
        {
            DateFormat formatterTime = new SimpleDateFormat("HH:mm");
            this.heure=formatterTime.parse(heure);
            
            String strDate = formatterTime.format(this.heure);
            System.out.println("heure : " + strDate);
        } catch (ParseException ex)
        {
            Logger.getLogger(Programmation.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public Date getDebut() 
    {
        return debut;
    }

    public Date getFin() 
    {
        return fin;
    }

    public Integer getFilm() 
    {
        return film;
    }

    public Integer getCopie() 
    {
        return copie;
    }

    public Integer getSalle() 
    {
        return salle;
    }

    public Date getHeure() 
    {
        return heure;
    }

    public String getId() 
    {
        return id;
    }

    public String getComplexe()
    {
        return complexe;
    }   
}
