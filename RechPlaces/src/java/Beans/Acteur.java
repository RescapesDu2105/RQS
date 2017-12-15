/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Beans;

import Classes.JouerFilm;
import Classes.Personne;
import java.util.ArrayList;

/**
 *
 * @author Philippe
 */
public class Acteur extends Personne
{
    private int Id;
    private String Role;
    private final ArrayList<JouerFilm> Filmographie;
    
    public Acteur()
    {        
        super(null, null, null, null, null);
        this.Filmographie = new ArrayList<>();
    }
    
    public Acteur(int Id, String Nom, String Role) 
    {
        super(Nom, null, null, null, null);
        this.Filmographie = new ArrayList<>();
        this.Id = Id;
        this.Role = Role;
    }
    
    public Acteur(int Id, String Nom, String DateNaissance, String LieuNaissance, String DateDeces, String ImageProfil, String Role) 
    {
        super(Nom, DateNaissance, LieuNaissance, DateDeces, ImageProfil);
        this.Filmographie = new ArrayList<>();
        this.Id = Id;
        this.Role = Role;
    }

    public int getId()
    {
        return Id;
    }

    public void setId(int Id)
    {
        this.Id = Id;
    }

    public String getRole()
    {
        return Role;
    }

    public void setRole(String Role)
    {
        this.Role = Role;
    }

    public ArrayList<JouerFilm> getFilmographie()
    {
        return Filmographie;
    }
    
}
