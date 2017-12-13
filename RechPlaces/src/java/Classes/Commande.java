/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Classes;

import Beans.Film;

/**
 *
 * @author Philippe
 */
public class Commande
{
    private Film Film;
    private int NbPlaces;

    public Commande()
    {
        Film = null;
        NbPlaces = 0;
    }

    public Commande(Film Film, int NbPlaces)
    {
        this.Film = Film;
        this.NbPlaces = NbPlaces;
    }

        
    public void setFilm(Film Film)
    {
        this.Film = Film;
    }

    public void setNbPlaces(int NbPlaces)
    {
        this.NbPlaces = NbPlaces;
    }
    
    public Film getFilm()
    {
        return Film;
    }

    public int getNbPlaces()
    {
        return NbPlaces;
    }    
}
