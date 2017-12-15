/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Beans;

import Classes.Personne;

/**
 *
 * @author Philippe
 */
public class Acteur extends Personne
{
    private int Id;
    
    public Acteur(int Id, String Nom) 
    {
        super(Nom, null, null, null, null);
    }
    
    public Acteur(int Id, String Nom, String DateNaissance, String LieuNaissance, String DateDeces, String ImageProfil) 
    {
        super(Nom, DateNaissance, LieuNaissance, DateDeces, ImageProfil);
    }

    public int getId()
    {
        return Id;
    }

    public void setId(int Id)
    {
        this.Id = Id;
    }
}
