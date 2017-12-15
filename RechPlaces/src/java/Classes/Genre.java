/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Classes;

/**
 *
 * @author Philippe
 */
public class Genre //implements iGenre
{
    private String Nom;

    public Genre(String Nom) 
    {
        this.Nom = Nom;
    }
    
    
    public String getNom() 
    {
        return Nom;
    }

    public void setNom(String Nom) 
    {
        this.Nom = Nom;
    }
}
