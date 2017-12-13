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
    public Acteur(String Nom, String Prenom, String DateNaissance, String LieuNaissance, String DateDeces, String ImageProfil) 
    {
        super(Nom, Prenom, DateNaissance, LieuNaissance, DateDeces, ImageProfil);
    }
}
