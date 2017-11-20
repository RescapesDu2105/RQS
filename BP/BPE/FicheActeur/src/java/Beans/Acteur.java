package Beans;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.Serializable;
import java.text.DateFormat;
import java.util.Locale;

/**
 *
 * @author Philippe
 */
public class Acteur implements Serializable {
    
    private String nom;
    private String prenom;
    private String dateNaissance;
    private String lieuNaissance;
    private String dateDeces;
    private String imageProfil;

    public Acteur()
    {
        
    }
    
    public Acteur(String Nom, String Prenom, String DateNaissance, String LieuNaissance, String DateDeces, String ImageProfil) 
    {
        this.nom = Nom;
        this.prenom = Prenom;
        this.dateNaissance = DateNaissance;
        this.lieuNaissance = LieuNaissance;
        this.dateDeces = DateDeces;
        this.imageProfil = ImageProfil;
    }
    
    public String getDateNaissance(Locale locale)
    {
        return DateFormat.getDateTimeInstance(DateFormat.SHORT, DateFormat.SHORT, locale).format(getDateNaissance());
    }
    
    public String getDateDeces(Locale locale)
    {
        return DateFormat.getDateTimeInstance(DateFormat.SHORT, DateFormat.SHORT, locale).format(getDateNaissance());
    }
    
    public String getURLImageProfil() 
    {    
        return getImageProfil() != null ? "http://image.tmdb.org/t/p/w185" + getImageProfil() : "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/No_free_image_man_%28en%29.svg/256px-No_free_image_man_%28en%29.svg.png";
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String Nom) {
        this.nom = Nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String Prenom) {
        this.prenom = Prenom;
    }

    public String getDateNaissance() {
        return dateNaissance;
    }

    public void setDateNaissance(String DateNaissance) {
        this.dateNaissance = DateNaissance;
    }

    public String getLieuNaissance() {
        return lieuNaissance;
    }

    public void setLieuNaissance(String LieuNaissance) {
        this.lieuNaissance = LieuNaissance;
    }

    public String getDateDeces() {
        return dateDeces;
    }

    public void setDateDeces(String DateDeces) {
        this.dateDeces = DateDeces;
    }

    public String getImageProfil() {
        return imageProfil;
    }

    public void setImageProfil(String ImageProfil) {
        this.imageProfil = ImageProfil;
    }
    
}
