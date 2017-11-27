/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Beans;

import java.io.Serializable;
import java.text.DateFormat;
import java.util.Locale;

/**
 *
 * @author Philippe
 */
public class Film implements Serializable {
    
    private String Title;
    private String Original_Title;
    private String Poster_Path;
    private String Release_Date;
    private String Character;

        
    public Film(String Title, String Original_Title, String Poster_Path, String Release_Date, String Character) 
    {
        this.Title = Title;
        this.Original_Title = Original_Title;
        this.Poster_Path = Poster_Path;
        this.Release_Date = Release_Date;
        this.Character = Character;
    }
    
    public String getRelease_Date(Locale locale)
    {
        return DateFormat.getDateTimeInstance(DateFormat.SHORT, DateFormat.SHORT, locale).format(getRelease_Date());
    }

    public String getTitle() {
        return Title;
    }

    public void setTitle(String Title) {
        this.Title = Title;
    }

    public String getOriginal_Title() {
        return Original_Title;
    }

    public void setOriginal_Title(String Original_Title) {
        this.Original_Title = Original_Title;
    }

    public String getPoster_Path() {
        return Poster_Path;
    }

    public void setPoster_Path(String Poster_Path) {
        this.Poster_Path = Poster_Path;
    }

    public String getRelease_Date() {
        return Release_Date;
    }

    public void setRelease_Date(String Release_Date) {
        this.Release_Date = Release_Date;
    }

    public String getCharacter() {
        return Character;
    }

    public void setCharacter(String Character) {
        this.Character = Character;
    }
    
}
