/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package creaprog;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.sql.Time;
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

    public Programmation(String complexe ,Date debut, Date fin, Integer film, Integer copie, Integer salle, Date heure) 
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
            SecureRandom prng = SecureRandom.getInstance("SHA1PRNG"); //TO DO : static
           setId(new Integer(prng.nextInt()).toString());
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
    
    public void setDebut(Date debut) 
    {
        this.debut = debut;
        System.out.println("debut : "+ debut);
    }

    public void setFin(Date fin) 
    {
        this.fin = fin;
        System.out.println("fin : "+ fin);
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
    
    public void setHeure(Date heure) 
    {
        this.heure = heure;
        System.out.println("heure : "+ heure);
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
