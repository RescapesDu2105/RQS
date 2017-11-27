package Beans;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.Serializable;
import java.util.ArrayList;

/**
 *
 * @author Philippe
 */
public class Films implements Serializable 
{
    private final ArrayList<Film> Films;
    
    public Films()
    {
        this.Films = new ArrayList<>();        
    }

    public Film getFilm(int idFilm)
    {
        Film Film = null; 
        boolean Trouve = false;
        
        for(int i = 0 ; i < getFilms().size() && !Trouve ; i++)
        {
            if(Films.get(i).getIdFilm() == idFilm)
                Trouve = true;
        }
        
        return Film;
    }
    
    public ArrayList<Film> getFilms() 
    {
        return Films;
    }
}
