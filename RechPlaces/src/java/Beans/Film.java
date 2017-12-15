/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Beans;

import Classes.Genre;
import Classes.Tailles_Posters;
import java.io.Serializable;
import java.util.ArrayList;

/**
 *
 * @author Philippe
 */
public class Film implements Tailles_Posters, Serializable
{
    private int idFilm;
    private String posterPath;
    private String title;
    private String originalTitle;
    private int popularite;
    private int perennite;
    private final ArrayList<Acteur> acteurs;
    private final ArrayList<Realisateur> realisateurs;
    private final ArrayList<Genre> genres;
    private String certification;
    private float voteAverage;
    private int voteCount;
    private int duree;
    private int budget;
    private String dateReal;
    //private ArrayList<Seance> Seances;

    public Film(int idFilm, String posterPath, String title, String originalTitle, int popularite, int perennite, String certification, float voteAverage, int voteCount, int duree, int budget, String dateReal)
    {
        this.idFilm = idFilm;
        this.posterPath = "http://image.tmdb.org/t/p/w185" + posterPath;
        this.title = title;
        this.originalTitle = originalTitle;
        this.popularite = popularite;
        this.perennite = perennite;
        this.certification = certification;
        this.voteAverage = voteAverage;
        this.voteCount = voteCount;
        this.duree = duree;
        this.budget = budget;
        this.dateReal = dateReal;
        
        this.acteurs = new ArrayList<>();
        this.realisateurs = new ArrayList<>();
        this.genres = new ArrayList<>();
    }
   
    
    public void setTaillePoster(String Taille)
    {
        if(getPosterPath() != null)
            setPosterPath(getPosterPath().replaceFirst("w\\d{3}", Taille));
    }

    public ArrayList<Genre> getGenres() {
        return genres;
    }

    public String getCertification() {
        return certification;
    }

    public void setCertification(String certification) {
        this.certification = certification;
    }
    
    public ArrayList<Realisateur> getRealisateurs() {
        return realisateurs;
    }
    public ArrayList<Acteur> getActeurs() {
        return acteurs;
    }
    public int getIdFilm() {
        return idFilm;
    }

    public void setIdFilm(int idFilm) {
        this.idFilm = idFilm;
    }
    
    public String getPosterPath() {
        return posterPath;
    }

    public void setPosterPath(String posterPath) {
        this.posterPath = posterPath;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getPopularite() {
        return popularite;
    }

    public void setPopularite(int popularite) {
        this.popularite = popularite;
    }

    public int getPerennite() {
        return perennite;
    }

    public void setPerennite(int perennite) {
        this.perennite = perennite;
    }

    public float getVoteAverage()
    {
        return voteAverage;
    }

    public void setVoteAverage(float voteAverage)
    {
        this.voteAverage = voteAverage;
    }

    public int getVoteCount()
    {
        return voteCount;
    }

    public void setVoteCount(int voteCount)
    {
        this.voteCount = voteCount;
    }

    public int getDuree()
    {
        return duree;
    }

    public void setDuree(int duree)
    {
        this.duree = duree;
    }

    public int getBudget()
    {
        return budget;
    }

    public void setBudget(int budget)
    {
        this.budget = budget;
    }

    public String getOriginalTitle()
    {
        return originalTitle;
    }

    public void setOriginalTitle(String originalTitle)
    {
        this.originalTitle = originalTitle;
    }    
}
