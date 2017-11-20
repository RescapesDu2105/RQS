/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Beans;

import java.io.Serializable;
import java.util.ArrayList;

/**
 *
 * @author Philippe
 */
public class Films implements Serializable {
    
    ArrayList<Film> Filmographie;

    public Films() 
    {
        this.Filmographie = new ArrayList<>();
    }
    
    public Films(ArrayList<Film> Films)
    {
        this.Filmographie = Films;        
    }

    public ArrayList<Film> getFilmographie() {
        return Filmographie;
    }

    public void setFilmographie(ArrayList<Film> Filmographie) {
        this.Filmographie = Filmographie;
    }
}
