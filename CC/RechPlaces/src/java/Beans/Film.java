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
    private int popularite;
    private int perennite;
    private ArrayList<Acteur> acteurs;
    private ArrayList<Realisateur> realisateurs;
    private String resume;
    private ArrayList<Genre> genres;
    private String publicCible;

    public Film() 
    {
    }

    public Film(int idFilm, String posterPath, String title, int popularite, int perennite, ArrayList<Acteur> acteurs, ArrayList<Realisateur> realisateurs, String resume, ArrayList<Genre> genres, String publicCible) 
    {
        this.idFilm = idFilm;
        this.posterPath = "http://image.tmdb.org/t/p/w185" + posterPath;
        this.title = title;
        this.popularite = popularite;
        this.perennite = perennite;
        this.acteurs = acteurs;
        this.realisateurs = realisateurs;
        this.resume = resume;
        this.genres = genres;
        this.publicCible = publicCible;
    }

    public void setTaillePoster(String Taille)
    {
        if(getPosterPath() != null)
            setPosterPath(getPosterPath().replaceFirst("w\\d{3}", Taille));
    }

    public ArrayList<Genre> getGenres() {
        return genres;
    }

    public void setGenres(ArrayList<Genre> genres) {
        this.genres = genres;
    }

    public String getPublicCible() {
        return publicCible;
    }

    public void setPublicCible(String publicCible) {
        this.publicCible = publicCible;
    }

    
    public ArrayList<Realisateur> getRealisateurs() {
        return realisateurs;
    }

    public void setRealisateurs(ArrayList<Realisateur> realisateurs) {
        this.realisateurs = realisateurs;
    }

    public String getResume() {
        return resume;
    }

    public void setResume(String resume) {
        this.resume = resume;
    }

    public ArrayList<Acteur> getActeurs() {
        return acteurs;
    }

    public void setActeurs(ArrayList<Acteur> acteurs) {
        this.acteurs = acteurs;
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
}
