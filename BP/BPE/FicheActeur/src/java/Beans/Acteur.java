package Beans;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.Serializable;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.util.Locale;

/**
 *
 * @author Philippe
 */
public class Acteur implements Serializable {
    
   private String Nom;
    private String Prenom;
    private String DateNaissance;
    private String LieuNaissance;
    private String DateDeces;
    private String ImageProfil;

    public Acteur(String Nom, String Prenom, String DateNaissance, String LieuNaissance, String DateDeces, String ImageProfil) 
    {
        this.Nom = Nom;
        this.Prenom = Prenom;
        this.DateNaissance = DateNaissance;
        this.LieuNaissance = LieuNaissance;
        this.DateDeces = DateDeces;
        this.ImageProfil = ImageProfil;
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
        return Nom;
    }

    public void setNom(String Nom) {
        this.Nom = Nom;
    }

    public String getPrenom() {
        return Prenom;
    }

    public void setPrenom(String Prenom) {
        this.Prenom = Prenom;
    }

    public String getDateNaissance() {
        return DateNaissance;
    }

    public void setDateNaissance(String DateNaissance) {
        this.DateNaissance = DateNaissance;
    }

    public String getLieuNaissance() {
        return LieuNaissance;
    }

    public void setLieuNaissance(String LieuNaissance) {
        this.LieuNaissance = LieuNaissance;
    }

    public String getDateDeces() {
        return DateDeces;
    }

    public void setDateDeces(String DateDeces) {
        this.DateDeces = DateDeces;
    }

    public String getImageProfil() {
        return ImageProfil;
    }

    public void setImageProfil(String ImageProfil) {
        this.ImageProfil = ImageProfil;
    }
    
}
