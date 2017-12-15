/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Classes;

import java.text.DateFormat;
import java.util.Locale;

/**
 *
 * @author Philippe
 */
public class JouerFilm implements Tailles_Posters
{
    private String title;
    private String originalTitle;
    private String posterPath;
    private String releaseDate;
    private String character;
    
    public JouerFilm(String Title, String Original_Title, String Poster_Path,/* String Release_Date,*/ String Character) 
    {
        this.title = Title;
        this.originalTitle = Original_Title;
        this.posterPath = Poster_Path;
        //this.releaseDate = Release_Date;
        this.character = Character;
    }
    
    public String getRelease_Date(Locale locale)
    {
        return DateFormat.getDateTimeInstance(DateFormat.SHORT, DateFormat.SHORT, locale).format(getReleaseDate());
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String Title) {
        this.title = Title;
    }

    public String getOriginalTitle() {
        return originalTitle;
    }

    public void setOriginalTitle(String Original_Title) {
        this.originalTitle = Original_Title;
    }

    public String getPosterPath(String taille) 
    {
        
        return posterPath != null ? "http://image.tmdb.org/t/p/" + taille + posterPath : null;
    }

    public void setPosterPath(String Poster_Path) {
        this.posterPath = Poster_Path;
    }

    public String getReleaseDate() {
        return releaseDate;
    }

    public void setReleaseDate(String Release_Date) {
        this.releaseDate = Release_Date;
    }

    public String getCharacter() {
        return character;
    }

    public void setCharacter(String Character) {
        this.character = Character;
    }
}
